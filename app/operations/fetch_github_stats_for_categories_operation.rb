# frozen_string_literal: true

class FetchGithubStatsForCategoriesOperation
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  def call(categories:, sync: false)
    Rails.logger.info "FetchGithubStatsForCategoriesOperation: Processing #{categories&.size || 0} categories " \
                      "(sync: #{sync})"

    return Failure("Categories is nil") if categories.nil?

    # Convert hash data back to structs if needed
    category_structs = categories.map do |category_data|
      if category_data.is_a?(Hash)
        # ParseMarkdownOperation returns :items, but structs use :repos
        items_data = category_data[:items] || category_data[:repos] || []
        repos = items_data.map { |repo_data| Structs::CategoryItem.new(repo_data) }
        Structs::Category.new(
          custom_order: category_data[:custom_order],
          name: category_data[:name],
          repos:
        )
      else
        category_data # Already a struct
      end
    end

    if sync
      # Synchronous processing - fetch stats immediately with rate limiting
      updated_categories = fetch_stats_synchronously(category_structs)
      Success(updated_categories)
    else
      # Asynchronous processing - queue individual jobs
      queue_github_stats_jobs(category_structs)
      Success(category_structs) # Return original categories for async flow
    end
  end

  private

  def fetch_stats_synchronously(category_structs)
    Rails.logger.info "FetchGithubStatsForCategoriesOperation: Fetching stats synchronously with rate limiting"

    # Initialize rate limiter for synchronous mode
    rate_limiter = GithubRateLimiterService.new

    category_structs.map do |category|
      updated_repos = category.repos.map do |repo_item|
        if github_repo_match = extract_github_repo(repo_item.primary_url)
          owner, repo_name = github_repo_match

          # Check rate limit before making request
          unless rate_limiter.can_make_request?
            wait_time = rate_limiter.time_until_reset
            Rails.logger.warn "Rate limit reached in synchronous mode. Waiting #{wait_time} seconds..."
            sleep(wait_time) if wait_time > 0
          end

          stats = fetch_repo_stats_directly(owner, repo_name, rate_limiter)

          if stats
            # Create new CategoryItem with updated stats
            current_attrs = repo_item.to_h
            new_attrs = current_attrs.merge(
              last_commit_at: stats[:last_commit_at],
              stars: stats[:stars]
            )
            Structs::CategoryItem.new(new_attrs)
          else
            repo_item # Keep original if stats fetch failed
          end
        else
          repo_item # Keep original if not a GitHub repo
        end
      end

      # Create new Category with updated repos
      Structs::Category.new(
        custom_order: category.custom_order,
        name: category.name,
        repos: updated_repos
      )
    end
  end

  def extract_github_repo(url)
    # Regex to capture GitHub owner and repo from URL
    github_repo_regex = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}
    match = github_repo_regex.match(url)
    return nil unless match

    [ match[:owner], match[:repo] ]
  end

  def fetch_repo_stats_directly(owner, repo_name, rate_limiter = nil)
    # Check cache first
    cache_key = "github_stats:#{owner}:#{repo_name}"
    cached_stats = Rails.cache.read(cache_key)

    if cached_stats
      Rails.logger.info "Using cached stats for #{owner}/#{repo_name}"
      return cached_stats
    end

    # Make direct API call
    client = Octokit::Client.new(access_token: ENV["GITHUB_API_KEY"])
    client.auto_paginate = false

    repo_data = client.repository("#{owner}/#{repo_name}")

    stats = {
      last_commit_at: repo_data.pushed_at ? Time.parse(repo_data.pushed_at.to_s) : nil,
      stars: repo_data.stargazers_count
    }

    # Cache the result
    Rails.cache.write(cache_key, stats, expires_in: 1.day)

    # Record the API request for rate limiting (if rate_limiter provided)
    rate_limiter&.record_request(success: true)

    # Record in database for monitoring
    record_api_request(owner:, repo_name:, status: 200)

    Rails.logger.info "Fetched stats for #{owner}/#{repo_name}: #{stats[:stars]} stars"
    stats
  rescue Octokit::NotFound
    Rails.logger.warn "Repository not found: #{owner}/#{repo_name}"
    rate_limiter&.record_request(success: false)
    record_api_request(owner:, repo_name:, status: 404)
    nil
  rescue Octokit::TooManyRequests => e
    Rails.logger.error "Rate limited by GitHub API for #{owner}/#{repo_name}"
    rate_limiter&.record_request(success: false)
    record_api_request(owner:, repo_name:, status: 429)

    # Extract retry-after header if available
    retry_after = e.response_headers&.dig("retry-after")&.to_i || 3600
    Rails.logger.warn "Sleeping for #{retry_after} seconds due to GitHub rate limit"
    sleep(retry_after)
    nil
  rescue Octokit::Error => e
    Rails.logger.error "GitHub API error for #{owner}/#{repo_name}: #{e.message}"
    rate_limiter&.record_request(success: false)
    record_api_request(owner:, repo_name:, status: e.response_status || 500)
    nil
  rescue StandardError => e
    Rails.logger.error "Unexpected error fetching stats for #{owner}/#{repo_name}: #{e.message}"
    rate_limiter&.record_request(success: false)
    record_api_request(owner:, repo_name:, status: 500)
    nil
  end

  def record_api_request(owner:, repo_name:, status:)
    GithubApiRequest.create!(
      endpoint: "/repos/#{owner}/#{repo_name}",
      owner:,
      repo: repo_name,
      requested_at: Time.current,
      response_status: status
    )
  rescue StandardError => e
    Rails.logger.error "Failed to record API request: #{e.message}"
  end

  def queue_github_stats_jobs(category_structs)
    total_repos = 0
    category_structs.each do |category|
      category.repos.each do |repo_item|
        github_repo_match = extract_github_repo(repo_item.primary_url)
        if github_repo_match.present?
          owner, repo_name = github_repo_match

          # Queue the GitHub stats job with category item data
          FetchGithubStatsJob.perform_later(
            category_item_data: repo_item.to_h,
            owner:,
            repo_name:
          )
          total_repos += 1
        end
      end
    end

    Rails.logger.info "FetchGithubStatsForCategoriesOperation: Queued #{total_repos} GitHub stats jobs"
  end
end
