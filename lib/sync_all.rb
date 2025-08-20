#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../config/environment"
require "timeout"

class SyncAll
  MAX_PROCESSING_TIME = 60 # Maximum seconds per repository
  MAX_RETRIES = 3

  def run
    puts "🚀 Starting sync of all awesome lists with GitHub stats..."
    puts "⏱️  With timeout protection (#{MAX_PROCESSING_TIME}s per repo)"
    puts "=" * 60

    # Reset any stuck in_progress items from previous runs
    reset_stuck_items

    total_pending = AwesomeList.pending.count
    total_all = AwesomeList.count

    puts "📊 Current Status:"
    puts "  • Total repositories: #{total_all}"
    puts "  • Pending: #{total_pending}"
    puts "  • Completed: #{AwesomeList.completed.count}"
    puts "  • Failed: #{AwesomeList.failed.count}"
    puts "  • In Progress: #{AwesomeList.in_progress.count}"
    puts

    if total_pending == 0
      puts "✅ All repositories have been processed!"
      return
    end

    puts "Processing #{total_pending} pending repositories..."
    puts "This will fetch GitHub stats for each repository."
    puts "Note: Each repo has a #{MAX_PROCESSING_TIME}s timeout to prevent stalling."
    puts

    success_count = 0
    failed_count = 0
    timeout_count = 0
    rate_limit_count = 0
    processed = 0
    consecutive_failures = 0

    AwesomeList.pending.find_each.with_index do |list, index|
      processed += 1
      progress = "[#{processed}/#{total_pending}]"

      puts "#{progress} Processing #{list.github_repo}..."

      begin
        # Wrap processing in timeout to prevent indefinite hanging
        Timeout.timeout(MAX_PROCESSING_TIME) do
          service = ProcessAwesomeListService.new(
            repo_identifier: list.github_repo,
            sync: true
          )
          result = service.call

          if result.success?
            success_count += 1
            consecutive_failures = 0
            puts "  ✅ Success - Generated markdown with stats"
          else
            error_msg = result.failure.to_s
            if error_msg.downcase.include?("rate limit")
              rate_limit_count += 1
              consecutive_failures += 1
              puts "  ⚠️  Rate limited - will retry later"
              # Don't mark as failed, leave as pending for retry
            else
              failed_count += 1
              consecutive_failures += 1
              puts "  ❌ Failed: #{error_msg[0..100]}..."
            end
          end
        end
      rescue Timeout::Error => e
        timeout_count += 1
        consecutive_failures += 1
        puts "  ⏱️  Timeout after #{MAX_PROCESSING_TIME}s - marking as pending for retry"
        # Reset to pending if it got stuck in progress
        list.update(state: "pending") if list.state == "in_progress"
      rescue => e
        failed_count += 1
        consecutive_failures += 1
        puts "  ❌ Error: #{e.message[0..100]}..."
      end

      # Add delay to respect API limits
      sleep 1

      # Show periodic status updates
      if processed % 10 == 0
        puts
        puts "📊 Progress Update:"
        puts "  • Processed: #{processed}/#{total_pending}"
        puts "  • Successful: #{success_count}"
        puts "  • Failed: #{failed_count}"
        puts "  • Timeouts: #{timeout_count}"
        puts "  • Rate Limited: #{rate_limit_count}"
        puts
      end

      # Stop if too many consecutive failures (likely a systemic issue)
      if consecutive_failures >= 10
        puts
        puts "⚠️  Too many consecutive failures. Stopping to prevent waste."
        puts "   You may want to check your API key or network connection."
        break
      end

      # Check for rate limiting
      if rate_limit_count > 5
        puts
        puts "⚠️  Too many rate limit errors. Pausing for 60 seconds..."
        sleep 60
        rate_limit_count = 0
      end
    end

    puts
    puts "=" * 60
    puts "✅ Sync Complete!"
    puts
    puts "📊 Final Summary:"
    puts "  • Total Processed: #{processed}"
    puts "  • Successful: #{success_count}"
    puts "  • Failed: #{failed_count}"
    puts "  • Rate Limited (will retry): #{rate_limit_count}"

    # Show current database status
    puts
    puts "📈 Database Status:"
    puts "  • Completed: #{AwesomeList.completed.count}"
    puts "  • Pending: #{AwesomeList.pending.count}"
    puts "  • Failed: #{AwesomeList.failed.count}"

    # Check generated files
    generated_files = Dir.glob("static/md/*.md")
    puts
    puts "📁 Generated Files:"
    puts "  • Count: #{generated_files.count}"
    puts "  • Location: static/md/"

    if generated_files.any?
      # Sample check for actual stats
      sample_file = generated_files.first
      content = File.read(sample_file)
      na_count = content.scan(/\| N\/A\s+\|/).count
      total_rows = content.scan(/^\|[^-]/).count - 1 # Exclude header

      if total_rows > 0
        stats_percentage = ((total_rows - na_count).to_f / total_rows * 100).round(1)
        puts "  • Sample stats coverage: #{stats_percentage}% have GitHub stats"
      end
    end
  end

  private

  def reset_stuck_items
    stuck_count = AwesomeList.in_progress.count
    if stuck_count > 0
      puts "🔄 Resetting #{stuck_count} stuck in_progress items..."
      AwesomeList.in_progress.update_all(state: "pending", updated_at: Time.current)
    end
  end
end

# Run if called directly
if __FILE__ == $0
  SyncAll.new.run
end
