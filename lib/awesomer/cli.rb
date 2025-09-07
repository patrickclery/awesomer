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
