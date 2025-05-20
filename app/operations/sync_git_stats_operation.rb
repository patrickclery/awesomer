# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "time"

class SyncGitStatsOperation
  include Dry::Monads[:result, :do]

  # Regex to capture GitHub owner and repo from URL
  GITHUB_REPO_REGEX = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}
  GITHUB_API_BASE_URL = "https://api.github.com/repos"

  def call(categories:)
    updated_categories = categories.map do |category|
      updated_items = category.repos.map do |item|
        match = GITHUB_REPO_REGEX.match(item.url)
        if match
          owner = match[:owner]
          repo_name = match[:repo]

          # Fetch stats directly using a private method
          stats_result = yield fetch_repo_stats(owner:, repo_name:)

          # Update item with new stats. item.new creates a new instance.
          item.new(
            last_commit_at: stats_result[:last_commit_at],
            stars: stats_result[:stars]
            # commits_past_year is not updated by this operation
          )
        else
          item # Not a GitHub repo or URL didn't match, return item as is
        end
      end
      # Create a new category with the (potentially) updated items
      category.new(repos: updated_items)
    end

    Success(updated_categories)
  # Let `do` notation handle Failures from `yield fetch_repo_stats`
  # Catch specific errors that might occur within this operation's direct logic, if any.
  rescue Dry::Struct::Error => e # For example, if category.new or item.new had issues
    Failure("SyncGitStatsOperation failed due to Struct error: #{e.message}")
    # fetch_repo_stats returns Failure on error, which `yield` will propagate.
    # No broad StandardError rescue needed here if fetch_repo_stats is robust.
  end

  private

  def fetch_repo_stats(owner:, repo_name:)
    uri = URI.parse("#{GITHUB_API_BASE_URL}/#{owner}/#{repo_name}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")

    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = "AwesomeListStatsFetcher/1.0" # GitHub API requires User-Agent
    request["Accept"] = "application/vnd.github.v3+json"

    response = http.request(request)

    case response
    when Net::HTTPSuccess # 2xx
      begin
        data = JSON.parse(response.body)
        stars = data["stargazers_count"]
        pushed_at_string = data["pushed_at"]
        last_commit_at = pushed_at_string ? Time.parse(pushed_at_string) : nil
        Success({last_commit_at:, stars:})
      rescue JSON::ParserError => e
        Failure("Failed to parse JSON response from GitHub API for #{owner}/#{repo_name}: #{e.message}")
      rescue StandardError => e # Catch other errors during data extraction e.g. Time.parse
        Failure("Error processing GitHub API data for #{owner}/#{repo_name}: #{e.message}")
      end
    when Net::HTTPNotFound # 404
      Failure("GitHub repository not found: #{owner}/#{repo_name}")
    else # Other errors (403, 500, etc.)
      Failure("GitHub API request failed for #{owner}/#{repo_name}: #{response.code} #{response.message} - #{response.body.truncate(100)}")
    end
  rescue SocketError, Errno::ECONNREFUSED, Net::OpenTimeout, Net::ReadTimeout => e # Network errors
    Failure("Network error while fetching stats for #{owner}/#{repo_name}: #{e.message}")
  rescue StandardError => e # Catch-all for other unexpected errors in this method
    Failure("Unexpected error in fetch_repo_stats for #{owner}/#{repo_name}: #{e.message}")
  end
end
