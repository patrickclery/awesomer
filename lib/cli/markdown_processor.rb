# frozen_string_literal: true

require "thor"
require "fileutils"
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
        ProcessCategoryService.const_set(:TARGET_DIR, custom_output_dir)
        # If you want the Thor task to control the filename too:
        ProcessCategoryService.const_set(:OUTPUT_FILENAME, options[:output_filename])
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
        ProcessCategoryService.const_set(:TARGET_DIR, original_pcs_target_dir)
        ProcessCategoryService.const_set(:OUTPUT_FILENAME, original_pcs_output_filename) # Restore filename
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
