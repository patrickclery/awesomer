# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchGithubStatsJob, type: :job do
  let(:owner) { 'octocat' }
  let(:repo_name) { 'Hello-World' }
  let(:category_item_data) do
    {
      description: 'A test repository',
      id: 1,
      name: 'Hello World',
      url: 'https://github.com/octocat/Hello-World'
    }
  end
  let(:rate_limiter) { instance_double(GithubRateLimiterService) }
  let(:octokit_client) { instance_double(Octokit::Client) }

  before do
    allow(GithubRateLimiterService).to receive(:new).and_return(rate_limiter)
    allow(Octokit::Client).to receive(:new).and_return(octokit_client)
    allow(octokit_client).to receive(:auto_paginate=)
  end

  describe '#perform' do
    context 'when rate limit allows request' do
      let(:repo_data) do
        # rubocop:disable RSpec/VerifiedDoubles
        double(
          pushed_at: Time.parse('2023-01-01T12:00:00Z'),
          stargazers_count: 1000
        )
        # rubocop:enable RSpec/VerifiedDoubles
      end

      before do
        allow(rate_limiter).to receive(:can_make_request?).and_return(true)
        allow(rate_limiter).to receive(:record_request)
        allow(octokit_client).to receive(:repository).and_return(repo_data)
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(Rails.cache).to receive(:write)
      end

      it 'fetches and caches repository stats' do
        expect(octokit_client).to receive(:repository).with("#{owner}/#{repo_name}")
        expect(Rails.cache).to receive(:write).with(
          "github_stats:#{owner}:#{repo_name}",
          {last_commit_at: Time.parse('2023-01-01T12:00:00Z'), stars: 1000},
          expires_in: 1.month
        )
        expect(rate_limiter).to receive(:record_request).with(success: true)

        described_class.new.perform(
          category_item_data:,
          owner:,
          repo_name:
        )
      end

      it 'creates a GithubApiRequest record' do
        expect {
          described_class.new.perform(
            category_item_data:,
            owner:,
            repo_name:
          )
        }.to change(GithubApiRequest, :count).by(1)

        request = GithubApiRequest.last
        expect(request.endpoint).to eq("/repos/#{owner}/#{repo_name}")
        expect(request.response_status).to eq(200)
        expect(request.owner).to eq(owner)
        expect(request.repo).to eq(repo_name)
      end
    end

    context 'when rate limit is exceeded' do
      before do
        allow(rate_limiter).to receive_messages(can_make_request?: false, time_until_reset: 300)
      end

      it 'raises TooManyRequests exception to trigger retry_on' do
        job = described_class.new

        expect {
          job.perform(
            category_item_data:,
            owner:,
            repo_name:
          )
        }.to raise_error(Octokit::TooManyRequests)
      end
    end

    context 'when repository is cached' do
      let(:cached_stats) { {last_commit_at: Time.parse('2023-01-01T10:00:00Z'), stars: 500} }

      before do
        allow(rate_limiter).to receive(:can_make_request?).and_return(true)
        allow(Rails.cache).to receive(:read).and_return(cached_stats)
        allow(Rails.cache).to receive(:write)
      end

      it 'uses cached data without making API request' do
        expect(octokit_client).not_to receive(:repository)
        expect(Rails.cache).to receive(:write).with(
          "category_item_update:#{category_item_data[:id]}",
          hash_including(stats: cached_stats),
          expires_in: 1.hour
        )

        described_class.new.perform(
          category_item_data:,
          owner:,
          repo_name:
        )
      end
    end

    context 'when repository is not found' do
      before do
        allow(rate_limiter).to receive(:can_make_request?).and_return(true)
        allow(rate_limiter).to receive(:record_request)
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(octokit_client).to receive(:repository).and_raise(Octokit::NotFound)
      end

      it 'handles the error gracefully' do
        expect(rate_limiter).to receive(:record_request).with(success: false)
        expect(Rails.logger).to receive(:warn).with(/Repository not found/)

        expect {
          described_class.new.perform(
            category_item_data:,
            owner:,
            repo_name:
          )
        }.to change(GithubApiRequest, :count).by(1)

        request = GithubApiRequest.last
        expect(request.response_status).to eq(404)
      end
    end

    context 'when rate limited by GitHub' do
      let(:rate_limit_error) do
        error = Octokit::TooManyRequests.new
        allow(error).to receive(:response_headers).and_return({'retry-after' => '3600'})
        error
      end

      before do
        allow(rate_limiter).to receive(:can_make_request?).and_return(true)
        allow(rate_limiter).to receive(:record_request)
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(octokit_client).to receive(:repository).and_raise(rate_limit_error)
      end

      it 'records the error and re-raises for retry_on handling' do
        job = described_class.new

        expect {
          job.perform(
            category_item_data:,
            owner:,
            repo_name:
          )
        }.to raise_error(Octokit::TooManyRequests)

        # Verify the error was recorded
        request = GithubApiRequest.last
        expect(request.response_status).to eq(429)
      end
    end
  end
end
