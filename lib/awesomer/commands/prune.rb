# frozen_string_literal: true

require 'thor'

module Awesomer
  module Commands
    class Prune < Thor
      include Thor::Actions

      class_option :since,
                   default: 365,
                   desc: 'Number of days since last update (default: 365)',
                   type: :numeric

      class_option :dry_run,
                   default: false,
                   desc: 'Show what would be deleted without making changes',
                   type: :boolean

      class_option :force,
                   default: false,
                   desc: 'Skip confirmation prompt',
                   type: :boolean

      default_task :execute

      desc 'execute', 'Delete stale, empty, and orphaned awesome lists'
      def execute
        check_environment
        display_configuration

        @validator = ListValidationService.new(stale_days: options[:since])

        find_invalid_lists
        confirm_action unless options[:force]
        delete_invalid_lists
        cleanup_markdown_files
        display_summary
      end

      private

      def check_environment
        require File.expand_path('../../../config/environment', __dir__.dup)
        say '🔍 Initializing Rails environment...', :green
      end

      def display_configuration
        days = options[:since]
        cutoff_date = days.days.ago

        say "\n📋 Prune Configuration:", :cyan
        say "  Days since last update: #{days}"
        say "  Cutoff date: #{cutoff_date.strftime('%Y-%m-%d')}"
        say "  Dry run: #{options[:dry_run] ? 'Yes' : 'No'}"
        say ''
      end

      def find_invalid_lists
        @stale_lists = []
        @empty_lists = []
        @orphaned_lists = []

        AwesomeList.find_each do |list|
          if @validator.stale?(list)
            @stale_lists << list
          elsif !@validator.has_github_repos?(list)
            @empty_lists << list
          elsif !@validator.referenced_in_awesome_list?(list)
            @orphaned_lists << list
          end
        end

        @total_to_delete = @stale_lists.size + @empty_lists.size + @orphaned_lists.size

        if @total_to_delete.zero?
          say '✅ No invalid lists found', :green
        else
          if @stale_lists.any?
            say "\n📦 Found #{@stale_lists.size} stale lists (older than #{options[:since]} days):", :yellow
            @stale_lists.first(5).each do |list|
              days_old = ((Time.current - list.updated_at) / 1.day).round
              say "  • #{list.github_repo} (#{days_old} days old)"
            end
            say "  ... and #{@stale_lists.size - 5} more" if @stale_lists.size > 5
          end

          if @empty_lists.any?
            say "\n📦 Found #{@empty_lists.size} lists without GitHub repos:", :yellow
            @empty_lists.first(5).each do |list|
              say "  • #{list.github_repo}"
            end
            say "  ... and #{@empty_lists.size - 5} more" if @empty_lists.size > 5
          end

          if @orphaned_lists.any?
            say "\n📦 Found #{@orphaned_lists.size} orphaned lists (not referenced in any awesome list):", :yellow
            @orphaned_lists.first(5).each do |list|
              say "  • #{list.github_repo}"
            end
            say "  ... and #{@orphaned_lists.size - 5} more" if @orphaned_lists.size > 5
          end
        end
      end

      def confirm_action
        return if options[:dry_run]
        return if @total_to_delete.zero?

        say "\n⚠️  Warning: This action will permanently delete data!", :red

        say 'Lists to be deleted:'
        say "  • #{@stale_lists.size} stale lists" if @stale_lists.any?
        say "  • #{@empty_lists.size} empty lists" if @empty_lists.any?
        say "  • #{@orphaned_lists.size} orphaned lists" if @orphaned_lists.any?
        say "  Total: #{@total_to_delete} lists"

        return if yes?("\nDo you want to proceed? (y/N)", :yellow)

        say 'Operation cancelled', :red
        exit 1
      end

      def delete_invalid_lists
        return if @total_to_delete.zero?

        if options[:dry_run]
          say "\n🔍 Dry run: Would delete #{@total_to_delete} lists", :cyan
        else
          say "\n🗑️  Deleting invalid lists...", :yellow

          deleted = 0

          (@stale_lists + @empty_lists + @orphaned_lists).each do |list|
            delete_list_and_file(list)
            deleted += 1
            print '.' if (deleted % 10).zero?
          end

          say "\n✅ Deleted #{deleted} lists", :green
        end
      end

      def delete_list_and_file(list)
        # Delete markdown file
        filename = "#{list.github_repo.split('/').last}.md"
        file_path = Rails.root.join('static', 'awesomer', filename)

        if File.exist?(file_path)
          File.delete(file_path) unless options[:dry_run]
        end

        # Delete database records
        return if options[:dry_run]

        list.categories.destroy_all
        list.destroy
      end

      def cleanup_markdown_files
        say "\n🧹 Cleaning up orphaned markdown files...", :cyan

        # Get all markdown files
        markdown_files = Dir.glob(Rails.root.join('static', 'awesomer', '*.md'))
        markdown_files.reject! { |f| File.basename(f) == 'README.md' }

        # Get all active list filenames
        active_filenames = AwesomeList.pluck(:github_repo).map do |repo|
          "#{repo.split('/').last}.md"
        end

        # Find orphaned files
        orphaned_files = markdown_files.reject do |file|
          active_filenames.include?(File.basename(file))
        end

        if orphaned_files.any?
          say "  Found #{orphaned_files.size} orphaned markdown files", :yellow

          unless options[:dry_run]
            orphaned_files.each do |file|
              File.delete(file)
              say "  ✗ Deleted #{File.basename(file)}", :red
            end
          end
        else
          say '  No orphaned markdown files found', :green
        end
      end

      def display_summary
        say "\n📊 Summary:", :cyan

        say '  Dry run completed - no changes made' if options[:dry_run]

        active_count = AwesomeList.count
        say "  Remaining lists: #{active_count}"

        # Count markdown files
        markdown_files = Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).size - 1 # Exclude README
        say "  Markdown files: #{markdown_files}"
      end
    end
  end
end
