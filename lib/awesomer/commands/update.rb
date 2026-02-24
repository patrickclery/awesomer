# frozen_string_literal: true

require 'thor'

module Awesomer
  module Commands
    class Update < Thor::Group
      def self.source_root
        File.dirname(__FILE__)
      end

      def self.banner
        'awesomer update'
      end

      desc 'Update all awesome lists with GitHub stats and clean up'

      class_option :force,
                   default: false,
                   desc: 'Force update all lists even if recently synced',
                   type: :boolean

      class_option :limit,
                   desc: 'Limit number of lists to process',
                   type: :numeric

      def execute
        say '🚀 Starting comprehensive update...', :cyan
        say 'Proper sequence: Sync → Prune → Generate Markdown', :yellow

        # Step 1: Sync GitHub stats for all items
        sync_github_stats

        # Step 2: Run pruning to remove invalid lists
        run_pruning

        # Step 3: Clean up archived lists
        cleanup_archived_lists

        # Step 4: Regenerate all markdown files
        regenerate_markdown_files

        # Step 5: Clean up empty files
        cleanup_empty_files

        # Step 6: Show summary
        show_summary
      end

      private

      def sync_github_stats
        say "\n⭐ Syncing GitHub stats...", :cyan

        client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
        rate_limiter = GithubRateLimiterService.new

        # Get items that need syncing
        items_needing_sync = CategoryItem
          .where(stars: nil)
          .where.not(github_repo: [nil, ''])

        items_needing_sync = items_needing_sync.limit(options[:limit]) if options[:limit]

        total = items_needing_sync.count

        if total == 0
          say '  All items already have stars!', :green
          return
        end

        say "  Found #{total} items needing stars", :yellow

        updated = 0
        failed = 0

        items_needing_sync.find_each do |item|
          rate_limiter.check_and_wait!

          begin
            repo_data = client.repository(item.github_repo)

            item.update!(
              last_commit_at: repo_data.pushed_at,
              stars: repo_data.stargazers_count
            )

            updated += 1
            print '.' if updated % 10 == 0
          rescue Octokit::NotFound
            item.update!(stars: 0) # Mark as checked
            failed += 1
            print 'x'
          rescue Octokit::TooManyRequests => e
            say "\n  Rate limit hit! Waiting...", :yellow
            sleep_time = e.response_headers['x-ratelimit-reset'].to_i - Time.now.to_i + 1
            sleep_time = [sleep_time, 3600].min
            say "  Sleeping for #{sleep_time} seconds...", :yellow
            sleep(sleep_time)
            retry
          rescue StandardError => e
            say "\n  Error: #{e.message}", :red
            failed += 1
          end
        end

        say "\n  ✅ Updated #{updated} items with stars", :green
        say "  ❌ Failed: #{failed} items", :red if failed > 0
      end

      def run_pruning
        say "\n🗑️  Running pruning to remove invalid lists...", :cyan

        # Run the prune command
        validator = ListValidationService.new(stale_days: 365)
        result = validator.prune!(dry_run: false)

        if result.success?
          stats = result.value!
          say "  ✅ Pruned #{stats[:total_deleted]} invalid lists", :green
          say "    Stale: #{stats[:stale].size}", :yellow if stats[:stale].any?
          say "    No repos: #{stats[:no_repos].size}", :yellow if stats[:no_repos].any?
          say "    Orphaned: #{stats[:orphaned].size}", :yellow if stats[:orphaned].any?
        else
          say "  ❌ Pruning failed: #{result.failure}", :red
        end
      end

      def cleanup_archived_lists
        say "\n🗑️  Cleaning up archived lists...", :cyan

        archived = AwesomeList.where(archived: true)
        archived_count = archived.count

        if archived_count > 0
          say "  Found #{archived_count} archived lists", :yellow

          archived.each do |list|
            filename = "#{list.github_repo.split('/').last}.md"
            file_path = Rails.root.join('static', 'awesomer', filename)

            if File.exist?(file_path)
              File.delete(file_path)
              say "  ✗ Deleted #{filename}", :red
            end
          end
        else
          say '  No archived lists found', :green
        end
      end

      def regenerate_markdown_files
        say "\n📝 Regenerating markdown files...", :cyan

        service = ProcessCategoryServiceEnhanced.new
        count = 0
        deleted = 0

        lists = AwesomeList.active.completed
        lists = lists.limit(options[:limit]) if options[:limit]

        lists.find_each do |list|
          result = service.call(awesome_list: list)

          if result.success?
            if result.value! == :deleted
              deleted += 1
              print 'x'
            else
              count += 1
              print '.'
            end
          else
            print '!'
          end
        end

        say "\n  ✅ Regenerated #{count} files", :green
        say "  🗑️  Deleted #{deleted} empty files", :yellow if deleted > 0
      end

      def cleanup_empty_files
        say "\n🧹 Cleaning up empty files...", :cyan

        # Get active list filenames - never delete these
        active_filenames = AwesomeList.active.pluck(:github_repo).map do |repo|
          "#{repo.split('/').last}.md"
        end

        small_files = Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).select do |f|
          basename = File.basename(f)
          basename != 'README.md' && !active_filenames.include?(basename) && File.size(f) < 200
        end

        if small_files.any?
          say "  Found #{small_files.count} small/empty files (excluding active lists)", :yellow

          small_files.each do |file|
            File.delete(file)
            say "  ✗ Deleted #{File.basename(file)}", :red
          end
        else
          say '  No empty files found', :green
        end
      end

      def show_summary
        say "\n#{'=' * 50}", :green
        say '✅ Update complete!', :green
        say '=' * 50, :green

        # Statistics
        total_lists = AwesomeList.active.count
        completed = AwesomeList.active.completed.count
        items_with_stars = CategoryItem.where.not(stars: nil).count
        total_items = CategoryItem.where.not(github_repo: [nil, '']).count
        files = Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).count - 1

        say "\n📊 Statistics:"
        say '  Awesome Lists:'
        say "    • Total: #{total_lists}"
        say "    • Completed: #{completed}"
        say '  Items:'
        say "    • Total with GitHub: #{total_items}"
        say "    • With stars: #{items_with_stars}"
        say "    • Coverage: #{(items_with_stars.to_f / total_items * 100).round(1)}%"
        say '  Files:'
        say "    • Markdown files: #{files}"
      end
    end
  end
end
