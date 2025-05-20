# frozen_string_literal: true

require "fileutils" # For FileUtils.mkdir_p

class ProcessAwesomeListService
  include Dry::Monads[:result, :do]
  include App::Import[
    :fetch_readme_operation,
    :parse_markdown_operation,
    :process_category_service,
    :sync_git_stats_operation
  ]

  def initialize(repo_identifier:, **deps)
    @fetch_readme_operation = deps[:fetch_readme_operation] || App::Container["fetch_readme_operation"]
    @parse_markdown_operation = deps[:parse_markdown_operation] || App::Container["parse_markdown_operation"]
    @sync_git_stats_operation = deps[:sync_git_stats_operation] || App::Container["sync_git_stats_operation"]
    @process_category_service = deps[:process_category_service] || App::Container["process_category_service"]

    @repo_identifier = repo_identifier
  end

  def call
    return Failure("Repository identifier must be provided") if @repo_identifier.blank?

    markdown_content = yield fetch_readme_operation.call(repo_identifier: @repo_identifier)

    categories_from_parse = yield parse_markdown_operation.call(markdown_content:)
    return Success([]) if categories_from_parse.empty?

    sync_result = sync_git_stats_operation.call(categories: categories_from_parse)
    categories_to_process_md = if sync_result.success?
                                 sync_result.value!
    else
                                 puts "WARN (ProcessAwesomeListService): Failed to sync GitHub stats: #{sync_result.failure}. Proceeding with original parsed data."
                                 categories_from_parse
    end

    final_markdown_files_result = yield process_category_service.call(categories: categories_to_process_md)

    Success(final_markdown_files_result)
  end
end
