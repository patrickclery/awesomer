# frozen_string_literal: true

require "thor"

module Awesomer
  module Commands
    class Worker < Thor
      desc "start", "Start the sync worker daemon"
      method_option :daemonize, default: false, desc: "Run as daemon in background", type: :boolean
      method_option :pid_file, default: "tmp/pids/sync_worker.pid", desc: "PID file location", type: :string
      def start
        puts "🚀 Starting sync worker..."

        if options[:daemonize]
          start_daemon
        else
          start_foreground
        end
      end

      desc "stop", "Stop the sync worker daemon"
      method_option :pid_file, default: "tmp/pids/sync_worker.pid", desc: "PID file location", type: :string
      def stop
        pid_file = options[:pid_file]

        unless File.exist?(pid_file)
          puts "❌ Worker not running (PID file not found)"
          return
        end

        pid = File.read(pid_file).to_i

        begin
          Process.kill("TERM", pid)
          puts "✅ Stopped worker (PID: #{pid})"
          File.delete(pid_file)
        rescue Errno::ESRCH
          puts "⚠️  Worker not running (PID: #{pid} not found)"
          File.delete(pid_file)
        rescue => e
          puts "❌ Failed to stop worker: #{e.message}"
        end
      end

      desc "status", "Show worker status and last sync info"
      method_option :pid_file, default: "tmp/pids/sync_worker.pid", desc: "PID file location", type: :string
      def status
        pid_file = options[:pid_file]

        # Check if worker is running
        if File.exist?(pid_file)
          pid = File.read(pid_file).to_i
          begin
            Process.kill(0, pid)
            puts "✅ Worker is running (PID: #{pid})"
          rescue Errno::ESRCH
            puts "❌ Worker not running (stale PID file)"
            File.delete(pid_file)
          end
        else
          puts "❌ Worker not running"
        end

        puts

        # Show sync status from database
        unless defined?(AwesomeList) && defined?(SyncLog)
          puts "⚠️  Database models not loaded"
          return
        end

        # Last sync info
        last_sync = SyncLog.recent.first
        if last_sync
          puts "📊 Last Sync:"
          puts "  • Repository: #{last_sync.awesome_list.github_repo}"
          puts "  • Started: #{last_sync.started_at.strftime('%Y-%m-%d %H:%M:%S')}"
          puts "  • Status: #{last_sync.status}"
          puts "  • Items checked: #{last_sync.items_checked}"
          puts "  • Items updated: #{last_sync.items_updated}"
          puts "  • Duration: #{last_sync.duration&.round(2)} seconds" if last_sync.duration
        else
          puts "📊 No sync history found"
        end

        puts

        # Lists needing sync
        needs_sync_count = AwesomeList.completed.needs_sync.count
        puts "📝 Lists needing sync: #{needs_sync_count}"

        # Recent sync activity
        recent_syncs = SyncLog.where("started_at > ?", 24.hours.ago).count
        puts "📈 Syncs in last 24 hours: #{recent_syncs}"

        # Cron schedule info
        puts
        puts "⏰ Scheduled sync: Daily at 2:00 AM UTC"
        puts "   Run 'whenever' to see cron schedule"
      end

      desc "run-once", "Run a single sync cycle"
      method_option :force, default: false, desc: "Force sync even if recently synced", type: :boolean
      method_option :threshold, desc: "Override star delta threshold", type: :numeric
      def run_once
        puts "🔄 Running one-time sync..."

        unless defined?(SyncAwesomeListsJob)
          puts "❌ SyncAwesomeListsJob not loaded"
          return
        end

        # Override threshold if provided
        if options[:threshold]
          puts "📊 Using custom threshold: #{options[:threshold]} stars"
          AwesomeList.update_all(sync_threshold: options[:threshold])
        end

        begin
          job = SyncAwesomeListsJob.new
          job.perform(force: options[:force])
          puts "✅ Sync completed successfully"
        rescue => e
          puts "❌ Sync failed: #{e.message}"
          puts e.backtrace.first(5).join("\n") if ENV["DEBUG"]
        end
      end

      desc "logs", "View sync logs"
      method_option :tail, default: 20, desc: "Number of recent logs to show", type: :numeric
      method_option :follow, default: false, desc: "Follow log output", type: :boolean
      def logs
        log_file = Rails.root.join("log", "sync.log") if defined?(Rails)
        log_file ||= "log/sync.log"

        unless File.exist?(log_file)
          puts "❌ Log file not found: #{log_file}"
          return
        end

        if options[:follow]
          exec("tail -f #{log_file}")
        else
          exec("tail -n #{options[:tail]} #{log_file}")
        end
      end

      private

      def start_daemon
        pid_file = options[:pid_file]

        # Check if already running
        if File.exist?(pid_file)
          pid = File.read(pid_file).to_i
          begin
            Process.kill(0, pid)
            puts "❌ Worker already running (PID: #{pid})"
            return
          rescue Errno::ESRCH
            # Process not running, remove stale PID file
            File.delete(pid_file)
          end
        end

        # Fork to background
        pid = fork do
          Process.setsid

          # Redirect output to log file
          log_file = Rails.root.join("log", "sync_worker.log") if defined?(Rails)
          log_file ||= "log/sync_worker.log"

          $stdout.reopen(log_file, "a")
          $stderr.reopen(log_file, "a")
          $stdout.sync = true
          $stderr.sync = true

          # Write PID file
          File.write(pid_file, Process.pid)

          # Set up signal handlers
          trap("TERM") { shutdown }
          trap("INT") { shutdown }

          # Start worker loop
          worker_loop
        end

        Process.detach(pid)
        puts "✅ Worker started in background (PID: #{pid})"
      end
      def shutdown
        puts "[#{Time.current}] Shutting down worker..."
        @running = false

        # Clean up PID file if it exists
        pid_file = "tmp/pids/sync_worker.pid"
        File.delete(pid_file) if File.exist?(pid_file)

        exit(0)
      end

      def worker_loop
        @running = true

        while @running
          begin
            # Check if it's time to sync
            if should_sync?
              puts "[#{Time.current}] Running scheduled sync..."
              SyncAwesomeListsJob.perform_now
              puts "[#{Time.current}] Sync completed"
            end

            # Sleep for 1 minute before checking again
            sleep(60)
          rescue => e
            puts "[#{Time.current}] Error in worker loop: #{e.message}"
            puts e.backtrace.first(5).join("\n")
            sleep(60) # Wait before retrying
          end
        end
      end

      def should_sync?
        # Check if we should run based on schedule
        # For now, just check if any lists need syncing
        return false unless defined?(AwesomeList)

        AwesomeList.completed.needs_sync.exists?
      end

      def start_foreground
        puts "Running in foreground mode (press Ctrl+C to stop)"

        # Set up signal handlers
        trap("TERM") { shutdown }
        trap("INT") { shutdown }

        # Start worker loop
        worker_loop
      end
    end
  end
end
