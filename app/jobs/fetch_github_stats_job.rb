# frozen_string_literal: true

class FetchGithubStatsJob < ApplicationJob
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  queue_as :github_stats

  # Retry with exponential backoff for rate limit errors
  retry_on StandardError, attempts: 5, wait: :exponentially_longer

  def perform(category_item_data:, owner:, repo_name:)
    @rate_limiter = GithubRateLimiterService.new

    # Check rate limit before making request
    unless @rate_limiter.can_make_request?
      wait_time = @rate_limiter.time_until_reset
      Rails.logger.info "Rate limit reached, retrying in #{wait_time} seconds"
      retry_job(wait: wait_time.seconds)
      return
    end

    # Check cache first (1 day expiration)
    cache_key = "github_stats:#{owner}:#{repo_name}"
    cached_stats = Rails.cache.read(cache_key)

    if cached_stats
      Rails.logger.info "Using cached stats for #{owner}/#{repo_name}"
      update_category_item_with_stats(category_item_data, cached_stats)
      return
    end

    # Make API request
    stats_result = yield fetch_repo_stats_with_octokit(owner:, repo_name:)

    # Record the API request
    @rate_limiter.record_request(success: true)
    record_api_request(owner:, repo_name:, status: 200)

    # Cache the result for 1 day
    Rails.cache.write(cache_key, stats_result, expires_in: 1.day)

    # Update the category item with new stats
    update_category_item_with_stats(category_item_data, stats_result)

    Rails.logger.info "Successfully fetched and cached stats for #{owner}/#{repo_name}"

  rescue Octokit::TooManyRequests => e
    Rails.logger.warn "Rate limited by GitHub API for #{owner}/#{repo_name}"
    record_api_request(owner:, repo_name:, status: 429)

    # Extract retry-after header if available
    retry_after = e.response_headers&.dig("retry-after")&.to_i || 3600
    retry_job(wait: retry_after.seconds)

  rescue Octokit::NotFound
    Rails.logger.warn "Repository not found: #{owner}/#{repo_name}"
    record_api_request(owner:, repo_name:, status: 404)
    @rate_limiter&.record_request(success: false)

  rescue Octokit::Error => e
    Rails.logger.error "GitHub API error for #{owner}/#{repo_name}: #{e.message}"
    record_api_request(owner:, repo_name:, status: e.response_status || 500)
    @rate_limiter&.record_request(success: false)
    raise e # Re-raise to trigger retry logic

  rescue StandardError => e
    Rails.logger.error "Unexpected error fetching stats for #{owner}/#{repo_name}: #{e.message}"
    record_api_request(owner:, repo_name:, status: 500)
    raise e # Re-raise to trigger retry logic
  end

  private

  def update_category_item_with_stats(category_item_data, stats)
    # This would typically update a database record or trigger another job
    # For now, we'll broadcast the update via Rails cache or a pub/sub system
    update_key = "category_item_update:#{category_item_data[:id] || category_item_data[:url]}"
    Rails.cache.write(update_key, {
      category_item: category_item_data,
      stats:,
      updated_at: Time.current
    }, expires_in: 1.hour)

    Rails.logger.info "Updated category item cache for #{category_item_data[:name]}"
  end

  def fetch_repo_stats_with_octokit(owner:, repo_name:)
    client = Octokit::Client.new(access_token: ENV["GITHUB_API_KEY"])
    client.auto_paginate = false # Disable auto-pagination for better control

    repo_data = client.repository("#{owner}/#{repo_name}")

    stats = {
      last_commit_at: repo_data.pushed_at ? Time.parse(repo_data.pushed_at.to_s) : nil,
      stars: repo_data.stargazers_count
    }

    Success(stats)
  end

  def record_api_request(owner:, repo_name:, status:)
    GithubApiRequest.create!(
      endpoint: "/repos/#{owner}/#{repo_name}",
      owner:,
      repo: repo_name,
      requested_at: Time.current,
      response_status: status
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to record API request: #{e.message}"
  end
end
