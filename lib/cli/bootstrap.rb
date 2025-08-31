# frozen_string_literal: true

require 'thor'
require 'fileutils'

# Load dotenv first to ensure environment variables are available
begin
  require 'dotenv'
  # Load .env files in order of precedence
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

# Attempt to load Rails environment for Rails.root and autoloading
begin
  require_relative '../../config/environment'
rescue LoadError
  puts 'WARN: Rails environment not loaded. Some features might not be available (e.g., Rails.root).'
  # Define Rails.root if not present for basic pathing, assuming script is in project_root/lib/cli
  unless defined?(Rails)
    module Rails
      def self.root
        Pathname.new(File.expand_path('../..', __dir__))
      end
    end
  end
  # Manually require necessary app files if not autoloaded - this is a fallback
  begin
    require_relative '../../app/operations/fetch_readme_operation'
    require_relative '../../app/operations/find_or_create_awesome_list_operation'
    require_relative '../../app/operations/extract_awesome_lists_operation'
    require_relative '../../app/services/bootstrap_awesome_lists_service'
  rescue LoadError => e
    puts "WARN: Could not manually load all required application files: #{e.message}. Ensure they are available."
  end
end

module Cli
  class Bootstrap < Thor
    desc 'awesome_lists',
         'Bootstrap all awesome lists from sindresorhus/awesome repository. ' \
         'Fetches the main awesome list, extracts all GitHub repository links, ' \
         'and creates AwesomeList records for each repository.'
    method_option :dry_run, default: false, desc: 'Show what would be bootstrapped without actually creating records',
                            type: :boolean
    method_option :limit, desc: 'Limit the number of repositories to process (for testing)', type: :numeric
    method_option :verbose, default: false, desc: 'Enable verbose logging', type: :boolean
    method_option :fetch, default: false,
                          desc: 'Fetch fresh data from GitHub instead of using local bootstrap.md',
                          type: :boolean
    def awesome_lists
      puts '🚀 Bootstrap Awesome Lists'
      puts '=' * 50

      unless ENV['GITHUB_API_KEY']
        say('ERROR: GITHUB_API_KEY environment variable is required for API access.', :red)
        say('Please set your GitHub Personal Access Token in .env.development.local', :yellow)
        exit 1
      end

      unless defined?(BootstrapAwesomeListsService)
        say('ERROR: BootstrapAwesomeListsService not loaded. Cannot proceed.', :red)
        exit 1
      end

      Rails.logger.level = Logger::DEBUG if options[:verbose]

      if options[:dry_run]
        puts '🧪 DRY RUN MODE - No records will be created'
        puts
      end

      source_info = if options[:fetch]
                      '📡 Fetching fresh data from sindresorhus/awesome repository...'
                    else
                      '📁 Using local bootstrap.md file...'
                    end
      puts source_info

      begin
        bootstrap_service = BootstrapAwesomeListsService.new(
          fetch_from_github: options[:fetch],
          limit: options[:limit]
        )

        if options[:dry_run]
          # For dry run, we'll still get the content to show what would be processed
          if options[:fetch]
            fetch_operation = FetchReadmeOperation.new
            awesome_readme = fetch_operation.call(repo_identifier: 'sindresorhus/awesome')
          else
            bootstrap_file_path = Rails.root.join('static', 'bootstrap.md')
            unless File.exist?(bootstrap_file_path)
              say('ERROR: Local bootstrap.md file not found. Use --fetch to download it.', :red)
              exit 1
            end
            content = File.read(bootstrap_file_path)
            awesome_readme = Dry::Monads::Success({content:})
          end

          if awesome_readme.success?
            extract_operation = ExtractAwesomeListsOperation.new
            repo_links = extract_operation.call(markdown_content: awesome_readme.value![:content])

            if repo_links.success?
              total_repos = repo_links.value!.size
              limited_repos = options[:limit] ? repo_links.value!.first(options[:limit]) : repo_links.value!

              limit_info = options[:limit] ? " (limited from #{total_repos})" : ''
              puts "📋 Would process #{limited_repos.size} repositories#{limit_info}:"
              puts

              limited_repos.each_with_index do |repo, index|
                puts "#{format('%3d', index + 1)}. #{repo}"
              end

              puts
              puts '✅ Dry run completed. Use --no-dry-run to actually bootstrap the repositories.'
            else
              say("ERROR: Failed to extract repository links: #{repo_links.failure}", :red)
            end
          else
            say("ERROR: Failed to fetch sindresorhus/awesome: #{awesome_readme.failure}", :red)
          end
        else
          # Regular bootstrap process
          result = bootstrap_service.call

          if result.success?
            data = result.value!

            puts
            puts '✅ Bootstrap completed successfully!'
            puts '📊 Summary:'
            puts "   • Total repositories found: #{data[:total_processed]}"
            puts "   • Successfully created/updated: #{data[:successful_count]}"
            puts "   • Failed: #{data[:failed_count]}"

            if data[:failed_count] > 0
              puts
              puts '❌ Failed repositories:'
              data[:failed_repos].each do |failed|
                puts "   • #{failed[:repo]}: #{failed[:error]}"
              end
            end

            puts
            puts '🎉 All done! AwesomeList records are now available in the database.'

          else
            say("ERROR: Bootstrap failed: #{result.failure}", :red)
            exit 1
          end
        end
      rescue StandardError => e
        say("ERROR: An unexpected error occurred: #{e.message}", :red)
        puts e.backtrace.first(5).join("\n") if options[:verbose]
        exit 1
      end
    end

    desc 'status',
         'Show current status of AwesomeList records in the database'
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
        recent_count = AwesomeList.where('created_at > ?', 1.day.ago).count
        puts "Created in last 24 hours: #{recent_count}"

        latest = AwesomeList.order(created_at: :desc).limit(5)
        puts
        puts 'Latest 5 records:'
        latest.each do |list|
          puts "  • #{list.github_repo} (#{list.name}) - #{list.created_at.strftime('%Y-%m-%d %H:%M')}"
        end
      else
        puts
        puts "No AwesomeList records found. Run 'bootstrap awesome_lists' to populate the database."
      end
    end
  end
end

# To make this runnable directly for testing
Cli::Bootstrap.start(ARGV) if __FILE__ == $PROGRAM_NAME
