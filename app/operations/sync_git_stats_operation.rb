# frozen_string_literal: true

class SyncGitStatsOperation
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  def call(categories:, repo_identifier: nil, sync: false)
    if sync
      Rails.logger.info 'SyncGitStatsOperation: Running synchronously for testing'
      return FetchGithubStatsForCategoriesOperation.new.call(categories:, sync: true)
    end

    Rails.logger.info 'SyncGitStatsOperation: Queueing background jobs for GitHub stats'

    # Categories are already in hash format from ParseMarkdownOperation
    serializable_categories = categories

    # Queue the markdown processing job which will handle all GitHub API calls
    ProcessMarkdownWithStatsJob.perform_later(
      categories: serializable_categories,
      repo_identifier:
    )

    Rails.logger.info 'SyncGitStatsOperation: Background job queued successfully'

    # Return the original categories immediately
    # The actual stats will be fetched asynchronously
    Success(categories)
  rescue StandardError => e
    Rails.logger.error "SyncGitStatsOperation error: #{e.class}: #{e.message}"
    Rails.logger.error "Backtrace: #{e.backtrace.first(5).join("\n")}"
    Failure("SyncGitStatsOperation failed: #{e.message}")
  end
end
