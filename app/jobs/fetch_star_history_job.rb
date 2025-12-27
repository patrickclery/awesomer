# frozen_string_literal: true

# Fetches star history (stargazers with timestamps) for a CategoryItem
# to calculate trending data (stars gained in last 30/90 days).
# Integrates with the existing rate limiting infrastructure.
class FetchStarHistoryJob < ApplicationJob
  queue_as :github_stats

  # Retry with exponential backoff for rate limit errors
  retry_on Octokit::TooManyRequests, attempts: 5, wait: :exponentially_longer
  retry_on StandardError, attempts: 3, wait: :exponentially_longer

  # Skip repos with too many stars - fetching history would be too expensive
  MAX_STARS_FOR_HISTORY = 10_000

  def perform(category_item_id:)
    @rate_limiter = GithubRateLimiterService.new
    @category_item = CategoryItem.find(category_item_id)

    return unless should_fetch_history?

    owner, repo_name = parse_github_repo
    return unless owner && repo_name

    # Check cache first (star history is stable - cache for 1 week)
    cache_key = "star_history:#{owner}:#{repo_name}"
    cached_history = Rails.cache.read(cache_key)

    if cached_history
      Rails.logger.info "Using cached star history for #{owner}/#{repo_name}"
      update_category_item(cached_history)
      return
    end

    # Fetch stargazers with timestamps
    star_history = fetch_star_history(owner, repo_name)
    return unless star_history

    # Cache and update
    Rails.cache.write(cache_key, star_history, expires_in: 1.week)
    update_category_item(star_history)

    Rails.logger.info "Fetched star history for #{owner}/#{repo_name}: " \
                      "30d=#{star_history[:stars_30d]}, 90d=#{star_history[:stars_90d]}"
  rescue Octokit::TooManyRequests => e
    Rails.logger.warn "Rate limited fetching star history for category_item #{category_item_id}"
    record_api_request(endpoint: '/stargazers', status: 429)
    raise e
  rescue Octokit::NotFound
    Rails.logger.warn "Repository not found for category_item #{category_item_id}"
    record_api_request(endpoint: '/stargazers', status: 404)
    # Don't retry 404s
  rescue Octokit::Error => e
    Rails.logger.error "GitHub API error fetching star history: #{e.message}"
    record_api_request(endpoint: '/stargazers', status: e.response_status || 500)
    raise e
  end

  private

  def should_fetch_history?
    # Skip if no GitHub repo
    return false unless @category_item.github_repo.present?

    # Skip if we fetched recently (within 1 week)
    if @category_item.star_history_fetched_at.present? &&
       @category_item.star_history_fetched_at > 1.week.ago
      Rails.logger.debug "Skipping #{@category_item.github_repo} - history fetched recently"
      return false
    end

    # Skip repos with too many stars (too expensive to fetch)
    if @category_item.stars.present? && @category_item.stars > MAX_STARS_FOR_HISTORY
      Rails.logger.info "Skipping #{@category_item.github_repo} - #{@category_item.stars} stars exceeds limit"
      return false
    end

    true
  end

  def parse_github_repo
    return nil unless @category_item.github_repo.present?

    parts = @category_item.github_repo.split('/')
    return nil unless parts.length == 2

    [parts[0], parts[1]]
  end

  def update_category_item(star_history)
    @category_item.update!(
      star_history_fetched_at: Time.current,
      stars_30d: star_history[:stars_30d],
      stars_90d: star_history[:stars_90d]
    )
  end

  def fetch_star_history(owner, repo_name)
    client = build_octokit_client
    cutoffs = calculate_cutoffs
    counts = {stars_30d: 0, stars_90d: 0, total_fetched: 0}

    paginate_stargazers(client, owner, repo_name, cutoffs, counts)

    {stars_30d: counts[:stars_30d], stars_90d: counts[:stars_90d], total_fetched: counts[:total_fetched]}
  end

  def build_octokit_client
    Octokit::Client.new(
      access_token: ENV.fetch('GITHUB_API_KEY', nil),
      auto_paginate: false,
      connection_options: {request: {open_timeout: 10, timeout: 30}}
    )
  end

  def calculate_cutoffs
    now = Time.current
    {cutoff_30d: now - 30.days, cutoff_90d: now - 90.days}
  end

  def paginate_stargazers(client, owner, repo_name, cutoffs, counts)
    page = 1

    loop do
      check_rate_limit!

      response = fetch_stargazers_page(client, owner, repo_name, page)
      break if response.empty?

      count_stars_in_response(response, cutoffs, counts)
      counts[:total_fetched] += response.size

      page += 1
      break if page > 50 # Safety limit: 5000 stars max

      sleep(GithubRateLimiterService::MIN_DELAY_BETWEEN_REQUESTS)
    end
  end

  def check_rate_limit!
    return if @rate_limiter.can_make_request?

    Rails.logger.info "Rate limit reached, waiting #{@rate_limiter.time_until_reset} seconds"
    raise Octokit::TooManyRequests
  end

  def fetch_stargazers_page(client, owner, repo_name, page)
    response = client.stargazers(
      "#{owner}/#{repo_name}",
      accept: 'application/vnd.github.star+json',
      page:,
      per_page: 100
    )

    @rate_limiter.record_request(success: true)
    record_api_request(endpoint: "/repos/#{owner}/#{repo_name}/stargazers", owner:, repo_name:, status: 200)

    response
  end

  def record_api_request(endpoint:, status:, owner: nil, repo_name: nil)
    GithubApiRequest.create!(
      endpoint:,
      owner:,
      repo: repo_name,
      requested_at: Time.current,
      response_status: status
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to record API request: #{e.message}"
  end

  def count_stars_in_response(response, cutoffs, counts)
    response.each do |stargazer|
      next unless stargazer.starred_at

      starred_time = Time.parse(stargazer.starred_at.to_s)
      counts[:stars_90d] += 1 if starred_time >= cutoffs[:cutoff_90d]
      counts[:stars_30d] += 1 if starred_time >= cutoffs[:cutoff_30d]
    end
  end
end
