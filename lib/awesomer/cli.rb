# frozen_string_literal: true

require 'thor'
require 'dotenv'
require 'fileutils'
require 'pathname'

# Load environment variables
begin
  Dotenv.load(
    File.expand_path('../../.env.development.local', __dir__),
    File.expand_path('../../.env.local', __dir__),
    File.expand_path('../../.env.development', __dir__),
    File.expand_path('../../.env', __dir__)
  )
rescue LoadError
  puts 'WARN: dotenv gem not available. Environment variables from .env files will not be loaded.'
rescue StandardError => e
  puts "WARN: Could not load .env files: #{e.message}"
end

# Load Rails environment if available
begin
  require_relative '../../config/environment'
rescue LoadError
  puts 'WARN: Rails environment not loaded. Some features might not be available.'
  unless defined?(Rails)
    module Rails
      def self.root
        Pathname.new(File.expand_path('../..', __dir__))
      end
    end
  end
end

# Load CLI commands
require_relative 'commands/bootstrap'
require_relative 'commands/process'
require_relative 'commands/worker'
require_relative 'commands/prune'
require_relative 'commands/publish'
require_relative 'commands/cleanup'
require_relative 'commands/update'
require_relative 'commands/sync'

module Awesomer
  class Cli < Thor
    def self.exit_on_failure?
      true
    end

    desc 'version', 'Show awesomer version'
    def version
      puts "Awesomer v#{Awesomer::VERSION}"
    end

    desc 'bootstrap SUBCOMMAND', 'Bootstrap awesome lists from various sources'
    subcommand 'bootstrap', Commands::Bootstrap

    desc 'process SUBCOMMAND', 'Process awesome lists and generate markdown'
    subcommand 'process', Commands::Process

    desc 'worker SUBCOMMAND', 'Manage sync worker for automated updates'
    subcommand 'worker', Commands::Worker

    desc 'prune', 'Archive stale awesome lists'
    long_desc <<-LONGDESC
      Archive awesome lists that haven't been updated in the specified timeframe.

      Examples:
        awesomer prune                    # Archive lists not updated in 365 days
        awesomer prune --since=180        # Archive lists not updated in 180 days#{'  '}
        awesomer prune --unarchive        # Also unarchive lists updated recently
        awesomer prune --dry-run          # Show what would be archived without changes
    LONGDESC
    option :since, default: 365, desc: 'Days since last update', type: :numeric
    option :unarchive, default: false, desc: 'Also unarchive fresh repositories', type: :boolean
    option :dry_run, default: false, desc: 'Preview changes without applying', type: :boolean
    def prune
      Commands::Prune.new.invoke(:execute, [], options)
    end

    desc 'publish', 'Publish changes to the public awesomer repository'
    def publish
      Awesomer::Commands::Publish.start
    end

    desc 'cleanup', 'Clean up empty files and reprocess failed lists'
    def cleanup
      Awesomer::Commands::Cleanup.start
    end

    desc 'sync', 'Complete sync with automatic sequence: sync → prune → generate markdown'
    long_desc <<-LONGDESC
      Run a complete sync that automatically:
      1. Syncs all GitHub stats for items
      2. Runs pruning to remove invalid lists
      3. Deletes old markdown files
      4. Generates fresh markdown files

      The command monitors progress with countdown timers and handles the entire
      sequence automatically. It will restart stalled processes and continue until
      100% of items have their GitHub stats synced.

      Examples:
        awesomer sync                       # Run with monitoring and countdown timers
        awesomer sync --no-monitor          # Run without countdown timers
        awesomer sync --max-iterations=50   # Limit to 50 monitoring loops
        awesomer sync --no-async            # Run synchronously (without background process)
    LONGDESC
    option :monitor, default: true, desc: 'Show progress monitoring', type: :boolean
    option :max_iterations, default: 100, desc: 'Maximum monitoring iterations', type: :numeric
    option :async, default: true, desc: 'Run sync asynchronously (false for synchronous)', type: :boolean
    def sync
      # Create new instance and invoke with options
      sync_command = Awesomer::Commands::Sync.new
      sync_command.options = options
      sync_command.invoke(:execute)
    end

    desc 'update', 'Update all awesome lists with GitHub stats and clean up'
    def update
      Awesomer::Commands::Update.start
    end

    desc 'status', 'Show current status of AwesomeList records in the database'
    def status
      puts '📊 AwesomeList Database Status'
      puts '=' * 30

      unless defined?(AwesomeList)
        say('ERROR: AwesomeList model not loaded. Cannot proceed.', :red)
        exit 1
      end

      total_count = AwesomeList.count
      active_count = AwesomeList.active.count
      archived_count = AwesomeList.archived.count

      puts "Total AwesomeList records: #{total_count}"
      puts "  Active: #{active_count}"
      puts "  Archived: #{archived_count}" if archived_count > 0

      if total_count > 0
        state_counts = AwesomeList.active.group(:state).count
        puts "\nStatus breakdown (active only):"
        state_counts.each do |state, count|
          emoji = case state
                  when 'pending' then '⏳'
                  when 'in_progress' then '🔄'
                  when 'completed' then '✅'
                  when 'failed' then '❌'
                  else '❓'
                  end
          puts "  #{emoji} #{state.capitalize}: #{count}"
        end

        recent_count = AwesomeList.where('created_at > ?', 1.day.ago).count
        puts "\nCreated in last 24 hours: #{recent_count}"

        latest = AwesomeList.order(created_at: :desc).limit(5)
        puts "\nLatest 5 records:"
        latest.each do |list|
          puts "  • #{list.github_repo} (#{list.name}) - #{list.created_at.strftime('%Y-%m-%d %H:%M')}"
        end
      else
        puts "\nNo AwesomeList records found. Run 'awesomer bootstrap lists' to populate the database."
      end
    end
  end
end
