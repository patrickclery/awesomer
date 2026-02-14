# frozen_string_literal: true

require 'thor'

module Awesomer
  module Commands
    # Full refresh command that syncs stats and reprocesses all awesome lists
    class Refresh < Thor::Group
      def self.source_root
        File.dirname(__FILE__)
      end

      def self.banner
        'awesomer refresh'
      end

      desc 'Full refresh: sync stats, reprocess lists, fetch star history, generate markdown'

      class_option :async,
                   default: true,
                   desc: 'Run asynchronously using background jobs',
                   type: :boolean

      class_option :star_history,
                   default: true,
                   desc: 'Fetch star history (trending data)',
                   type: :boolean

      class_option :prune,
                   default: true,
                   desc: 'Run pruning to remove invalid lists',
                   type: :boolean

      class_option :limit,
                   default: nil,
                   desc: 'Limit number of lists to process',
                   type: :numeric

      class_option :threshold,
                   default: nil,
                   desc: 'Minimum stars for repos to appear in markdown (default: per-list setting, usually 10)',
                   type: :numeric

      class_option :markdown_only,
                   default: false,
                   desc: 'Only regenerate markdown files (skip fetching, syncing, pruning)',
                   type: :boolean

      def execute
        @start_time = Time.current
        @stats = {items_synced: 0, lists_failed: 0, lists_processed: 0, repos_snapshotted: 0, star_history_queued: 0}

        if options[:markdown_only]
          say '📝 Markdown-only mode: regenerating markdown from DB', :cyan
          say '=' * 70, :green
          say "\n  Computing trending from snapshots...", :cyan
          compute_trending
          generate_markdown
          show_final_summary
          return
        end

        say '🔄 Starting Full Refresh', :cyan
        say "Mode: #{options[:async] ? 'Asynchronous (background jobs)' : 'Synchronous (inline)'}", :yellow
        say '=' * 70, :green

        if options[:async]
          run_async_refresh
        else
          run_sync_refresh
        end

        show_final_summary
      end

      private

      def run_async_refresh
        say "\n📋 Queueing refresh jobs...", :cyan

        lists = fetch_lists_to_process.to_a
        say "  Found #{lists.size} awesome lists to process", :green

        # Queue ProcessAwesomeListJob for each list
        lists.each do |list|
          queue_process_job(list)
          @stats[:lists_processed] += 1
          print '.'
        end

        puts
        say "  ✅ Queued #{@stats[:lists_processed]} processing jobs", :green

        # Queue star history jobs if enabled
        if options[:star_history]
          say "\n📈 Queueing star history jobs...", :cyan
          queue_all_star_history_jobs
        end

        if options[:threshold]
          say "  Using star threshold: #{options[:threshold]} (overriding per-list defaults)", :yellow
          say '  Note: --threshold is applied during markdown generation (step 5).', :yellow
          say '  In async mode, run a sync refresh after jobs complete to apply: ' \
              "awesomer refresh --no-async --threshold=#{options[:threshold]}", :yellow
        end

        say "\n💡 Jobs are queued. Run `bin/jobs` to process them.", :yellow
        say '   Monitor progress with `bin/awesomer status`', :yellow
      end

      def run_sync_refresh
        say "\n📊 Running synchronous refresh...", :cyan

        # Step 1: Process each awesome list (fetch README, parse, persist)
        say "\n1️⃣  Processing awesome lists...", :cyan
        process_all_lists

        # Step 2: Snapshot stars via GraphQL (fast batch fetch)
        say "\n2️⃣  Snapshotting stars via GraphQL...", :cyan
        snapshot_stars

        # Step 2b: Compute trending from snapshots
        say "\n  Computing trending from snapshots...", :cyan
        compute_trending

        # Step 3: Sync GitHub stats for items without stars
        say "\n3️⃣  Syncing GitHub stats...", :cyan
        sync_github_stats

        # Step 4: Queue star history jobs if enabled
        if options[:star_history]
          say "\n4️⃣  Queueing star history jobs...", :cyan
          queue_all_star_history_jobs
        end

        # Step 5: Prune invalid lists if enabled
        if options[:prune]
          say "\n5️⃣  Pruning invalid lists...", :cyan
          run_pruning
        end

        # Step 6: Generate markdown files
        say "\n6️⃣  Generating markdown files...", :cyan
        generate_markdown
      end

      def fetch_lists_to_process
        lists = AwesomeList.active
        limit_value = options[:limit]
        lists = lists.limit(limit_value) if limit_value.present? && limit_value.positive?
        lists
      end

      def queue_process_job(list)
        # Use ProcessMarkdownWithStatsJob if available, otherwise create inline
        if defined?(ProcessMarkdownWithStatsJob)
          ProcessMarkdownWithStatsJob.perform_later(
            repo_identifier: list.github_repo,
            sync: false,
            fetch_star_history: options[:star_history]
          )
        else
          # Fallback: queue a generic job or process inline
          ProcessAwesomeListService.new(
            repo_identifier: list.github_repo,
            sync: false,
            fetch_star_history: options[:star_history]
          ).call
        end
      end

      def snapshot_stars
        operation = SnapshotStarsOperation.new
        result = operation.call

        if result.success?
          say "  ✅ #{result.value!}", :green
          # Extract count from message like "Snapshotted 4755 repos, skipped 8053"
          if result.value! =~ /Snapshotted (\d+)/
            @stats[:repos_snapshotted] = $1.to_i
          end
        else
          say "  ❌ Snapshot failed: #{result.failure}", :red
        end
      end

      def compute_trending
        operation = ComputeTrendingOperation.new
        result = operation.call

        if result.success?
          say "  ✅ #{result.value!}", :green
        else
          say "  ❌ #{result.failure}", :red
        end
      end

      def sync_github_stats
        client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
        client.auto_paginate = false # Avoid memory issues
        rate_limiter = GithubRateLimiterService.new

        # Sync all items from active (non-archived) lists
        active_list_ids = fetch_lists_to_process.pluck(:id)
        items = CategoryItem
          .joins(:category)
          .where(categories: { awesome_list_id: active_list_ids })
          .where.not(github_repo: [nil, ''])
        total = items.count

        if total == 0
          say '  No items to sync', :green
          return
        end

        say "  Found #{total} items to sync", :yellow
        $stdout.flush

        updated = 0
        failed = 0

        items.find_in_batches(batch_size: 100) do |batch|
          batch.each do |item|
            rate_limiter.wait_if_needed

            begin
              repo_data = client.repository(item.github_repo)

              # Handle renamed repos - stargazers_count may be nil if redirect wasn't followed
              if repo_data.stargazers_count.nil?
                # Try to get the actual repo via the id
                if repo_data.id
                  repo_data = client.get("/repositories/#{repo_data.id}")
                  # Update the github_repo to the new name if it changed
                  if repo_data.full_name && repo_data.full_name != item.github_repo
                    item.github_repo = repo_data.full_name
                  end
                end
              end

              stars = repo_data.stargazers_count || 0
              item.update!(
                github_description: repo_data.description,
                last_commit_at: repo_data.pushed_at,
                stars: stars
              )
              updated += 1
              if updated % 10 == 0
                print '.'
                $stdout.flush
              end
            rescue Octokit::NotFound
              item.update!(stars: 0)
              failed += 1
            rescue Octokit::TooManyRequests => e
              say "\n  ⚠️ Rate limited, waiting...", :yellow
              sleep_time = [e.response_headers['x-ratelimit-reset'].to_i - Time.now.to_i + 1, 60].max
              sleep([sleep_time, 3600].min)
              retry
            rescue StandardError => e
              say "\n  Error syncing #{item.github_repo}: #{e.message}", :red
              failed += 1
            end
          end
        end

        puts
        @stats[:items_synced] = updated
        say "  ✅ Synced #{updated} items (#{failed} failed)", :green
      end

      def process_all_lists
        lists = fetch_lists_to_process
        total = lists.count

        say "  Processing #{total} lists...", :yellow

        lists.each_with_index do |list, index|
          begin
            say "  [#{index + 1}/#{total}] Processing #{list.github_repo}...", :cyan
            $stdout.flush

            service = ProcessAwesomeListService.new(
              repo_identifier: list.github_repo,
              sync: false, # Don't sync GitHub stats inline - too slow
              fetch_star_history: false, # We'll do this separately
              skip_markdown: true # Refresh command generates markdown in step 5 after stats are synced
            )
            result = service.call

            if result.success?
              @stats[:lists_processed] += 1
              say "    ✅ Done", :green
            else
              @stats[:lists_failed] += 1
              say "    ❌ Failed: #{result.failure}", :red
            end
            $stdout.flush
          rescue StandardError => e
            @stats[:lists_failed] += 1
            say "\n  Error processing #{list.github_repo}: #{e.message}", :red
          end
        end

        puts
        say "  ✅ Processed #{@stats[:lists_processed]} lists (#{@stats[:lists_failed]} failed)", :green
      end

      def queue_all_star_history_jobs
        operation = QueueStarHistoryJobsOperation.new
        total_queued = 0

        lists = fetch_lists_to_process
        lists.each do |list|
          result = operation.call(awesome_list: list)
          if result.success?
            queued = result.value![:queued]
            total_queued += queued
            print '.' if queued > 0
          end
        end

        puts
        @stats[:star_history_queued] = total_queued
        say "  ✅ Queued #{total_queued} star history jobs", :green
      end

      def run_pruning
        validator = ListValidationService.new(stale_days: 365)
        result = validator.prune!(dry_run: false)

        if result.success?
          stats = result.value!
          say "  ✅ Pruned #{stats[:total_deleted]} invalid lists", :green
        else
          say "  ❌ Pruning failed: #{result.failure}", :red
        end
      end

      def generate_markdown
        service = ProcessCategoryServiceEnhanced.new
        success_count = 0
        failed_count = 0
        failed_lists = []

        threshold = options[:threshold]
        AwesomeList.active.find_each do |list|
          result = service.call(awesome_list: list, star_threshold: threshold)
          if result.success? && result.value! != :deleted
            success_count += 1
            print '.'
          else
            failed_count += 1 unless result.value! == :deleted
          end
        rescue ProcessCategoryServiceEnhanced::MissingStarsError => e
          failed_count += 1
          failed_lists << "#{list.github_repo}: #{e.message.split('.').first}"
          print 'X'
        rescue StandardError => e
          failed_count += 1
          failed_lists << "#{list.github_repo}: #{e.message}"
          print 'X'
        end

        puts
        say "  ✅ Generated #{success_count} markdown files", :green
        if failed_count > 0
          say "  ❌ Failed: #{failed_count}", :red
          failed_lists.each { |msg| say "    - #{msg}", :red }
        end
      end

      def show_final_summary
        elapsed = Time.current - @start_time

        say "\n#{'=' * 70}", :green
        say '📊 Refresh Summary', :green
        say '=' * 70, :green

        say "\n  Mode: #{options[:async] ? 'Asynchronous' : 'Synchronous'}"
        threshold_display = options[:threshold] || 'per-list default'
        say "  Threshold: #{threshold_display} stars minimum"

        if options[:async]
          say "\n  Jobs Queued:"
          say "    • Processing jobs: #{@stats[:lists_processed]}"
          say "    • Star history jobs: #{@stats[:star_history_queued]}" if options[:star_history]
        else
          say "\n  Results:"
          say "    • Lists processed: #{@stats[:lists_processed]}"
          say "    • Lists failed: #{@stats[:lists_failed]}" if @stats[:lists_failed] > 0
          say "    • Repos snapshotted: #{@stats[:repos_snapshotted]}" if @stats[:repos_snapshotted] > 0
          say "    • Items synced: #{@stats[:items_synced]}"
          say "    • Star history jobs queued: #{@stats[:star_history_queued]}" if options[:star_history]
        end

        # Current database stats
        items_with_stars = CategoryItem.where.not(stars: nil).count
        total_items = CategoryItem.where.not(github_repo: [nil, '']).count
        items_with_history = CategoryItem.where.not(star_history_fetched_at: nil).count

        say "\n  Database Status:"
        say "    • Active lists: #{AwesomeList.active.count}"
        say "    • Items with stars: #{items_with_stars}/#{total_items} (#{(items_with_stars.to_f / total_items * 100).round(1)}%)"
        say "    • Items with star history: #{items_with_history}" if items_with_history > 0

        say "\n  ⏱️  Total time: #{format_duration(elapsed)}"

        if options[:async]
          say "\n  💡 Run `bin/jobs` to process the queued jobs", :yellow
        end
      end

      def format_duration(seconds)
        return 'N/A' if seconds.nan? || seconds.infinite?

        hours = (seconds / 3600).to_i
        minutes = ((seconds % 3600) / 60).to_i

        if hours > 0
          "#{hours}h #{minutes}m"
        else
          "#{minutes}m"
        end
      end
    end
  end
end
