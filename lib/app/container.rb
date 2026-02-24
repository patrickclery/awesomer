# frozen_string_literal: true

require 'dry/container'
require 'dry/auto_inject'

module App
  # Main DI container for the application
  class Container
    extend Dry::Container::Mixin

    register('parse_markdown_operation') { ParseMarkdownOperation.new }
    register('sync_git_stats_operation') { SyncGitStatsOperation.new }
    register('process_category_service') { ProcessCategoryService.new }
    register('fetch_readme_operation') { FetchReadmeOperation.new }
    register('find_or_create_awesome_list_operation') { FindOrCreateAwesomeListOperation.new }
    register('extract_awesome_lists_operation') { ExtractAwesomeListsOperation.new }
    register('bootstrap_awesome_lists_service') { BootstrapAwesomeListsService.new }
    register('persist_parsed_categories_operation') { PersistParsedCategoriesOperation.new }
    register('queue_star_history_jobs_operation') { QueueStarHistoryJobsOperation.new }
    register('snapshot_stars_operation') { SnapshotStarsOperation.new }
    register('backfill_star_snapshots_operation') { BackfillStarSnapshotsOperation.new }
    register('compute_trending_operation') { ComputeTrendingOperation.new }
  end
end
