# frozen_string_literal: true

class ProcessMarkdownWithStatsJob < ApplicationJob
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  queue_as :markdown_processing

  def perform(categories:, output_options: {}, repo_identifier: nil)
    Rails.logger.info "Starting markdown processing with stats for #{categories.size} categories"

    # Use the shared operation to queue individual GitHub stats jobs
    result = FetchGithubStatsForCategoriesOperation.new.call(categories:, sync: false)

    unless result.success?
      Rails.logger.error "Failed to queue GitHub stats jobs: #{result.failure}"
      return
    end

    category_structs = result.value!

    # Count total repos for scheduling
    # Structs::Category uses :repos, while raw hashes from ParseMarkdownOperation use :items
    total_repos = category_structs.sum do |category|
      items = if category.is_a?(Hash)
                category[:items] || category[:repos] || []
              else
                category.repos || []
              end
      items.to_a.count { |item| extract_github_repo(item.respond_to?(:primary_url) ? item.primary_url : item[:primary_url]) }
    end

    Rails.logger.info "Queued #{total_repos} GitHub stats jobs"

    # Schedule the markdown generation job to run after a delay
    # This gives time for the stats jobs to complete
    estimated_completion_time = calculate_completion_time(total_repos)
    GenerateMarkdownJob.set(wait: estimated_completion_time.seconds).perform_later(categories:, output_options:, repo_identifier:)

    Rails.logger.info "Scheduled markdown generation in #{estimated_completion_time} seconds"
  end

  private

  def extract_github_repo(url)
    # Regex to capture GitHub owner and repo from URL
    github_repo_regex = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/#]+?)(?:/|\.git|#|$)}
    match = github_repo_regex.match(url)
    return nil unless match

    [match[:owner], match[:repo]]
  end

  def calculate_completion_time(repo_count)
    # Conservative estimate: assume we can process 1 repo per second due to rate limiting
    # Add buffer time for retries and processing
    base_time = repo_count * 1.5 # 1.5 seconds per repo
    buffer_time = [repo_count * 0.5, 300].min # Additional buffer, max 5 minutes

    (base_time + buffer_time).to_i
  end
end
