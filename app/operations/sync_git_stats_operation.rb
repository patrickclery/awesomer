# frozen_string_literal: true

class SyncGitStatsOperation
# noinspection RubyResolve
include Dry::Monads[:result, :do]

  def call(categories:)
    Rails.logger.info "SyncGitStatsOperation: Queueing background jobs for GitHub stats"

    # Convert categories to serializable format for background job
    serializable_categories = categories.map(&:to_h)

    # Queue the markdown processing job which will handle all GitHub API calls
    ProcessMarkdownWithStatsJob.perform_later(categories: serializable_categories)

    Rails.logger.info "SyncGitStatsOperation: Background job queued successfully"

    # Return the original categories immediately
    # The actual stats will be fetched asynchronously
    Success(categories)
  rescue StandardError => e
    Failure("SyncGitStatsOperation failed: #{e.message}")
  end
end
