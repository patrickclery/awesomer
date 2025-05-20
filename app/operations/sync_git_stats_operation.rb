# frozen_string_literal: true

class SyncGitStatsOperation
  include Dry::Monads[:result, :do]
  include App::Import[
    stats_fetcher: 'services.github_stats_fetcher'
  ]

  # Regex to capture GitHub owner and repo from URL
  GITHUB_REPO_REGEX = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}

  def call(categories:)
    updated_categories = categories.map do |category|
      updated_items = category.repos.map do |item|
        match = GITHUB_REPO_REGEX.match(item.url)
        if match
          owner = match[:owner]
          repo_name = match[:repo]

          # Fetch stats using the injected service. 
          # This service is expected to return Success(hash_of_stats) or Failure.
          # hash_of_stats might be e.g. { stars: 123, last_commit_at: Time.now }
          stats_data = yield stats_fetcher.call(owner: owner, repo: repo_name)

          # Update item with new stats. item.new creates a new instance.
          # If stats_data contains nil for stars/last_commit_at, they will be set to nil
          # on the new item, which is fine as these attributes are optional.
          item.new(
            stars: stats_data[:stars],
            last_commit_at: stats_data[:last_commit_at]
            # commits_past_year is not updated as per current requirements for this operation
          )
        else
          item # Not a GitHub repo or URL didn't match, return item as is
        end
      end
      # Create a new category with the (potentially) updated items
      category.new(repos: updated_items)
    end

    Success(updated_categories)
  # Let `do` notation handle Failures from `yield stats_fetcher.call`
  # Catch specific errors that might occur within this operation's direct logic, if any.
  rescue Dry::Struct::Error => e # For example, if category.new or item.new had issues
    Failure("SyncGitStatsOperation failed due to Struct error: #{e.message}")
  # Add other specific error rescues here if necessary
  # Removing the broad StandardError rescue to let Do::Halt from yield propagate correctly.
  end
end 