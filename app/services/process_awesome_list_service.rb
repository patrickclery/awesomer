# frozen_string_literal: true

require 'fileutils' # For FileUtils.mkdir_p

class ProcessAwesomeListService
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]
  include App::Import[
    :fetch_readme_operation,
    :parse_markdown_operation,
    :sync_git_stats_operation,
    :process_category_service,
    :find_or_create_awesome_list_operation,
    :persist_parsed_categories_operation,
    :queue_star_history_jobs_operation
  ]

  def initialize(repo_identifier:, sync: false, fetch_star_history: true, skip_markdown: false, **deps)
    @fetch_readme_operation = deps[:fetch_readme_operation] || App::Container['fetch_readme_operation']
    @parse_markdown_operation = deps[:parse_markdown_operation] || App::Container['parse_markdown_operation']
    @sync_git_stats_operation = deps[:sync_git_stats_operation] || App::Container['sync_git_stats_operation']
    @process_category_service = deps[:process_category_service] || App::Container['process_category_service']
    @find_or_create_awesome_list_operation =
      deps[:find_or_create_awesome_list_operation] || App::Container['find_or_create_awesome_list_operation']
    @persist_parsed_categories_operation =
      deps[:persist_parsed_categories_operation] || App::Container['persist_parsed_categories_operation']
    @queue_star_history_jobs_operation =
      deps[:queue_star_history_jobs_operation] || App::Container['queue_star_history_jobs_operation']
    @repo_identifier = repo_identifier
    @sync = sync
    @fetch_star_history = fetch_star_history
    @skip_markdown = skip_markdown
  end

  def call
    return Failure('Repository identifier must be provided') if @repo_identifier.blank?

    fetched_data = yield fetch_readme_operation.call(repo_identifier: @repo_identifier)

    # Determine the repo_shortname for finding/creating the AwesomeList record
    aw_list_record = yield find_or_create_awesome_list_operation.call(fetched_repo_data: fetched_data)

    # Mark as started processing
    aw_list_record.start_processing!

    begin
      # Pass the skip_external_links flag from the AwesomeList record to the parser
      skip_links_flag = aw_list_record.skip_external_links
      # puts "DEBUG: Processing with skip_external_links: #{skip_links_flag}" # Optional debug

      markdown_content = fetched_data[:content]
      categories_from_parse = yield parse_markdown_operation.call(
        markdown_content:,
        skip_external_links: skip_links_flag
      )
      return Success([]) if categories_from_parse.empty?

      sync_result = sync_git_stats_operation.call(
        categories: categories_from_parse,
        repo_identifier: @repo_identifier,
        sync: @sync
      )

      # Only proceed if sync succeeds when sync mode is enabled
      if @sync && sync_result.failure?
        Rails.logger.error "ProcessAwesomeListService: Failed to sync GitHub stats in sync mode: #{sync_result.failure}"
        # Mark as failed since we couldn't get the required GitHub stats
        aw_list_record.fail_processing!
        return Failure("GitHub stats sync failed: #{sync_result.failure}")
      end

      categories_to_process_md = if sync_result.success?
                                   sync_result.value!
                                 else
                                   Rails.logger.warn 'ProcessAwesomeListService: Failed to sync GitHub stats for ' \
                                                     "items: #{sync_result.failure}. Proceeding with original " \
                                                     'parsed data.'
                                   categories_from_parse
                                 end

      # Persist categories to database
      persist_result = @persist_parsed_categories_operation.call(
        awesome_list: aw_list_record,
        parsed_categories: categories_to_process_md
      )

      Rails.logger.error "Failed to persist categories: #{persist_result.failure}" if persist_result.failure?

      # Queue star history jobs for trending data (async, doesn't block)
      if @fetch_star_history && persist_result.success?
        history_result = @queue_star_history_jobs_operation.call(awesome_list: aw_list_record)
        if history_result.failure?
          Rails.logger.warn "Failed to queue star history jobs: #{history_result.failure}"
        end
      end

      # Skip markdown generation when caller handles it separately (e.g., refresh command)
      unless @skip_markdown
        final_markdown_files_result = yield process_category_service.call(
          categories: categories_to_process_md,
          repo_identifier: @repo_identifier
        )
      end

      # Mark as completed successfully
      aw_list_record.complete_processing!

      Success(@skip_markdown ? categories_to_process_md : final_markdown_files_result)
    rescue StandardError => e
      # Mark as failed if any error occurs
      aw_list_record.fail_processing!
      raise e
    end
    # ActiveRecord::ActiveRecordError is now handled within FindOrCreateAwesomeListOperation
    # and will be propagated as a Failure by the yield above if it occurs.
  end
end
