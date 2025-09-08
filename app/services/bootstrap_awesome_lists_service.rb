# frozen_string_literal: true

class BootstrapAwesomeListsService
  include Dry::Monads[:result, :do]
  include App::Import[
    :fetch_readme_operation,
    :find_or_create_awesome_list_operation
  ]

  SINDRESORHUS_AWESOME_REPO = 'sindresorhus/awesome'
  BOOTSTRAP_FILE_PATH = Rails.root.join('static', 'bootstrap.md')

  def initialize(fetch_from_github: false, limit: nil, resurrect: false, **deps)
    @fetch_readme_operation = deps[:fetch_readme_operation] || App::Container['fetch_readme_operation']
    @find_or_create_awesome_list_operation =
      deps[:find_or_create_awesome_list_operation] || App::Container['find_or_create_awesome_list_operation']
    @extract_awesome_lists_operation = deps[:extract_awesome_lists_operation] || ExtractAwesomeListsOperation.new
    @fetch_from_github = fetch_from_github
    @limit = limit
    @resurrect = resurrect
  end

  def call
    Rails.logger.info 'BootstrapAwesomeListsService: Starting bootstrap of awesome lists'

    # Step 1: Get the sindresorhus/awesome README content
    awesome_readme = yield get_awesome_readme_content
    Rails.logger.info 'BootstrapAwesomeListsService: Retrieved sindresorhus/awesome README'

    # Step 2: Extract all repository links from the README
    repo_links = yield @extract_awesome_lists_operation.call(markdown_content: awesome_readme[:content])

    # Apply limit if specified
    if @limit && @limit > 0
      repo_links = repo_links.first(@limit)
      Rails.logger.info "BootstrapAwesomeListsService: Limited to first #{@limit} repositories"
    end

    Rails.logger.info "BootstrapAwesomeListsService: Processing #{repo_links.size} repositories"

    # Step 3: Process each repository to create AwesomeList records
    successful_records = []
    failed_repos = []
    skipped_archived = []
    resurrected_count = 0

    repo_links.each_with_index do |repo_identifier, index|
      Rails.logger.info "BootstrapAwesomeListsService: Processing #{index + 1}/#{repo_links.size}: #{repo_identifier}"

      # Check if this repository is archived and skip unless resurrect mode is enabled
      existing_list = AwesomeList.find_by(github_repo: repo_identifier)
      if existing_list&.archived? && !@resurrect
        Rails.logger.info "BootstrapAwesomeListsService: ⏭️  Skipping archived repository: #{repo_identifier}"
        skipped_archived << repo_identifier
        next
      end

      # Fetch repository details - handle failure without yield
      repo_data_result = fetch_readme_operation.call(repo_identifier:)

      if repo_data_result.failure?
        error_msg = "❌ Failed to fetch #{repo_identifier}: #{repo_data_result.failure}"
        Rails.logger.error "BootstrapAwesomeListsService: #{error_msg}"
        failed_repos << {error: repo_data_result.failure, repo: repo_identifier}
        next
      end

      # Create or update AwesomeList record - handle failure without yield
      awesome_list_result = find_or_create_awesome_list_operation.call(fetched_repo_data: repo_data_result.value!)

      if awesome_list_result.failure?
        error_msg = "❌ Failed to create AwesomeList for #{repo_identifier}: #{awesome_list_result.failure}"
        Rails.logger.error "BootstrapAwesomeListsService: #{error_msg}"
        failed_repos << {error: awesome_list_result.failure, repo: repo_identifier}
        next
      end

      awesome_list = awesome_list_result.value!

      # If resurrect mode is enabled and the list was archived, unarchive it
      if @resurrect && awesome_list.archived?
        Rails.logger.info "BootstrapAwesomeListsService: ♻️  Resurrecting archived repository: #{repo_identifier}"
        awesome_list.unarchive!
        resurrected_count += 1
      end

      successful_records << awesome_list
      Rails.logger.info "BootstrapAwesomeListsService: ✅ Created/updated AwesomeList for #{repo_identifier}"

      # Add a small delay to be respectful to GitHub API
      sleep(0.1) if index < repo_links.size - 1
    end

    Rails.logger.info 'BootstrapAwesomeListsService: Completed bootstrap. ' \
                      "Success: #{successful_records.size}, Failed: #{failed_repos.size}, " \
                      "Skipped (archived): #{skipped_archived.size}, Resurrected: #{resurrected_count}"

    if failed_repos.any?
      Rails.logger.warn "BootstrapAwesomeListsService: Failed repositories: #{failed_repos.pluck(:repo).join(', ')}"
    end

    Success({
      failed_count: failed_repos.size,
      failed_repos:,
      resurrected_count:,
      skipped_archived:,
      skipped_archived_count: skipped_archived.size,
      successful_count: successful_records.size,
      successful_records:,
      total_processed: repo_links.size
    })
  end

  private

  def get_awesome_readme_content
    if @fetch_from_github
      # Fetch from GitHub and update local file
      Rails.logger.info 'BootstrapAwesomeListsService: Fetching from GitHub'
      awesome_readme = yield fetch_readme_operation.call(repo_identifier: SINDRESORHUS_AWESOME_REPO)

      # Save to local file for future use
      File.write(BOOTSTRAP_FILE_PATH, awesome_readme[:content])
      Rails.logger.info 'BootstrapAwesomeListsService: Updated local bootstrap.md file'

      Success(awesome_readme)
    else
      # Use local file
      Rails.logger.info 'BootstrapAwesomeListsService: Using local bootstrap.md file'

      unless File.exist?(BOOTSTRAP_FILE_PATH)
        return Failure("Local bootstrap.md file not found at #{BOOTSTRAP_FILE_PATH}. Use --fetch to download it.")
      end

      content = File.read(BOOTSTRAP_FILE_PATH)
      Success({
        content:,
        last_commit_at: File.mtime(BOOTSTRAP_FILE_PATH),
        name: 'bootstrap.md',
        owner: 'sindresorhus',
        repo: 'awesome',
        repo_description: 'Awesome lists about all kinds of interesting topics (local file)'
      })
    end
  end
end
