# frozen_string_literal: true

class GithubStatsFetcherService
  include Dry::Monads[:result]

  # In a real implementation, this would use an HTTP client (e.g., Faraday)
  # and potentially an Octokit client or similar to interact with the GitHub API.
  # It would also require proper error handling, API token management, etc.

  def call(owner:, repo:)
    # Placeholder implementation
    # For testing purposes, this would typically be mocked.
    # A real implementation would make an API call here.
    # puts "Called GithubStatsFetcherService for #{owner}/#{repo}" # For debugging if needed

    # Simulate a successful API call with some data
    # In a real scenario, these values would come from the GitHub API response.
    if owner == 'no_stars_repo' # Example for testing nil stars
      Success({ stars: nil, last_commit_at: Time.now - 86400 * 30 }) # 30 days ago
    elsif owner == 'no_commit_date_repo' # Example for testing nil last_commit_at
      Success({ stars: 50, last_commit_at: nil })
    else
      Success({ stars: (owner.length * 10), last_commit_at: Time.now - (repo.length * 86400) })
    end

    # Simulate a failure case, e.g., if the repo is not found or API limit exceeded
    # return Failure("Failed to fetch stats for #{owner}/#{repo}: API error") if owner == 'fail_repo'
  rescue StandardError => e
    Failure("GithubStatsFetcherService error for #{owner}/#{repo}: #{e.message}")
  end
end 