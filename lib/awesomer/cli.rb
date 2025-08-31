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

    desc 'status', 'Show current status of AwesomeList records in the database'
    def status
      puts '📊 AwesomeList Database Status'
      puts '=' * 30

      unless defined?(AwesomeList)
        say('ERROR: AwesomeList model not loaded. Cannot proceed.', :red)
        exit 1
      end

      total_count = AwesomeList.count
      puts "Total AwesomeList records: #{total_count}"

      if total_count > 0
        state_counts = AwesomeList.group(:state).count
        puts "\nStatus breakdown:"
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
