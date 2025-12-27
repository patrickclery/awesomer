# frozen_string_literal: true

require 'thor'

module Awesomer
  module Commands
    class Sync < Thor::Group
      def self.source_root
        File.dirname(__FILE__)
      end

      def self.banner
        'awesomer sync'
      end

      desc 'Complete sync with automatic sequence: sync → prune → generate markdown'

      class_option :monitor,
                   default: true,
                   desc: 'Show progress monitoring',
                   type: :boolean

      class_option :max_iterations,
                   default: 100,
                   desc: 'Maximum monitoring iterations',
                   type: :numeric

      class_option :async,
                   default: true,
                   desc: 'Run sync process asynchronously (false for synchronous)',
                   type: :boolean

      class_option :star_history,
                   default: true,
                   desc: 'Fetch star history (trending data) after sync',
                   type: :boolean

      def execute
        say '🚀 Starting Complete Sync Process', :cyan
        sequence = options[:star_history] ? 'Sync → Star History → Prune → Generate Markdown' : 'Sync → Prune → Generate Markdown'
        say "Sequence: #{sequence}", :yellow
        say "Mode: #{options[:async] ? 'Asynchronous' : 'Synchronous'}", :yellow
        say '=' * 70, :green

        @iteration = 0
        @max_iterations = options[:max_iterations]
        @start_time = Time.current
        @last_synced_count = 0
        @stall_counter = 0

        if options[:async]
          # Start the sync process in background
          start_sync_process

          # Monitor loop - continues until sync is complete
          loop do
            @iteration += 1

            if @iteration > @max_iterations
              say "\n❌ Maximum iterations (#{@max_iterations}) reached", :red
              break
            end

            say "\n🔄 Monitoring Loop - Iteration #{@iteration}/#{@max_iterations}", :cyan
            say '━' * 50, :cyan

            status = check_sync_status

            case status[:state]
            when :complete
              say "\n✅ Sync complete! All #{status[:total]} items have stars.", :green

              # Queue star history jobs if enabled
              if options[:star_history]
                say "\n📈 Queueing star history jobs for trending data...", :cyan
                queue_star_history_jobs
              end

              # Automatically run pruning
              say "\n🗑️  Running pruning phase...", :cyan
              run_pruning

              # Delete old markdown files
              say "\n🗑️  Deleting old markdown files...", :cyan
              delete_old_markdown

              # Generate fresh markdown
              say "\n📝 Generating fresh markdown files...", :cyan
              generate_markdown

              say "\n🎉 Complete sync process finished successfully!", :green
              break

            when :stalled
              say "\n⚠️  Sync appears stalled! Restarting...", :yellow
              restart_sync_process
              @stall_counter = 0

            when :running
              show_progress(status)
            end

            # Determine wait time based on progress
            wait_time = determine_wait_time(status[:percentage])

            # Show countdown timer
            if options[:monitor]
              show_countdown(wait_time)
            else
              sleep(wait_time)
            end
          end
        else
          # Synchronous processing
          say "\n📊 Running synchronous sync process...", :cyan

          # Step 1: Sync GitHub stats
          sync_github_stats_synchronously

          # Step 2: Queue star history jobs if enabled
          if options[:star_history]
            say "\n📈 Queueing star history jobs for trending data...", :cyan
            queue_star_history_jobs
          end

          # Step 3: Run pruning
          say "\n🗑️  Running pruning phase...", :cyan
          run_pruning

          # Step 3: Delete old markdown files
          say "\n🗑️  Deleting old markdown files...", :cyan
          delete_old_markdown

          # Step 4: Generate fresh markdown
          say "\n📝 Generating fresh markdown files...", :cyan
          generate_markdown

          say "\n🎉 Complete sync process finished successfully!", :green
        end

        show_final_summary
      end

      private

      def start_sync_process
        say "\n📊 Starting GitHub stats sync process...", :cyan

        # Kill any existing sync processes
        system("pkill -f 'sync:stars' 2>/dev/null")

        # Start new sync process in background
        sync_pid = spawn(
          'bundle exec rake sync:stars',
          err: Rails.root.join('log', 'sync_errors.log').to_s,
          out: Rails.root.join('log', 'sync.log').to_s
        )

        ::Process.detach(sync_pid)

        say "  Started sync process (PID: #{sync_pid})", :green

        # Give it time to start
        sleep(5)
      end

      def check_sync_status
        items_with_stars = CategoryItem.where.not(stars: nil).count
        items_without_stars = CategoryItem.where(stars: nil).where.not(github_repo: [nil, '']).count
        total = items_with_stars + items_without_stars

        percentage = total > 0 ? (items_with_stars.to_f / total * 100).round(2) : 0

        # Check for stalls
        stalled = false
        if items_with_stars == @last_synced_count
          @stall_counter += 1
          stalled = @stall_counter >= 3 # Stalled if no progress for 3 checks
        else
          @stall_counter = 0
        end

        @last_synced_count = items_with_stars

        state = if items_without_stars == 0 && total > 0
                  :complete
                elsif stalled
                  :stalled
                else
                  :running
                end

        {
          percentage:,
          remaining: items_without_stars,
          stalled:,
          state:,
          synced: items_with_stars,
          total:
        }
      end

      def queue_star_history_jobs
        operation = QueueStarHistoryJobsOperation.new
        total_queued = 0

        AwesomeList.active.find_each do |list|
          result = operation.call(awesome_list: list)
          if result.success?
            queued = result.value![:queued]
            total_queued += queued
            print '.' if queued > 0
          else
            print 'x'
          end
        end

        puts # New line after progress dots
        say "  ✅ Queued #{total_queued} star history jobs", :green
        say '  ℹ️  Jobs will run in background via Solid Queue', :cyan
        say '  ℹ️  Use `bin/jobs` to process the queue', :cyan
      end

      def run_pruning
        validator = ListValidationService.new(stale_days: 365)
        result = validator.prune!(dry_run: false)

        if result.success?
          stats = result.value!
          say "  ✅ Pruned #{stats[:total_deleted]} invalid lists", :green
          say "     Stale: #{stats[:stale].size}" if stats[:stale].any?
          say "     No repos: #{stats[:no_repos].size}" if stats[:no_repos].any?
          say "     Orphaned: #{stats[:orphaned].size}" if stats[:orphaned].any?
        else
          say "  ❌ Pruning failed: #{result.failure}", :red
        end
      end

      def delete_old_markdown
        markdown_dir = Rails.root.join('static', 'awesomer')
        existing_files = Dir.glob(File.join(markdown_dir, '*.md'))
                           .reject { |f| File.basename(f) == 'README.md' }

        existing_files.each { |f| File.delete(f) }

        say "  ✅ Deleted #{existing_files.count} old markdown files", :green
      end

      def generate_markdown
        service = ProcessCategoryServiceEnhanced.new
        success_count = 0
        failed_count = 0

        AwesomeList.active.find_each do |list|
          result = service.call(awesome_list: list)
          if result.success?
            if result.value! != :deleted
              success_count += 1
              print '.'
            end
          else
            failed_count += 1
            print 'x'
          end
        end

        puts # New line after progress dots
        say "  ✅ Generated #{success_count} markdown files", :green
        say "  ❌ Failed: #{failed_count}", :red if failed_count > 0
      end

      def restart_sync_process
        say '  Killing stalled sync process...', :yellow
        system("pkill -f 'sync:stars' 2>/dev/null")

        say '  Starting fresh sync process...', :yellow
        start_sync_process
      end

      def show_progress(status)
        say "  📊 Sync Progress: #{status[:synced]}/#{status[:total]} (#{status[:percentage]}%)", :cyan

        # Calculate time elapsed and ETA
        elapsed = Time.current - @start_time
        say "  ⏱️  Time elapsed: #{format_duration(elapsed)}", :cyan

        if status[:synced] > 0 && status[:remaining] > 0
          rate = status[:synced].to_f / elapsed
          eta = status[:remaining] / rate
          say "  🔮 Estimated completion: #{format_duration(eta)}", :cyan
        end

        # Show current sync activity
        return unless File.exist?(Rails.root.join('log', 'sync.log'))

        last_lines = `tail -n 5 #{Rails.root.join('log', 'sync.log')} 2>/dev/null`.strip
        return unless last_lines.present?

        say "\n  📋 Recent activity:", :cyan
        last_lines.lines.last(3).each do |line|
          say "    #{line.strip}", :white
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

      def determine_wait_time(percentage)
        if percentage >= 95
          120  # 2 minutes when almost done
        elsif @stall_counter > 0
          60   # 1 minute when potentially stalled
        else
          600  # 10 minutes normal operation
        end
      end

      def show_countdown(seconds)
        say "\n⏱️  Waiting before next check...", :cyan

        seconds.downto(1) do |remaining|
          minutes = remaining / 60
          secs = remaining % 60

          if minutes > 0
            print "\r⏳ Next check in: #{format('%02d:%02d', minutes, secs)}"
          else
            print "\r⏳ Next check in: #{format('%02d', secs)} seconds"
          end

          sleep(1)
        end

        print "\r✅ Checking status...                           \n"
      end

      def sync_github_stats_synchronously
        client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
        rate_limiter = GithubRateLimiterService.new

        # Get all items that need stars
        items_without_stars = CategoryItem
          .where(stars: nil)
          .where.not(github_repo: [nil, ''])

        total = items_without_stars.count

        if total == 0
          say '  All items already have stars!', :green
          return
        end

        say "  Found #{total} items without stars", :yellow

        updated = 0
        failed = 0
        batch_size = 100

        # Monitor progress with timer
        last_update_time = Time.current
        monitoring_interval = 60 # Check every minute

        items_without_stars.find_in_batches(batch_size:).with_index do |batch, batch_index|
          say "\n  Processing batch #{batch_index + 1} (#{batch.size} items)...", :cyan

          batch.each_with_index do |item, _index|
            # Check if we should show monitoring update
            if Time.current - last_update_time >= monitoring_interval
              remaining = total - updated - failed
              percentage = ((updated + failed).to_f / total * 100).round(2)
              say "\n  📊 Progress check: #{updated + failed}/#{total} (#{percentage}%), #{remaining} remaining", :yellow

              if updated > 0
                elapsed = Time.current - @start_time
                rate = updated.to_f / elapsed
                eta = remaining / rate
                say "  ⏱️  ETA: #{format_duration(eta)}", :yellow
              end

              last_update_time = Time.current
            end

            # Rate limiting check
            begin
              rate_limiter.check_and_wait!
            rescue StandardError
              say "\n  ⚠️  Rate limit reached, waiting...", :yellow
              sleep_time = 60
              say "  Sleeping for #{sleep_time} seconds...", :yellow
              sleep(sleep_time)
              retry
            end

            begin
              repo_data = client.repository(item.github_repo)

              item.update!(
                last_commit_at: repo_data.pushed_at,
                stars: repo_data.stargazers_count
              )

              updated += 1

              # Progress indicator
              print '.' if updated % 10 == 0

              say "\n  Progress: #{updated}/#{total} items updated", :green if updated % 100 == 0
            rescue Octokit::NotFound
              # Repository doesn't exist or is private
              item.update!(stars: 0) # Mark as checked with 0 stars
              failed += 1
              print 'x'
            rescue Octokit::TooManyRequests => e
              say "\n  Rate limit hit! Waiting...", :yellow
              sleep_time = e.response_headers['x-ratelimit-reset'].to_i - Time.now.to_i + 1
              sleep_time = [sleep_time, 3600].min # Max 1 hour
              say "  Sleeping for #{sleep_time} seconds (until #{Time.at(e.response_headers['x-ratelimit-reset'].to_i)})",
                  :yellow

              # Show countdown for rate limit wait
              sleep_time.downto(1) do |remaining|
                if remaining % 60 == 0
                  minutes = remaining / 60
                  print "\r  ⏳ Rate limit wait: #{minutes} minutes remaining...     "
                end
                sleep(1)
              end
              print "\r  ✅ Resuming...                                          \n"
              retry
            rescue StandardError => e
              say "\n  Error with #{item.github_repo}: #{e.message}", :red
              failed += 1
            end
          end

          say "\n  Batch #{batch_index + 1} complete: #{updated} updated, #{failed} failed so far", :cyan
        end

        say "\n  ✅ Sync complete!", :green
        say "    Updated: #{updated} items", :green
        say "    Failed: #{failed} items", :red if failed > 0
        say "    Total: #{total} items", :cyan
      end

      def show_final_summary
        say "\n#{'=' * 70}", :green
        say '📊 Final Summary', :green
        say '=' * 70, :green

        total_lists = AwesomeList.active.count
        completed = AwesomeList.active.completed.count
        items_with_stars = CategoryItem.where.not(stars: nil).count
        total_items = CategoryItem.where.not(github_repo: [nil, '']).count
        files = Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).count - 1

        say "\n  Awesome Lists:"
        say "    • Total: #{total_lists}"
        say "    • Completed: #{completed}"
        items_with_star_history = CategoryItem.where.not(star_history_fetched_at: nil).count

        say "\n  Items:"
        say "    • Total with GitHub: #{total_items}"
        say "    • With stars: #{items_with_stars}"
        say "    • Coverage: #{(items_with_stars.to_f / total_items * 100).round(1)}%"
        say "    • With star history: #{items_with_star_history}" if items_with_star_history > 0
        say "\n  Files:"
        say "    • Markdown files: #{files}"

        elapsed = Time.current - @start_time
        say "\n  ⏱️  Total time: #{format_duration(elapsed)}"
        say "  🔄 Iterations: #{@iteration}"
      end
    end
  end
end
