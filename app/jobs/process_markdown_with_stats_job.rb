# frozen_string_literal: true

class ProcessMarkdownWithStatsJob < ApplicationJob
  include Dry::Monads[:result, :do]

  queue_as :markdown_processing

  def perform(categories:, output_options: {})
    Rails.logger.info "Starting markdown processing with stats for #{categories.size} categories"

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

    # Queue individual GitHub stats jobs for each repository
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

    Rails.logger.info "Queued #{total_repos} GitHub stats jobs"

    # Schedule the markdown generation job to run after a delay
    # This gives time for the stats jobs to complete
    estimated_completion_time = calculate_completion_time(total_repos)
    GenerateMarkdownJob.perform_in(estimated_completion_time, categories:, output_options:)

    Rails.logger.info "Scheduled markdown generation in #{estimated_completion_time} seconds"
  end

  private

  def extract_github_repo(url)
    # Regex to capture GitHub owner and repo from URL
    github_repo_regex = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}
    match = github_repo_regex.match(url)
    return nil unless match

    [ match[:owner], match[:repo] ]
  end

  def calculate_completion_time(repo_count)
    # Conservative estimate: assume we can process 1 repo per second due to rate limiting
    # Add buffer time for retries and processing
    base_time = repo_count * 1.5 # 1.5 seconds per repo
    buffer_time = [ repo_count * 0.5, 300 ].min # Additional buffer, max 5 minutes

    (base_time + buffer_time).to_i
  end
end
