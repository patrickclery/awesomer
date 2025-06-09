# frozen_string_literal: true

require "thor"
require "fileutils"
require "dry/monads"

# Load dotenv first to ensure environment variables are available
begin
  require "dotenv"
  # Load .env files in order of precedence
  Dotenv.load(
    File.expand_path("../../.env.development.local", __dir__),
    File.expand_path("../../.env.local", __dir__),
    File.expand_path("../../.env.development", __dir__),
    File.expand_path("../../.env", __dir__)
  )
rescue LoadError
  puts "WARN: dotenv gem not available. Environment variables from .env files will not be loaded."
rescue StandardError => e
  puts "WARN: Could not load .env files: #{e.message}"
end

# Attempt to load Rails environment for Rails.root and autoloading
# This might need to be adjusted based on how the Thor CLI is invoked (standalone vs. within Rails runner)
begin
  require_relative "../../config/environment" # Adjust path if CLI file moves
rescue LoadError
  puts "WARN: Rails environment not loaded. Some features might not be available (e.g., Rails.root)."
  # Define Rails.root if not present for basic pathing, assuming script is in project_root/lib/cli
  unless defined?(Rails)
    module Rails
      def self.root
        Pathname.new(File.expand_path("../..", __dir__))
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
    require_relative "../../app/structs/structs/category_item" # Explicitly load structs for safety if env fails
    require_relative "../../app/structs/structs/category"
    require_relative "../../app/operations/fetch_readme_operation"
    require_relative "../../app/operations/parse_markdown_operation"
    require_relative "../../app/operations/sync_git_stats_operation"
    require_relative "../../app/services/process_category_service" # For ProcessCategoryService::TARGET_DIR const_set
    require_relative "../../app/services/process_awesome_list_service" # The main service for this CLI
  rescue LoadError => e
    puts "WARN: Could not manually load all required application files: #{e.message}. Ensure they are available."
  end
end

module Cli
  class MarkdownProcessor < Thor
    include Dry::Monads[:result]

    desc "sync", "Process all awesome lists from the database"
    method_option :dry_run, default: false, desc: "Show what would be processed without actually processing",
                  type: :boolean
    method_option :limit, desc: "Limit the number of awesome lists to process", type: :numeric
    method_option :output_dir, default: "tmp/batch_sync", desc: "Base directory for all processed files",
                  type: :string
    method_option :sync, default: false, desc: "Run in synchronous mode to fetch GitHub stats immediately",
                  type: :boolean
    def sync
      unless defined?(AwesomeList)
        say("ERROR: AwesomeList model not loaded. Cannot proceed.", :red)
        exit 1
      end

      # Query awesome lists from database
      awesome_lists = AwesomeList.order(:created_at)
      awesome_lists = awesome_lists.limit(options[:limit]) if options[:limit]

      total_count = awesome_lists.count
      sync_mode = options[:sync]
      mode_text = sync_mode ? "synchronous" : "asynchronous"

      say("🔄 Sync: Processing #{total_count} awesome lists in #{mode_text} mode", :green)

      if options[:dry_run]
        say("🔍 DRY RUN: Would process the following awesome lists:", :yellow)
        awesome_lists.each_with_index do |awesome_list, index|
          puts "  #{index + 1}. #{awesome_list.github_repo} (#{awesome_list.name})"
        end
        puts
        say("Total: #{total_count} awesome lists would be processed", :yellow)
        return
      end

      # Create base output directory
      base_output_dir = Rails.root.join(options[:output_dir])
      begin
        FileUtils.mkdir_p(base_output_dir)
      rescue StandardError => e
        say("ERROR: Could not create base output directory #{base_output_dir}: #{e.message}", :red)
        exit 1
      end

      # Initialize rate limiter for sync mode
      rate_limiter = nil
      if sync_mode
        unless defined?(GithubRateLimiterService)
          say("ERROR: GithubRateLimiterService not loaded. Cannot proceed with sync mode.", :red)
          exit 1
        end
        rate_limiter = GithubRateLimiterService.new
      end

      # Process each awesome list
      successful_count = 0
      failed_count = 0
      failed_repos = []
      rate_limited_count = 0

      awesome_lists.each_with_index do |awesome_list, index|
        repo_identifier = awesome_list.github_repo
        progress = "[#{index + 1}/#{total_count}]"

        puts "#{progress} Processing #{repo_identifier}..."

        # Check rate limit before processing each awesome list in sync mode
        if sync_mode && rate_limiter
          unless rate_limiter.can_make_request?
            wait_time = rate_limiter.time_until_reset
            remaining_repos = total_count - index
            
            say("⚠️  GitHub API rate limit reached!", :yellow)
            puts "   • Processed: #{index}/#{total_count} repositories"
            puts "   • Remaining: #{remaining_repos} repositories"
            puts "   • Rate limit resets in: #{wait_time} seconds (#{Time.at(Time.current.to_i + wait_time)})"
            puts "   • Remaining requests: #{rate_limiter.requests_remaining}"
            puts ""
            say("🛑 Stopping sync to respect rate limits.", :red)
            puts "💡 To resume processing later:"
            puts "   1. Wait until #{Time.at(Time.current.to_i + wait_time)}"
            puts "   2. Run: bundle exec ruby lib/cli/markdown_processor.rb sync --limit #{remaining_repos} --sync"
            puts "   Or for async processing: bundle exec ruby lib/cli/markdown_processor.rb sync --limit #{remaining_repos}"
            
            rate_limited_count = remaining_repos
            break
          end
        end

        begin
          # Create subdirectory for this repo (sanitize repo name for filesystem)
          sanitized_name = repo_identifier.gsub("/", "_").gsub(/[^\w\-_.]/, "")
          repo_output_dir = base_output_dir.join(sanitized_name)
          FileUtils.mkdir_p(repo_output_dir)

          # Process this awesome list
          result = process_single_awesome_list(
            output_dir: repo_output_dir,
            repo_identifier:,
            sync_mode:
          )

          if result.success?
            puts "  ✅ Success: #{result.value!}"
            successful_count += 1
          else
            puts "  ❌ Failed: #{result.failure}"
            failed_count += 1
            failed_repos << {error: result.failure, repo: repo_identifier}
          end

        rescue StandardError => e
          puts "  💥 Exception: #{e.message}"
          failed_count += 1
          failed_repos << {error: "Exception: #{e.message}", repo: repo_identifier}
        end

        # Add a small delay to be respectful to external APIs
        sleep(0.1) unless sync_mode
      end

      # Summary
      puts
      if rate_limited_count > 0
        say("⚠️  Sync stopped due to rate limiting!", :yellow)
      else
        say("🎉 Sync completed!", :green)
      end
      
      puts "📊 Summary:"
      puts "   • Total to process: #{total_count}"
      puts "   • Successful: #{successful_count}"
      puts "   • Failed: #{failed_count}"
      
      if rate_limited_count > 0
        puts "   • Skipped (rate limited): #{rate_limited_count}"
      end

      if failed_repos.any?
        puts
        say("❌ Failed repositories:", :red)
        failed_repos.each do |failure|
          puts "   • #{failure[:repo]}: #{failure[:error]}"
        end
      end

      puts
      puts "📁 Output directory: #{base_output_dir}"
    end

    desc "process_repo REPO_IDENTIFIER",
         "Processes a GitHub repo (e.g., 'owner/repo' or URL), fetches README, stats, " \
         "and saves a single aggregated output file to specified directory (default: tmp/md/)"
    method_option :output_dir, default: "tmp/md", desc: "Directory to save the markdown file", type: :string
    method_option :output_filename, default: ProcessCategoryService::OUTPUT_FILENAME,
                  desc: "Filename for the processed markdown output", type: :string
    method_option :sync, default: false, desc: "Run in synchronous mode to fetch GitHub stats immediately",
type: :boolean
    def process_repo(repo_identifier)
      sync_mode = options[:sync]
      mode_text = sync_mode ? "synchronous" : "asynchronous"
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
        say("ERROR: ProcessAwesomeListService or ProcessCategoryService not loaded. Cannot proceed.", :red)
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
            puts "✅ GitHub stats were fetched synchronously and included in the output file."
          else
            puts "⏳ GitHub stats are being processed in the background. The file will be updated when complete."
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
        puts "Restored original TARGET_DIR and OUTPUT_FILENAME for ProcessCategoryService."
      end

      puts "Repository processing finished."
    end

    desc "process_snippet",
         "Processes a predefined repo (e.g. Polycarbohydrate/awesome-tor) and saves output to tmp/md_snippet_test/"
    method_option :sync, default: false, desc: "Run in synchronous mode to fetch GitHub stats immediately",
type: :boolean
    def process_snippet
      say("Process_snippet command is now a shortcut to process a predefined repo for testing.", :yellow)
      # Using a different output directory and potentially filename for this specific command
      invoke(:process_repo, [ "Polycarbohydrate/awesome-tor" ],
             output_dir: "tmp/md_snippet_test",
             output_filename: "awesome_tor_snippet_processed.md",
             sync: options[:sync])
    end

    private

    def process_single_awesome_list(output_dir:, repo_identifier:, sync_mode:)
      unless defined?(ProcessAwesomeListService) && defined?(ProcessCategoryService)
        return Failure("ProcessAwesomeListService or ProcessCategoryService not loaded")
      end

      original_pcs_target_dir = ProcessCategoryService::TARGET_DIR
      original_pcs_output_filename = ProcessCategoryService::OUTPUT_FILENAME

      begin
        # Set unique output filename based on repo identifier
        sanitized_name = repo_identifier.gsub("/", "_").gsub(/[^\w\-_.]/, "")
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
