# frozen_string_literal: true

class FetchGithubStatsForCategoriesOperation
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  def call(categories:, sync: false)
    Rails.logger.info "FetchGithubStatsForCategoriesOperation: Processing #{categories.size} categories (sync: #{sync})"

    # Convert hash data back to structs if needed
    category_structs = categories.map do |category_data|
      if category_data.is_a?(Hash)
        repos = category_data[:repos].map { |repo_data| Structs::CategoryItem.new(repo_data) }
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
      # Synchronous processing - fetch stats immediately
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
    Rails.logger.info "FetchGithubStatsForCategoriesOperation: Fetching stats synchronously"

    category_structs.map do |category|
      updated_repos = category.repos.map do |repo_item|
        if github_repo_match = extract_github_repo(repo_item.url)
          owner, repo_name = github_repo_match
          stats = fetch_repo_stats_directly(owner, repo_name)

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

  def fetch_repo_stats_directly(owner, repo_name)
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

    Rails.logger.info "Fetched stats for #{owner}/#{repo_name}: #{stats[:stars]} stars"
    stats
  rescue Octokit::NotFound
    Rails.logger.warn "Repository not found: #{owner}/#{repo_name}"
    nil
  rescue Octokit::Error => e
    Rails.logger.error "GitHub API error for #{owner}/#{repo_name}: #{e.message}"
    nil
  rescue StandardError => e
    Rails.logger.error "Unexpected error fetching stats for #{owner}/#{repo_name}: #{e.message}"
    nil
  end

  def queue_github_stats_jobs(category_structs)
    total_repos = 0
    category_structs.each do |category|
      category.repos.each do |repo_item|
        if github_repo_match = extract_github_repo(repo_item.url)
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
