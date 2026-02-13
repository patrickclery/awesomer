# frozen_string_literal: true

require 'rails_helper'
require 'ostruct'

RSpec.describe SnapshotStarsOperation do
  let(:operation) { described_class.new }
  let(:rate_limiter) { instance_double(GithubRateLimiterService, can_make_request?: true, record_request: nil, wait_if_needed: nil) }

  before do
    allow(GithubRateLimiterService).to receive(:new).and_return(rate_limiter)
  end

  def graphql_response(repo_data)
    data = OpenStruct.new(repo_data.transform_keys(&:to_sym).transform_values { |v|
      v.nil? ? nil : OpenStruct.new(v.transform_keys(&:to_sym))
    })
    OpenStruct.new(data: data)
  end

  describe '#call' do
    context 'with repos to snapshot' do
      let!(:repo1) { create(:repo, github_repo: 'facebook/react') }
      let!(:repo2) { create(:repo, github_repo: 'torvalds/linux') }

      example 'creates star snapshots for repos via GraphQL' do
        response = graphql_response(
          'repo0' => { 'stargazerCount' => 230_000, 'pushedAt' => '2026-02-11T08:00:00Z' },
          'repo1' => { 'stargazerCount' => 50_000, 'pushedAt' => '2026-02-10T12:00:00Z' }
        )

        client = instance_double(Octokit::Client)
        allow(Octokit::Client).to receive(:new).and_return(client)
        allow(client).to receive(:post).and_return(response)

        result = operation.call

        expect(result).to be_success
        expect(StarSnapshot.count).to eq(2)
        expect(repo1.reload.stars).to eq(230_000)
        expect(repo2.reload.stars).to eq(50_000)
      end

      example 'is idempotent - does not create duplicate snapshots for same day' do
        create(:star_snapshot, repo: repo1, stars: 49_000, snapshot_date: Date.current)

        response = graphql_response(
          'repo0' => { 'stargazerCount' => 230_000, 'pushedAt' => '2026-02-11T08:00:00Z' },
          'repo1' => { 'stargazerCount' => 50_000, 'pushedAt' => '2026-02-10T12:00:00Z' }
        )

        client = instance_double(Octokit::Client)
        allow(Octokit::Client).to receive(:new).and_return(client)
        allow(client).to receive(:post).and_return(response)

        operation.call

        expect(StarSnapshot.where(repo: repo1, snapshot_date: Date.current).count).to eq(1)
        expect(StarSnapshot.find_by(repo: repo1, snapshot_date: Date.current).stars).to eq(230_000)
      end

      example 'handles deleted repos gracefully (null in GraphQL response)' do
        response = graphql_response(
          'repo0' => nil,
          'repo1' => { 'stargazerCount' => 50_000, 'pushedAt' => '2026-02-10T12:00:00Z' }
        )

        client = instance_double(Octokit::Client)
        allow(Octokit::Client).to receive(:new).and_return(client)
        allow(client).to receive(:post).and_return(response)

        result = operation.call

        expect(result).to be_success
        expect(StarSnapshot.count).to eq(1)
      end
    end

    context 'with no repos' do
      example 'returns success with zero count' do
        result = operation.call
        expect(result).to be_success
      end
    end
  end
end
