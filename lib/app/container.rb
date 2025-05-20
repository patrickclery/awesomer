# frozen_string_literal: true

require "dry/container"
require "dry/auto_inject"

module App
  # Main DI container for the application
  class Container
    extend Dry::Container::Mixin

    register("parse_markdown_operation") { ParseMarkdownOperation.new }
    register("sync_git_stats_operation") { SyncGitStatsOperation.new }
    register("process_category_service") { ProcessCategoryService.new }
    register("fetch_readme_operation") { FetchReadmeOperation.new }
    register("find_or_create_awesome_list_operation") { FindOrCreateAwesomeListOperation.new }
  end
end
