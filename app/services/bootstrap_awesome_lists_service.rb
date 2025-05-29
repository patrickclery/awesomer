# frozen_string_literal: true

class BootstrapAwesomeListsService
  include Dry::Monads[:result, :do]
  include App::Import[
    :fetch_readme_operation,
    :find_or_create_awesome_list_operation
  ]

  SINDRESORHUS_AWESOME_REPO = "sindresorhus/awesome"

  def initialize(**deps)
    @fetch_readme_operation = deps[:fetch_readme_operation] || App::Container["fetch_readme_operation"]
    @find_or_create_awesome_list_operation =
      deps[:find_or_create_awesome_list_operation] || App::Container["find_or_create_awesome_list_operation"]
    @extract_awesome_lists_operation = deps[:extract_awesome_lists_operation] || ExtractAwesomeListsOperation.new
  end

  def call
    Rails.logger.info "BootstrapAwesomeListsService: Starting bootstrap of awesome lists"

    # Step 1: Fetch the sindresorhus/awesome README
    awesome_readme = yield fetch_readme_operation.call(repo_identifier: SINDRESORHUS_AWESOME_REPO)
    Rails.logger.info "BootstrapAwesomeListsService: Fetched sindresorhus/awesome README"

    # Step 2: Extract all repository links from the README
    repo_links = yield @extract_awesome_lists_operation.call(markdown_content: awesome_readme[:content])
    Rails.logger.info "BootstrapAwesomeListsService: Found #{repo_links.size} repositories to bootstrap"

    # Step 3: Process each repository to create AwesomeList records
    successful_records = []
    failed_repos = []

    repo_links.each_with_index do |repo_identifier, index|
      Rails.logger.info "BootstrapAwesomeListsService: Processing #{index + 1}/#{repo_links.size}: #{repo_identifier}"

      # Fetch repository details - handle failure without yield
      repo_data_result = fetch_readme_operation.call(repo_identifier:)

      if repo_data_result.failure?
        Rails.logger.error "BootstrapAwesomeListsService: ❌ Failed to fetch #{repo_identifier}: #{repo_data_result.failure}"
        failed_repos << {error: repo_data_result.failure, repo: repo_identifier}
        next
      end

      # Create or update AwesomeList record - handle failure without yield
      awesome_list_result = find_or_create_awesome_list_operation.call(fetched_repo_data: repo_data_result.value!)

      if awesome_list_result.failure?
        Rails.logger.error "BootstrapAwesomeListsService: ❌ Failed to create AwesomeList for #{repo_identifier}: #{awesome_list_result.failure}"
        failed_repos << {error: awesome_list_result.failure, repo: repo_identifier}
        next
      end

      successful_records << awesome_list_result.value!
      Rails.logger.info "BootstrapAwesomeListsService: ✅ Created/updated AwesomeList for #{repo_identifier}"

      # Add a small delay to be respectful to GitHub API
      sleep(0.1) if index < repo_links.size - 1
    end

    Rails.logger.info "BootstrapAwesomeListsService: Completed bootstrap. " \
                      "Success: #{successful_records.size}, Failed: #{failed_repos.size}"

    if failed_repos.any?
      Rails.logger.warn "BootstrapAwesomeListsService: Failed repositories: #{failed_repos.pluck(:repo).join(', ')}"
    end

    Success({
      failed_count: failed_repos.size,
      failed_repos:,
      successful_count: successful_records.size,
      successful_records:,
      total_processed: repo_links.size
    })
  end
end
