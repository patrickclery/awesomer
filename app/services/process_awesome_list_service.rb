# frozen_string_literal: true

require "fileutils" # For FileUtils.mkdir_p

class ProcessAwesomeListService
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]
  include App::Import[
    :fetch_readme_operation,
    :parse_markdown_operation,
    :sync_git_stats_operation,
    :process_category_service,
    :find_or_create_awesome_list_operation
  ]

  def initialize(repo_identifier:, **deps)
    @fetch_readme_operation = deps[:fetch_readme_operation] || App::Container["fetch_readme_operation"]
    @parse_markdown_operation = deps[:parse_markdown_operation] || App::Container["parse_markdown_operation"]
    @sync_git_stats_operation = deps[:sync_git_stats_operation] || App::Container["sync_git_stats_operation"]
    @process_category_service = deps[:process_category_service] || App::Container["process_category_service"]
    @find_or_create_awesome_list_operation = deps[:find_or_create_awesome_list_operation] || App::Container["find_or_create_awesome_list_operation"]
    @repo_identifier = repo_identifier
  end

  def call
    return Failure("Repository identifier must be provided") if @repo_identifier.blank?

    fetched_data = yield fetch_readme_operation.call(repo_identifier: @repo_identifier)

    # Determine the repo_shortname for finding/creating the AwesomeList record
    repo_shortname = "#{fetched_data[:owner]}/#{fetched_data[:repo]}"
    aw_list_record = yield find_or_create_awesome_list_operation.call(fetched_repo_data: fetched_data)

    # Pass the skip_external_links flag from the AwesomeList record to the parser
    skip_links_flag = aw_list_record.skip_external_links
    # puts "DEBUG: Processing with skip_external_links: #{skip_links_flag}" # Optional debug

    markdown_content = fetched_data[:content]
    categories_from_parse = yield parse_markdown_operation.call(
      markdown_content:,
      skip_external_links: skip_links_flag
    )
    return Success([]) if categories_from_parse.empty?

    sync_result = sync_git_stats_operation.call(categories: categories_from_parse)
    categories_to_process_md = if sync_result.success?
                                 sync_result.value!
    else
                                 puts "WARN (ProcessAwesomeListService): Failed to sync GitHub stats for items: #{sync_result.failure}. Proceeding with original parsed data."
                                 categories_from_parse
    end

    final_markdown_files_result = yield process_category_service.call(categories: categories_to_process_md)

    Success(final_markdown_files_result)
    # ActiveRecord::ActiveRecordError is now handled within FindOrCreateAwesomeListOperation
    # and will be propagated as a Failure by the yield above if it occurs.
  end
end
