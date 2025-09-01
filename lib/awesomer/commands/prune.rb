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

      class_option :unarchive,
                   default: false,
                   desc: 'Also unarchive repositories updated after the deadline',
                   type: :boolean

      class_option :dry_run,
                   default: false,
                   desc: 'Show what would be archived/unarchived without making changes',
                   type: :boolean

      default_task :execute

      desc 'execute', 'Archive awesome lists that have not been updated within the specified timeframe'
      def execute
        check_environment
        display_configuration
        find_stale_repositories
        find_fresh_archived_repositories
        confirm_action
        archive_stale_repositories
        unarchive_fresh_repositories
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
        say "  Unarchive mode: #{options[:unarchive] ? 'Yes' : 'No'}"
        say "  Dry run: #{options[:dry_run] ? 'Yes' : 'No'}"
        say ''
      end

      def find_stale_repositories
        @stale_repos = AwesomeList.active.stale(options[:since])
        @stale_count = @stale_repos.count

        if @stale_count.zero?
          say "✅ No stale repositories found (older than #{options[:since]} days)", :green
        else
          say "📦 Found #{@stale_count} stale repositories to archive:", :yellow
          @stale_repos.limit(10).each do |repo|
            days_old = ((Time.current - repo.updated_at) / 1.day).round
            say "  • #{repo.github_repo} (#{days_old} days old)"
          end
          say "  ... and #{@stale_count - 10} more" if @stale_count > 10
        end
      end

      def find_fresh_archived_repositories
        return unless options[:unarchive]

        cutoff_date = options[:since].days.ago
        @fresh_repos = AwesomeList.archived.where(updated_at: cutoff_date..)
        @fresh_count = @fresh_repos.count

        if @fresh_count.zero?
          say '✅ No archived repositories to unarchive', :green
        else
          say "\n📦 Found #{@fresh_count} archived repositories to unarchive:", :yellow
          @fresh_repos.limit(10).each do |repo|
            days_old = ((Time.current - repo.updated_at) / 1.day).round
            say "  • #{repo.github_repo} (updated #{days_old} days ago)"
          end
          say "  ... and #{@fresh_count - 10} more" if @fresh_count > 10
        end
      end

      def confirm_action
        return if options[:dry_run]
        return unless @stale_count.positive? || @fresh_count&.positive?

        say "\n⚠️  Warning: This action will modify the database!", :red

        changes = []
        changes << "Archive #{@stale_count} repositories" if @stale_count.positive?
        changes << "Unarchive #{@fresh_count} repositories" if @fresh_count&.positive?

        say 'Changes to be made:'
        changes.each { |change| say "  • #{change}" }

        return if yes?("\nDo you want to proceed? (y/N)", :yellow)

        say 'Operation cancelled', :red
        exit 1
      end

      def archive_stale_repositories
        return if @stale_count.zero?

        if options[:dry_run]
          say "\n🔍 Dry run: Would archive #{@stale_count} repositories", :cyan
        else
          say "\n📦 Archiving stale repositories...", :yellow

          archived = 0
          @stale_repos.find_each do |repo|
            repo.archive!
            archived += 1
            print '.' if (archived % 10).zero?
          end

          say "\n✅ Archived #{archived} repositories", :green
        end
      end

      def unarchive_fresh_repositories
        return unless options[:unarchive]
        return if @fresh_count.zero?

        if options[:dry_run]
          say "\n🔍 Dry run: Would unarchive #{@fresh_count} repositories", :cyan
        else
          say "\n📦 Unarchiving fresh repositories...", :yellow

          unarchived = 0
          @fresh_repos.find_each do |repo|
            repo.unarchive!
            unarchived += 1
            print '.' if (unarchived % 10).zero?
          end

          say "\n✅ Unarchived #{unarchived} repositories", :green
        end
      end

      def display_summary
        say "\n📊 Summary:", :cyan

        active_count = AwesomeList.active.count
        archived_count = AwesomeList.archived.count
        total_count = AwesomeList.count

        say "  Total repositories: #{total_count}"
        say "  Active: #{active_count}"
        say "  Archived: #{archived_count}"

        return unless archived_count.positive?

        percentage = (archived_count.to_f / total_count * 100).round(1)
        say "  Archived percentage: #{percentage}%"
      end
    end
  end
end
