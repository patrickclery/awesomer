# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchStarHistoryJob, type: :job do
  let(:category_item) { create(:category_item, :with_stats, github_repo: 'octocat/Hello-World', stars: 500) }
  let(:rate_limiter) { instance_double(GithubRateLimiterService) }
  let(:octokit_client) { instance_double(Octokit::Client) }

  before do
    allow(GithubRateLimiterService).to receive(:new).and_return(rate_limiter)
    allow(Octokit::Client).to receive(:new).and_return(octokit_client)
  end

  describe '#perform' do
    context 'when fetching star history successfully' do
      let(:stargazers_response) do
        [
          double(starred_at: 10.days.ago.iso8601),
          double(starred_at: 20.days.ago.iso8601),
          double(starred_at: 45.days.ago.iso8601),
          double(starred_at: 60.days.ago.iso8601),
          double(starred_at: 120.days.ago.iso8601)
        ]
      end

      before do
        allow(rate_limiter).to receive(:can_make_request?).and_return(true)
        allow(rate_limiter).to receive(:record_request)
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(Rails.cache).to receive(:write)
        allow(octokit_client).to receive(:stargazers)
          .and_return(stargazers_response, [])
      end

      example 'fetches stargazers and calculates trending data' do
        expect(octokit_client).to receive(:stargazers).with(
          'octocat/Hello-World',
          accept: 'application/vnd.github.star+json',
          page: 1,
          per_page: 100
        )

        described_class.new.perform(category_item_id: category_item.id)

        category_item.reload
        expect(category_item.stars_30d).to eq(2)  # 10 days ago and 20 days ago
        expect(category_item.stars_90d).to eq(4)  # 10, 20, 45, 60 days ago
        expect(category_item.star_history_fetched_at).to be_within(1.minute).of(Time.current)
      end

      example 'caches the star history' do
        expect(Rails.cache).to receive(:write).with(
          'star_history:octocat:Hello-World',
          hash_including(:stars_30d, :stars_90d, :total_fetched),
          expires_in: 1.week
        )

        described_class.new.perform(category_item_id: category_item.id)
      end

      example 'records the API request' do
        expect do
          described_class.new.perform(category_item_id: category_item.id)
        end.to change(GithubApiRequest, :count).by_at_least(1)
      end
    end

    context 'when star history is cached' do
      let(:cached_history) { { stars_30d: 10, stars_90d: 25, total_fetched: 100 } }

      before do
        allow(Rails.cache).to receive(:read).and_return(cached_history)
      end

      example 'uses cached data without making API requests' do
        expect(octokit_client).not_to receive(:stargazers)

        described_class.new.perform(category_item_id: category_item.id)

        category_item.reload
        expect(category_item.stars_30d).to eq(10)
        expect(category_item.stars_90d).to eq(25)
      end
    end

    context 'when category item has no GitHub repo' do
      let(:category_item) { create(:category_item, github_repo: nil, primary_url: 'https://example.com') }

      example 'skips processing' do
        expect(octokit_client).not_to receive(:stargazers)

        described_class.new.perform(category_item_id: category_item.id)

        category_item.reload
        expect(category_item.star_history_fetched_at).to be_nil
      end
    end

    context 'when category item has too many stars' do
      let(:category_item) { create(:category_item, github_repo: 'popular/repo', stars: 15_000) }

      example 'skips processing to avoid expensive API calls' do
        expect(octokit_client).not_to receive(:stargazers)

        described_class.new.perform(category_item_id: category_item.id)

        category_item.reload
        expect(category_item.star_history_fetched_at).to be_nil
      end
    end

    context 'when star history was recently fetched' do
      let(:category_item) do
        create(:category_item, :with_stats,
               github_repo: 'octocat/Hello-World',
               star_history_fetched_at: 1.day.ago)
      end

      example 'skips processing' do
        expect(octokit_client).not_to receive(:stargazers)

        described_class.new.perform(category_item_id: category_item.id)
      end
    end

    context 'when rate limit is exceeded' do
      before do
        allow(rate_limiter).to receive(:can_make_request?).and_return(false)
        allow(rate_limiter).to receive(:time_until_reset).and_return(300)
        allow(Rails.cache).to receive(:read).and_return(nil)
      end

      example 'raises TooManyRequests for retry handling' do
        expect do
          described_class.new.perform(category_item_id: category_item.id)
        end.to raise_error(Octokit::TooManyRequests)
      end
    end

    context 'when repository is not found' do
      before do
        allow(rate_limiter).to receive(:can_make_request?).and_return(true)
        allow(rate_limiter).to receive(:record_request)
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(octokit_client).to receive(:stargazers).and_raise(Octokit::NotFound)
      end

      example 'handles the error gracefully without raising' do
        expect do
          described_class.new.perform(category_item_id: category_item.id)
        end.not_to raise_error
      end

      example 'records the API error' do
        expect do
          described_class.new.perform(category_item_id: category_item.id)
        end.to change(GithubApiRequest, :count).by(1)

        request = GithubApiRequest.last
        expect(request.response_status).to eq(404)
      end
    end
  end
end
