# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchGithubStatsForCategoriesOperation do
  let(:operation) { described_class.new }
  let(:github_repo_url) { 'https://github.com/owner/repo' }
  let(:non_github_url) { 'https://example.com/project' }

  describe '#call with sync mode and rate limiting' do
    let(:category_data) do
      {
        custom_order: 0,
        items: [
          {description: 'Desc1', name: 'Repo1', primary_url: 'https://github.com/owner/repo1'},
          {description: 'Desc2', name: 'Repo2', primary_url: 'https://github.com/owner/repo2'},
          {description: 'External tool', name: 'External', primary_url: 'https://example.com/tool'}
        ],
        name: 'Test Category'
      }
    end

    context 'with sync: true' do
      let(:mock_client) { instance_double(Octokit::Client) }
      let(:mock_rate_limiter) { instance_double(GithubRateLimiterService) }

      before do
        allow(GithubRateLimiterService).to receive(:new).and_return(mock_rate_limiter)
        allow(mock_rate_limiter).to receive(:wait_if_needed)
        allow(mock_rate_limiter).to receive(:record_request)
        allow(Octokit::Client).to receive(:new).and_return(mock_client)
      end

      context 'when all repos fetch successfully' do
        before do
          allow(mock_client).to receive(:repository).with('owner/repo1').and_return(
            OpenStruct.new(
              forks_count: 10,
              open_issues_count: 5,
              pushed_at: Time.parse('2025-08-01'),
              stargazers_count: 100
            )
          )
          allow(mock_client).to receive(:repository).with('owner/repo2').and_return(
            OpenStruct.new(
              forks_count: 20,
              open_issues_count: 10,
              pushed_at: Time.parse('2025-08-15'),
              stargazers_count: 200
            )
          )
        end

        it 'fetches stats for GitHub repos' do
          result = operation.call(categories: [category_data], sync: true)

          expect(result).to be_success
          categories = result.value!
          items = categories.first.repos

          expect(items[0].stars).to eq(100)
          expect(items[1].stars).to eq(200)
        end

        it 'filters out non-GitHub repos' do
          result = operation.call(categories: [category_data], sync: true)

          categories = result.value!
          items = categories.first.repos

          expect(items.size).to eq(2)
          expect(items.map(&:name)).not_to include('External')
        end

        it 'calls rate limiter for each GitHub repo' do
          expect(mock_rate_limiter).to receive(:wait_if_needed).twice

          operation.call(categories: [category_data], sync: true)
        end
      end

      context 'when some repos fail to fetch' do
        before do
          allow(mock_client).to receive(:repository).with('owner/repo1').and_return(
            OpenStruct.new(
              forks_count: 10,
              open_issues_count: 5,
              pushed_at: Time.parse('2025-08-01'),
              stargazers_count: 100
            )
          )
          allow(mock_client).to receive(:repository).with('owner/repo2').and_raise(Octokit::NotFound)
        end

        it 'skips failed repos instead of including with zero stats' do
          result = operation.call(categories: [category_data], sync: true)

          expect(result).to be_success
          categories = result.value!
          items = categories.first.repos

          expect(items.size).to eq(1)
          expect(items.first.name).to eq('Repo1')
          expect(items.first.stars).to eq(100)
        end
      end

      context 'with consecutive failures and exponential backoff' do
        let(:many_items_data) do
          {
            custom_order: 0,
            items: (1..10).map do |i|
              {description: "Desc#{i}", name: "Repo#{i}", primary_url: "https://github.com/owner/repo#{i}"}
            end,
            name: 'Test Category'
          }
        end

        before do
          # First 5 succeed, next 5 fail to trigger backoff
          (1..5).each do |i|
            allow(mock_client).to receive(:repository).with("owner/repo#{i}").and_return(
              OpenStruct.new(forks_count: i, open_issues_count: i, pushed_at: Time.current, stargazers_count: i * 10)
            )
          end

          (6..10).each do |i|
            allow(mock_client).to receive(:repository).with("owner/repo#{i}").and_raise(Octokit::TooManyRequests)
          end
        end

        it 'sleeps when hitting too many consecutive failures' do
          expect(operation).to receive(:sleep).at_least(:once)

          operation.call(categories: [many_items_data], sync: true)
        end

        it 'continues processing after sleep' do
          allow(operation).to receive(:sleep)

          result = operation.call(categories: [many_items_data], sync: true)

          expect(result).to be_success
          categories = result.value!
          items = categories.first.repos

          # Should have the 5 successful ones
          expect(items.size).to eq(5)
        end
      end

      context 'with timeout errors' do
        before do
          allow(mock_client).to receive(:repository).with('owner/repo1').and_raise(Timeout::Error)
          allow(mock_client).to receive(:repository).with('owner/repo2').and_return(
            OpenStruct.new(forks_count: 20, open_issues_count: 10, pushed_at: Time.current, stargazers_count: 200)
          )
        end

        it 'skips timed out repos' do
          result = operation.call(categories: [category_data], sync: true)

          categories = result.value!
          items = categories.first.repos

          expect(items.size).to eq(1)
          expect(items.first.name).to eq('Repo2')
        end
      end

      context 'with caching' do
        let(:cache_key) { 'github_stats:owner:repo1' }
        let(:cached_stats) do
          {
            forks: 99,
            issues: 9,
            last_commit_at: Time.parse('2025-07-01'),
            stars: 999
          }
        end

        before do
          allow(Rails.cache).to receive(:read).with(cache_key).and_return(cached_stats)
        end

        it 'uses cached stats when available' do
          expect(mock_client).not_to receive(:repository).with('owner/repo1')

          result = operation.call(categories: [category_data], sync: true)

          categories = result.value!
          items = categories.first.repos
          repo1 = items.find { |i| i.name == 'Repo1' }

          expect(repo1.stars).to eq(999)
        end
      end
    end

    context 'with sync: false' do
      it 'queues background jobs instead of fetching immediately' do
        expect(FetchGithubStatsJob).to receive(:perform_later).twice

        result = operation.call(categories: [category_data], sync: false)

        expect(result).to be_success
      end

      it 'returns original categories without modification' do
        allow(FetchGithubStatsJob).to receive(:perform_later)

        result = operation.call(categories: [category_data], sync: false)

        categories = result.value!
        items = categories.first.repos

        expect(items.size).to eq(3) # All items including non-GitHub
        expect(items.map(&:stars)).to all(be_nil)
      end
    end
  end

  describe 'GitHub URL extraction' do
    let(:operation_instance) { described_class.new }

    it 'extracts owner and repo from repository root URLs' do
      urls = [
        'https://github.com/owner/repo',
        'https://github.com/owner/repo/',
        'https://github.com/owner/repo.git',
        'https://github.com/owner/repo#readme'
      ]

      urls.each do |url|
        result = operation_instance.send(:extract_github_repo, url)
        expect(result).to eq(%w[owner repo])
      end
    end

    it 'returns nil for non-repository URLs' do
      urls = [
        'https://github.com/owner/repo/tree/main/src',
        'https://github.com/owner/repo/blob/main/README.md',
        'https://github.com/owner/repo/releases',
        'https://github.com/owner/repo/issues/123',
        'https://example.com/project'
      ]

      urls.each do |url|
        result = operation_instance.send(:extract_github_repo, url)
        expect(result).to be_nil
      end
    end
  end
end
