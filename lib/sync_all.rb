#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../config/environment"

class SyncAllAwesomeLists
  def run
    puts "🚀 Starting sync of all awesome lists with GitHub stats..."
    puts "=" * 60

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
    puts "Note: This may take a while due to GitHub API rate limits."
    puts

    success_count = 0
    failed_count = 0
    rate_limit_count = 0
    processed = 0

    AwesomeList.pending.find_each.with_index do |list, index|
      processed += 1
      progress = "[#{processed}/#{total_pending}]"

      puts "#{progress} Processing #{list.github_repo}..."

      begin
        service = ProcessAwesomeListService.new(
          repo_identifier: list.github_repo,
          sync: true
        )
        result = service.call

        if result.success?
          success_count += 1
          puts "  ✅ Success - Generated markdown with stats"
        else
          error_msg = result.failure.to_s
          if error_msg.downcase.include?("rate limit")
            rate_limit_count += 1
            puts "  ⚠️  Rate limited - will retry later"
            # Don't mark as failed, leave as pending for retry
          else
            failed_count += 1
            puts "  ❌ Failed: #{error_msg[0..100]}..."
          end
        end
      rescue => e
        failed_count += 1
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
        puts "  • Rate Limited: #{rate_limit_count}"
        puts
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
end

# Run if called directly
if __FILE__ == $0
  SyncAllAwesomeLists.new.run
end
