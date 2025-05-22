# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "time"

class SyncGitStatsOperation
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  # Regex to capture GitHub owner and repo from URL
  GITHUB_REPO_REGEX = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}
  GITHUB_API_BASE_URL = "https://api.github.com/repos"

  def call(categories:)
    updated_categories = categories.map do |category|
      # puts "Processing category in SyncGitStats: #{category.name}" # DEBUG
      updated_items = category.repos.map do |item|
        match = GITHUB_REPO_REGEX.match(item.url)
        if match
          owner = match[:owner]
          repo_name = match[:repo]
          # puts "  Attempting to fetch stats for: #{owner}/#{repo_name}" # DEBUG

          stats_fetch_monad = fetch_repo_stats(owner:, repo_name:)

          if stats_fetch_monad.success?
            stats_data = stats_fetch_monad.value!
            # puts "    Stats fetch SUCCESS for #{owner}/#{repo_name}: #{stats_data.inspect}"
            current_item_attrs = item.to_h # Get all current attributes
            new_attrs = current_item_attrs.merge(
              last_commit_at: stats_data[:last_commit_at],
              stars: stats_data[:stars]
            )
            updated_item = Structs::CategoryItem.new(new_attrs) # Create new item with merged attributes
            # puts "    Original item: #{item.name}, stars: #{item.stars}, " \
            #      "last_commit: #{item.last_commit_at}"
            # puts "    New/Updated item: #{updated_item.name}, stars: #{updated_item.stars}, " \
            #      "last_commit: #{updated_item.last_commit_at}"
            updated_item
          else
            puts "    WARN (SyncGitStatsOperation): Failed to fetch stats for " \
                 "#{owner}/#{repo_name}: #{stats_fetch_monad.failure}"
            item
          end
        else
          item
        end
      end
      # Explicitly create new Category with new items and original attributes
      Structs::Category.new(
        custom_order: category.custom_order,
        name: category.name,
        repos: updated_items
      )
    end
    Success(updated_categories)
  rescue Dry::Struct::Error => e
    Failure("SyncGitStatsOperation failed due to Struct error: #{e.message}")
    # No longer relying on `yield` to propagate failures from fetch_repo_stats
    # up to the main `call` method's `do` block.
  end

  private

  def fetch_repo_stats(owner:, repo_name:)
    uri = URI.parse("#{GITHUB_API_BASE_URL}/#{owner}/#{repo_name}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")

    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = "AwesomeListStatsFetcher/1.0"
    request["Accept"] = "application/vnd.github.v3+json"
    if ENV["GITHUB_API_KEY"]
      request["Authorization"] = "token #{ENV['GITHUB_API_KEY']}"
    end

    response = http.request(request)
    # For debugging VCR:
    # puts "    Raw API response for #{owner}/#{repo_name}: #{response.code} - " \
    #      "body: #{response.body.truncate(80)}"

    case response
    when Net::HTTPSuccess
      begin
        data = JSON.parse(response.body)
        stars = data["stargazers_count"]
        pushed_at_string = data["pushed_at"]
        last_commit_at = pushed_at_string ? Time.parse(pushed_at_string) : nil
        Success({last_commit_at:, stars:})
      rescue JSON::ParserError => e
        Failure("Failed to parse JSON for #{owner}/#{repo_name}: #{e.message}")
      rescue StandardError => e
        Failure("Error processing GitHub API data for #{owner}/#{repo_name}: #{e.message}")
      end
    when Net::HTTPNotFound
      Failure("GitHub repository not found: #{owner}/#{repo_name}")
    else
      error_body = response.body&.truncate(60) # Ensure body exists before truncate
      Failure("GitHub API req failed for #{owner}/#{repo_name}: #{response.code} " \
              "#{response.message} - #{error_body}")
    end
  rescue SocketError, Errno::ECONNREFUSED, Net::OpenTimeout, Net::ReadTimeout => e
    Failure("Network error fetching stats for #{owner}/#{repo_name}: #{e.message}")
  rescue StandardError => e
    Failure("Unexpected error in fetch_repo_stats for #{owner}/#{repo_name}: #{e.message}")
  end
end
