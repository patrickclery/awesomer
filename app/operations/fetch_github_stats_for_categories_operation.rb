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
      updated_repos = category.repos.filter_map do |repo_item|
        if github_repo_match = extract_github_repo(repo_item.primary_url)
          owner, repo_name = github_repo_match

          # Wait if rate limit is reached, then proceed
          rate_limiter.wait_if_needed

          begin
            # Wrap in timeout to prevent hanging
            require "timeout"
            stats_result = Timeout.timeout(30) do
              fetch_repo_stats_directly(owner, repo_name, rate_limiter)
            end

            if stats_result
              # Create new CategoryItem with updated stats
              current_attrs = repo_item.to_h
              new_attrs = current_attrs.merge(
                last_commit_at: stats_result[:last_commit_at],
                stars: stats_result[:stars]
              )
              Structs::CategoryItem.new(new_attrs)
            else
              # Skip items where GitHub stats fetch failed (404, etc.)
              Rails.logger.info "Skipping #{owner}/#{repo_name} due to failed stats fetch (likely 404)"
              next nil # This will be filtered out by filter_map
            end
          rescue Timeout::Error => e
            Rails.logger.warn "Timeout fetching stats for #{owner}/#{repo_name}, skipping"
            repo_item # Keep original on timeout
          end
        else
          repo_item # Keep original if not a GitHub repo
        end
      end

      # Create new Category with updated repos (404s filtered out)
      Structs::Category.new(
        custom_order: category.custom_order,
        name: category.name,
        repos: updated_repos
      )
    end
  end

  def extract_github_repo(url)
    # Only extract repo info if URL points to repository root, not files/directories
    return nil unless url

    # Pattern for repository root URLs:
    # - https://github.com/owner/repo
    # - https://github.com/owner/repo/
    # - https://github.com/owner/repo.git
    # - https://github.com/owner/repo#readme
    #
    # Should NOT match:
    # - https://github.com/owner/repo/tree/branch/path
    # - https://github.com/owner/repo/blob/branch/file.md
    # - https://github.com/owner/repo/releases
    # - https://github.com/owner/repo/issues

    repo_root_regex = %r{^https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/#]+?)(?:\.git|#[^/]*|/?$)}
    match = repo_root_regex.match(url)
    return nil unless match

    # Additional check: ensure the URL doesn't contain paths that indicate it's not a repo root
    path_indicators = %r{/(tree|blob|releases|issues|pull|wiki|actions|projects|security|pulse|graphs|settings|
                          commit|commits|branches|tags|compare|network|insights)/}x
    return nil if path_indicators.match(url)

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

    # Make direct API call with timeout configuration
    client = if defined?(OctokitHelper)
               OctokitHelper.client_with_timeout(timeout: 20)
    else
               Octokit::Client.new(
                 access_token: ENV["GITHUB_API_KEY"],
                 auto_paginate: false,
                 connection_options: {
                   request: {
                     open_timeout: 5,
                     timeout: 20
                   }
                 }
               )
    end

    repo_data = client.repository("#{owner}/#{repo_name}")

    stats = {
      forks: repo_data.forks_count,
      issues: repo_data.open_issues_count,
      last_commit_at: repo_data.pushed_at ? Time.parse(repo_data.pushed_at.to_s) : nil,
      stars: repo_data.stargazers_count
    }

    # Only cache successful responses (200 status)
    Rails.cache.write(cache_key, stats, expires_in: 1.month)

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

    # Don't cache rate limit errors and don't sleep in synchronous mode
    # The rate limiter should handle this at a higher level
    Rails.logger.warn "Rate limit hit for #{owner}/#{repo_name}, skipping"
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
