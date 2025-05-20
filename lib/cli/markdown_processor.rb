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
    desc "process_repo REPO_IDENTIFIER", "Processes a GitHub repo (e.g., 'owner/repo' or URL), fetches README, stats, and saves output to tmp/md/"
    method_option :output_dir, default: "tmp/md", desc: "Directory to save markdown files", type: :string
    def process_repo(repo_identifier)
      puts "Starting repository processing for '#{repo_identifier}' via Thor..."

      # Use output_dir from options, ensure it's an absolute path
      custom_output_dir = Rails.root.join(options[:output_dir])

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

      original_process_category_target_dir = ProcessCategoryService::TARGET_DIR
      begin
        ProcessCategoryService.const_set(:TARGET_DIR, custom_output_dir)
        puts "Temporarily set ProcessCategoryService output to: #{custom_output_dir}"

        awesome_list_service = ProcessAwesomeListService.new(repo_identifier:)
        result = awesome_list_service.call

        if result.success?
          say("Successfully processed repository '#{repo_identifier}'. Output files:", :green)
          result.value!.each { |file_path| puts "- #{file_path}" }
        else
          say("ERROR: Failed to process repository '#{repo_identifier}': #{result.failure}", :red)
        end

      rescue StandardError => e
        say("ERROR: An unexpected error occurred: #{e.message}\n#{e.backtrace.first(5).join("\n")}", :red)
      ensure
        ProcessCategoryService.const_set(:TARGET_DIR, original_process_category_target_dir)
        puts "Restored original TARGET_DIR for ProcessCategoryService."
      end

      puts "Repository processing finished."
    end

    desc "process_snippet", "Processes awesome_self_hosted_snippet.md (via process_repo polycarbohydrate/awesome-tor) and saves output to tmp/md/"
    def process_snippet
      # This now calls the main command with a default repo that contains similar content
      # or a repo that serves as a test case for awesome_self_hosted_snippet content.
      # Replace 'polycarbohydrate/awesome-tor' with an actual repo name or URL if needed for this snippet.
      # Or, this command could be removed if direct repo processing is the only goal now.
      # For this example, let's assume we have a test repo for the snippet, or use the actual snippet location for parsing if needed.
      # For now, it uses the fixture's content by calling the process_repo command with a placeholder repo.
      # This is not ideal as process_repo now expects to fetch.
      # A better way would be for process_repo to optionally accept local file path.
      # Given the change, process_snippet is now less direct.
      # I'll make it call process_repo with the hardcoded snippet's equivalent repo identifier for demonstration.
      # This is a simplification; a real CLI might have different commands for local files vs. remote repos.
      say("Process_snippet command is now a shortcut to process a predefined repo for testing.", :yellow)
      invoke(:process_repo, [ "octokit/octokit.rb" ], output_dir: "tmp/md_snippet_test") # Example repo
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
