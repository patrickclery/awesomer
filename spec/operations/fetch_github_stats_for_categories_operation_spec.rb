# frozen_string_literal: true

require 'rails_helper'
require 'ostruct'

RSpec.describe FetchGithubStatsForCategoriesOperation do
  include Dry::Monads[:result]

  let(:github_repo_item) do
    Structs::CategoryItem.new(
      description: "A test repository",
      name: "Test Repo",
      primary_url: "https://github.com/owner/repo"
    )
  end

  let(:non_github_repo_item) do
    Structs::CategoryItem.new(
      description: "An external tool",
      name: "External Tool",
      primary_url: "https://example.com/tool"
    )
  end

  let(:test_category) do
    Structs::Category.new(
      custom_order: 0,
      name: "Test Category",
      repos: [ github_repo_item, non_github_repo_item ]
    )
  end

  let(:categories) { [ test_category ] }
  let(:operation) { described_class.new }

  describe '#call' do
    context 'when sync is false (asynchronous mode)' do
      it 'returns Success with original categories' do
        expect(FetchGithubStatsJob).to receive(:perform_later).once

        result = operation.call(categories:, sync: false)

        expect(result).to be_success
        expect(result.value!).to eq(categories)
      end

      it 'queues FetchGithubStatsJob for GitHub repositories only' do
        expect(FetchGithubStatsJob).to receive(:perform_later).with(
          category_item_data: github_repo_item.to_h,
          owner: "owner",
          repo_name: "repo"
        )

        operation.call(categories:, sync: false)
      end

      it 'does not queue jobs for non-GitHub repositories' do
        non_github_category = Structs::Category.new(
          custom_order: 0,
          name: "External Category",
          repos: [ non_github_repo_item ]
        )

        expect(FetchGithubStatsJob).not_to receive(:perform_later)

        result = operation.call(categories: [ non_github_category ], sync: false)
        expect(result).to be_success
      end
    end

    context 'when sync is true (synchronous mode)' do
      let(:mock_client) { instance_double(Octokit::Client) }
      let(:mock_repo_data) do
        OpenStruct.new(
          pushed_at: Time.parse("2024-01-15T10:30:00Z"),
          stargazers_count: 42
        )
      end

      before do
        allow(Octokit::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:auto_paginate=)
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(Rails.cache).to receive(:write)

        # Mock the rate limiter
        rate_limiter = instance_double(GithubRateLimiterService)
        allow(GithubRateLimiterService).to receive(:new).and_return(rate_limiter)
        allow(rate_limiter).to receive(:record_request)
        allow(rate_limiter).to receive_messages(can_make_request?: true, time_until_reset: 0)

        # Mock the database recording
        allow(GithubApiRequest).to receive(:create!)
      end

      it 'fetches stats synchronously and returns updated categories' do
        allow(mock_client).to receive(:repository)
          .with("owner/repo")
          .and_return(mock_repo_data)

        result = operation.call(categories:, sync: true)

        expect(result).to be_success
        updated_categories = result.value!
        updated_repo = updated_categories.first.repos.first

        expect(updated_repo.stars).to eq(42)
        expect(updated_repo.last_commit_at).to eq(Time.parse("2024-01-15T10:30:00Z"))
      end

      it 'uses cached data when available' do
        cached_stats = {
          last_commit_at: Time.parse("2024-01-10T10:00:00Z"),
          stars: 100
        }
        allow(Rails.cache).to receive(:read)
          .with("github_stats:owner:repo")
          .and_return(cached_stats)

        expect(mock_client).not_to receive(:repository)

        result = operation.call(categories:, sync: true)

        expect(result).to be_success
        updated_categories = result.value!
        updated_repo = updated_categories.first.repos.first

        expect(updated_repo.stars).to eq(100)
        expect(updated_repo.last_commit_at).to eq(Time.parse("2024-01-10T10:00:00Z"))
      end

      it 'filters out repositories that are not found (404)' do
        allow(mock_client).to receive(:repository)
          .with("owner/repo")
          .and_raise(Octokit::NotFound)

        result = operation.call(categories:, sync: true)

        expect(result).to be_success
        updated_categories = result.value!

        # The GitHub repo should be filtered out, only non-GitHub repo should remain
        expect(updated_categories.first.repos.size).to eq(1)
        remaining_repo = updated_categories.first.repos.first
        expect(remaining_repo.name).to eq("External Tool")
        expect(remaining_repo.primary_url).to eq("https://example.com/tool")
      end

      it 'filters out repositories with GitHub API errors' do
        allow(mock_client).to receive(:repository)
          .with("owner/repo")
          .and_raise(Octokit::Error, "API Error")

        result = operation.call(categories:, sync: true)

        expect(result).to be_success
        updated_categories = result.value!

        # The GitHub repo should be filtered out, only non-GitHub repo should remain
        expect(updated_categories.first.repos.size).to eq(1)
        remaining_repo = updated_categories.first.repos.first
        expect(remaining_repo.name).to eq("External Tool")
        expect(remaining_repo.primary_url).to eq("https://example.com/tool")
      end

      it 'preserves non-GitHub repositories unchanged' do
        # Mock the GitHub API call for the GitHub repo
        allow(mock_client).to receive(:repository)
          .with("owner/repo")
          .and_return(mock_repo_data)

        result = operation.call(categories:, sync: true)

        expect(result).to be_success
        updated_categories = result.value!
        non_github_repo = updated_categories.first.repos.last

        expect(non_github_repo).to eq(non_github_repo_item)
      end
    end

    context 'when categories contain hash data (from background jobs)' do
      let(:category_hash) do
        {
          custom_order: 0,
          name: "Test Category",
          repos: [
            {
              description: "A test repository",
              name: "Test Repo",
              primary_url: "https://github.com/owner/repo"
            }
          ]
        }
      end

      it 'converts hash data back to structs' do
        expect(FetchGithubStatsJob).to receive(:perform_later).once

        result = operation.call(categories: [ category_hash ], sync: false)

        expect(result).to be_success
        categories_result = result.value!
        expect(categories_result.first).to be_a(Structs::Category)
        expect(categories_result.first.repos.first).to be_a(Structs::CategoryItem)
      end
    end
  end
end
