# frozen_string_literal: true

require 'thor'
require 'fileutils'
require 'dry/monads'

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
# This might need to be adjusted based on how the Thor CLI is invoked (standalone vs. within Rails runner)
begin
  require_relative '../../config/environment' # Adjust path if CLI file moves
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
  # This can get complex; ideally, run Thor commands via `rails runner` or ensure env is loaded.
  # For this example, we assume operations and services might need explicit require if not in Rails context.
  # However, if environment loads, these should be available.
  begin
    # Ensure dependent operations/services for ProcessAwesomeListService are loaded first
    # if not handled by Rails autoloading via environment.rb
    require_relative '../../app/structs/structs/category_item' # Explicitly load structs for safety if env fails
    require_relative '../../app/structs/structs/category'
    require_relative '../../app/operations/fetch_readme_operation'
    require_relative '../../app/operations/parse_markdown_operation'
    require_relative '../../app/operations/sync_git_stats_operation'
    require_relative '../../app/services/process_category_service' # For ProcessCategoryService::TARGET_DIR const_set
    require_relative '../../app/services/process_awesome_list_service' # The main service for this CLI
  rescue LoadError => e
    puts "WARN: Could not manually load all required application files: #{e.message}. Ensure they are available."
  end
end

module Cli
  class MarkdownProcessor < Thor
    include Dry::Monads[:result]

    no_commands do
      # Helper method to get GitHub's actual rate limit reset time
      def get_github_rate_limit_info
        return nil unless defined?(Octokit)

        begin
          client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
          rate_limit = client.rate_limit
          {
            remaining: rate_limit.remaining,
            resets_at: Time.at(rate_limit.resets_at),
            resets_in: rate_limit.resets_in
          }
        rescue StandardError => e
          Rails.logger.error "Failed to get GitHub rate limit info: #{e.message}"
          nil
        end
      end

      # Helper method to check if we're rate limited by GitHub's API
      def github_rate_limited?
        info = get_github_rate_limit_info
        info && info[:remaining] <= 0
      end
    end

    desc 'sync', 'Process all awesome lists from the database'
    method_option :dry_run, default: false, desc: 'Show what would be processed without actually processing',
                            type: :boolean
    method_option :limit, desc: 'Limit the number of awesome lists to process', type: :numeric
    method_option :output_dir, default: 'tmp/batch_sync', desc: 'Base directory for all processed files',
                               type: :string
    method_option :sync, default: false, desc: 'Run in synchronous mode to fetch GitHub stats immediately',
                         type: :boolean
    method_option :wait_and_retry, default: false,
                                   desc: 'Automatically wait for rate limit resets and continue processing',
                                   type: :boolean
    method_option :incomplete_only, default: false, desc: 'Only process lists that are not completed',
                                    type: :boolean
    method_option :reset_status, default: false, desc: 'Reset all lists to pending status before processing',
                                 type: :boolean
    def sync
      unless defined?(AwesomeList)
        say('ERROR: AwesomeList model not loaded. Cannot proceed.', :red)
        exit 1
      end

      # Helper lambda to detect rate limit errors
      rate_limit_error = lambda do |error_message|
        error_message.downcase.include?('rate limit') ||
          error_message.downcase.include?('too many requests') ||
          (error_message.include?('403') && error_message.downcase.include?('api'))
      end

      # Handle status reset if requested
      if options[:reset_status]
        puts '🔄 Resetting all awesome list statuses to pending...'
        reset_count = AwesomeList.where.not(state: 'pending').count
        AwesomeList.where.not(state: 'pending').find_each(&:reset_for_reprocessing!)
        puts "✅ Reset #{reset_count} awesome lists to pending status"
        puts
      end

      # Query awesome lists based on options
      awesome_lists = if options[:incomplete_only]
                        puts '🎯 Processing only incomplete awesome lists...'
                        AwesomeList.incomplete
                      else
                        puts '📋 Processing all awesome lists...'
                        AwesomeList.all
                      end

      awesome_lists = awesome_lists.limit(options[:limit]) if options[:limit]
      total_count = awesome_lists.count

      if options[:dry_run]
        puts "🔍 Dry run: Would process #{total_count} awesome lists"
        puts
        puts 'Status breakdown:'
        status_counts = awesome_lists.group(:state).count
        status_counts.each do |status, count|
          puts "  #{status.to_s.capitalize}: #{count}"
        end
        puts
        awesome_lists.each_with_index do |awesome_list, index|
          status_emoji = case awesome_list.state
                         when 'pending' then "\u23F3"
                         when 'in_progress' then "\u{1F504}"
                         when 'completed' then "\u2705"
                         when 'failed' then "\u274C"
                         else "\u2753"
                         end
          puts "[#{index + 1}/#{total_count}] #{status_emoji} #{awesome_list.github_repo} (#{awesome_list.state})"
        end
        return
      end

      sync_mode = options[:sync] ? 'synchronous' : 'asynchronous'
      puts "🔄 Sync: Processing #{total_count} awesome lists in #{sync_mode} mode"

      # Create output directory
      output_dir = options[:output_dir]
      FileUtils.mkdir_p(output_dir)

      # Process each awesome list with automatic retry logic
      successful_count = 0
      failed_count = 0
      failed_repos = []

      awesome_lists.each_with_index do |awesome_list, index|
        repo_identifier = awesome_list.github_repo
        progress = "[#{index + 1}/#{total_count}]"

        # Retry logic for the current repository (infinite retries for rate limits)
        retry_count = 0

        loop do
          puts "#{progress} Processing #{repo_identifier}#{retry_count > 0 ? " (retry #{retry_count})" : ''}..."

          # Check GitHub's actual rate limit before processing
          if github_rate_limited?
            github_info = get_github_rate_limit_info
            reset_time_utc = github_info[:resets_at]
            wait_time = github_info[:resets_in]

            puts '⚠️  GitHub API rate limit reached!'
            puts "   • Processed: #{index}/#{total_count} repositories"
            puts "   • Remaining: #{total_count - index} repositories"
            puts "   • Rate limit resets in: #{wait_time} seconds"
            puts "   • Will resume at: #{reset_time_utc.in_time_zone}"
            puts "   • Remaining requests: #{github_info[:remaining]}"
            puts

            if options[:wait_and_retry]
              puts '⏳ Waiting for rate limit to reset...'
              puts "   • Will resume at: #{reset_time_utc.in_time_zone}"
              puts '   • Press Ctrl+C to stop and resume manually later'
              puts

              # Wait until the exact reset time (plus a small buffer) using GitHub's time
              current_time_utc = Time.current
              if reset_time_utc > current_time_utc
                sleep_duration = (reset_time_utc - current_time_utc) + 10 # 10 second buffer
                puts "   • Sleeping for #{sleep_duration.round} seconds..."
                puts "   • Current time: #{current_time_utc.in_time_zone}"
                puts "   • Reset time: #{reset_time_utc.in_time_zone}"
                sleep(sleep_duration)
              end

              puts '🔄 Rate limit reset! Resuming processing...'
              puts

              # Continue with current repository (rate limit should be reset)
              next
            else
              puts '🛑 Stopping sync to respect rate limits.'
              puts '💡 To resume processing later:'
              puts "   1. Wait until #{reset_time_utc.in_time_zone}"
              resume_limit = total_count - index
              sync_flag = options[:sync] ? '--sync' : ''
              puts '   2. Run: bundle exec ruby lib/cli/markdown_processor.rb sync ' \
                   "--limit #{resume_limit} #{sync_flag}".strip
              puts '   Or for async processing: bundle exec ruby lib/cli/markdown_processor.rb sync ' \
                   "--limit #{resume_limit}"
              puts '   Or for automatic retry: bundle exec ruby lib/cli/markdown_processor.rb sync ' \
                   "--limit #{resume_limit} #{sync_flag} --wait-and-retry".strip
              puts

              puts '⚠️  Sync stopped due to rate limiting!'
              puts '📊 Summary:'
              puts "   • Total to process: #{total_count}"
              puts "   • Successful: #{successful_count}"
              puts "   • Failed: #{failed_count}"
              puts "   • Skipped (rate limited): #{total_count - index}"
              puts
              puts "📁 Output directory: #{File.expand_path(output_dir)}"

              return
            end
          end

          # Double-check rate limit right before API call
          if github_rate_limited?
            puts '⚠️  Rate limit hit between checks, waiting...'
            if options[:wait_and_retry]
              github_info = get_github_rate_limit_info
              reset_time_utc = github_info[:resets_at]
              current_time_utc = Time.current
              if reset_time_utc > current_time_utc
                sleep_duration = (reset_time_utc - current_time_utc) + 10
                puts "   • Sleeping until #{reset_time_utc.in_time_zone} (#{sleep_duration.round} seconds)..."
                sleep(sleep_duration)
              end
              next # Continue to retry this repository
            else
              puts '❌ Stopping due to rate limit'
              return
            end
          end

          # Process the repository
          begin
            result = ProcessAwesomeListService.new(repo_identifier:, sync: options[:sync]).call

            if result.success?
              successful_count += 1
              puts "✅ Successfully processed #{repo_identifier}"
              break # Success - exit the retry loop and move to next repo
            else
              # Check if failure is due to rate limiting
              error_message = result.failure.to_s
              if rate_limit_error.call(error_message)
                puts '⚠️  Rate limit error detected in service operation'
                if options[:wait_and_retry]
                  puts '⏳ Waiting for rate limit to reset...'
                  github_info = get_github_rate_limit_info
                  if github_info
                    reset_time_utc = github_info[:resets_at]
                    puts "   • Will resume at: #{reset_time_utc.in_time_zone}"
                    current_time_utc = Time.current
                    if reset_time_utc > current_time_utc
                      sleep_duration = (reset_time_utc - current_time_utc) + 10
                      puts "   • Sleeping for #{sleep_duration.round} seconds..."
                      sleep(sleep_duration)
                    end
                  else
                    # Fallback to a reasonable wait time if we can't get rate limit info
                    puts '   • Using fallback wait time of 60 minutes...'
                    sleep(3600) # 1 hour
                  end
                  puts "🔄 Rate limit reset! Retrying #{repo_identifier}..."
                  retry_count += 1
                  next # Retry this repository indefinitely
                else
                  # Mark as failed due to rate limiting
                  begin
                    awesome_list.fail_processing!
                  rescue StandardError
                    nil
                  end
                  failed_count += 1
                  failed_repos << repo_identifier
                  puts "❌ Failed to process #{repo_identifier}: #{result.failure}"
                  break # Exit retry loop and move to next repo
                end
              else
                # Mark as failed due to other errors
                begin
                  awesome_list.fail_processing!
                rescue StandardError
                  nil
                end
                failed_count += 1
                failed_repos << repo_identifier
                puts "❌ Failed to process #{repo_identifier}: #{result.failure}"
                break # Exit retry loop and move to next repo
              end
            end
          rescue StandardError => e
            error_message = e.message
            if rate_limit_error.call(error_message)
              puts '⚠️  Rate limit error detected in exception'
              if options[:wait_and_retry]
                puts '⏳ Waiting for rate limit to reset...'
                github_info = get_github_rate_limit_info
                if github_info
                  reset_time_utc = github_info[:resets_at]
                  puts "   • Will resume at: #{reset_time_utc.in_time_zone}"
                  current_time_utc = Time.current
                  if reset_time_utc > current_time_utc
                    sleep_duration = (reset_time_utc - current_time_utc) + 10
                    puts "   • Sleeping for #{sleep_duration.round} seconds..."
                    sleep(sleep_duration)
                  end
                else
                  # Fallback to a reasonable wait time if we can't get rate limit info
                  puts '   • Using fallback wait time of 60 minutes...'
                  sleep(3600) # 1 hour
                end
                puts "🔄 Rate limit reset! Retrying #{repo_identifier}..."
                retry_count += 1
                next # Retry this repository indefinitely
              else
                # Mark as failed due to rate limiting
                begin
                  awesome_list.fail_processing!
                rescue StandardError
                  nil
                end
                failed_count += 1
                failed_repos << repo_identifier
                puts "❌ Error processing #{repo_identifier}: #{e.message}"
                break # Exit retry loop and move to next repo
              end
            else
              # Mark as failed due to other errors
              begin
                awesome_list.fail_processing!
              rescue StandardError
                nil
              end
              failed_count += 1
              failed_repos << repo_identifier
              puts "❌ Error processing #{repo_identifier}: #{e.message}"
              break # Exit retry loop and move to next repo
            end
          end
        end

        # Add a small delay between repositories to be respectful
        sleep(0.5) if options[:sync]
      end

      puts
      puts '✅ Sync completed!'
      puts '📊 Final Summary:'
      puts "   • Total processed: #{total_count}"
      puts "   • Successful: #{successful_count}"
      puts "   • Failed: #{failed_count}"

      if failed_repos.any?
        puts '   • Failed repositories:'
        failed_repos.each { |repo| puts "     - #{repo}" }
      end

      puts
      puts "📁 Output directory: #{File.expand_path(output_dir)}"
    end

    desc 'process_repo REPO_IDENTIFIER',
         "Processes a GitHub repo (e.g., 'owner/repo' or URL), fetches README, stats, " \
         'and saves a single aggregated output file to specified directory (default: tmp/md/)'
    method_option :output_dir, default: 'tmp/md', desc: 'Directory to save the markdown file', type: :string
    method_option :output_filename, default: ProcessCategoryService::OUTPUT_FILENAME,
                                    desc: 'Filename for the processed markdown output', type: :string
    method_option :sync, default: false, desc: 'Run in synchronous mode to fetch GitHub stats immediately',
                         type: :boolean
    def process_repo(repo_identifier)
      sync_mode = options[:sync]
      mode_text = sync_mode ? 'synchronous' : 'asynchronous'
      puts "Starting repository processing for '#{repo_identifier}' in #{mode_text} mode via Thor..."

      custom_output_dir = Rails.root.join(options[:output_dir])
      # The actual filename will be determined by ProcessCategoryService::OUTPUT_FILENAME,
      # but it will be placed in custom_output_dir due to TARGET_DIR override.

      begin
        FileUtils.mkdir_p(custom_output_dir)
      rescue StandardError => e
        say("ERROR: Could not create custom output directory #{custom_output_dir}: #{e.message}", :red)
        exit 1
      end

      unless defined?(ProcessAwesomeListService) && defined?(ProcessCategoryService)
        say('ERROR: ProcessAwesomeListService or ProcessCategoryService not loaded. Cannot proceed.', :red)
        exit 1
      end

      original_pcs_target_dir = ProcessCategoryService::TARGET_DIR
      original_pcs_output_filename = ProcessCategoryService::OUTPUT_FILENAME # Save original filename

      begin
        silence_warnings do
          ProcessCategoryService.const_set(:TARGET_DIR, custom_output_dir)
          # If you want the Thor task to control the filename too:
          ProcessCategoryService.const_set(:OUTPUT_FILENAME, options[:output_filename])
        end
        puts "Temporarily set ProcessCategoryService output to: #{custom_output_dir.join(options[:output_filename])}"

        awesome_list_service = ProcessAwesomeListService.new(repo_identifier:, sync: sync_mode)
        result = awesome_list_service.call

        if result.success?
          # Result.value! is now a single file path
          say("Successfully processed repository '#{repo_identifier}' in #{mode_text} mode. Output file:", :green)
          puts "- #{result.value!}"

          if sync_mode
            puts '✅ GitHub stats were fetched synchronously and included in the output file.'
          else
            puts '⏳ GitHub stats are being processed in the background. The file will be updated when complete.'
          end
        else
          say("ERROR: Failed to process repository '#{repo_identifier}': #{result.failure}", :red)
        end
      rescue StandardError => e
        say("ERROR: An unexpected error occurred: #{e.message}\n#{e.backtrace.first(5).join("\n")}", :red)
      ensure
        silence_warnings do
          ProcessCategoryService.const_set(:TARGET_DIR, original_pcs_target_dir)
          ProcessCategoryService.const_set(:OUTPUT_FILENAME, original_pcs_output_filename) # Restore filename
        end
        puts 'Restored original TARGET_DIR and OUTPUT_FILENAME for ProcessCategoryService.'
      end

      puts 'Repository processing finished.'
    end

    desc 'process_snippet',
         'Processes a predefined repo (e.g. Polycarbohydrate/awesome-tor) and saves output to tmp/md_snippet_test/'
    method_option :sync, default: false, desc: 'Run in synchronous mode to fetch GitHub stats immediately',
                         type: :boolean
    def process_snippet
      say('Process_snippet command is now a shortcut to process a predefined repo for testing.', :yellow)
      # Using a different output directory and potentially filename for this specific command
      invoke(:process_repo, ['Polycarbohydrate/awesome-tor'],
             output_dir: 'tmp/md_snippet_test',
             output_filename: 'awesome_tor_snippet_processed.md',
             sync: options[:sync])
    end

    private

    def process_single_awesome_list(output_dir:, repo_identifier:, sync_mode:)
      unless defined?(ProcessAwesomeListService) && defined?(ProcessCategoryService)
        return Failure('ProcessAwesomeListService or ProcessCategoryService not loaded')
      end

      original_pcs_target_dir = ProcessCategoryService::TARGET_DIR
      original_pcs_output_filename = ProcessCategoryService::OUTPUT_FILENAME

      begin
        # Set unique output filename based on repo identifier
        sanitized_name = repo_identifier.tr('/', '_').gsub(/[^\w\-_.]/, '')
        output_filename = "#{sanitized_name}_processed.md"

        silence_warnings do
          ProcessCategoryService.const_set(:TARGET_DIR, output_dir)
          ProcessCategoryService.const_set(:OUTPUT_FILENAME, output_filename)
        end

        awesome_list_service = ProcessAwesomeListService.new(repo_identifier:, sync: sync_mode)
        result = awesome_list_service.call

        if result.success?
          Success(result.value!)
        else
          Failure(result.failure)
        end
      rescue StandardError => e
        Failure("Exception: #{e.message}")
      ensure
        silence_warnings do
          ProcessCategoryService.const_set(:TARGET_DIR, original_pcs_target_dir)
          ProcessCategoryService.const_set(:OUTPUT_FILENAME, original_pcs_output_filename)
        end
      end
    end
  end
end

# To make this runnable directly for testing: `ruby lib/cli/markdown_processor.rb process_snippet`
# However, for full Rails context, it's better to invoke Thor CĻIs via `rails runner` or a binstub.
if __FILE__ == $PROGRAM_NAME
  # Ensure ARGV is passed correctly if Thor expects it for command dispatch
  # For a specific command, you might call it directly or let Thor parse ARGV.
  # Thor.start will parse ARGV to find the command.
  Cli::MarkdownProcessor.start(ARGV)
end
