#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../config/environment'
require 'concurrent'

class FastSync
  def run
    puts '🚀 Fast Sync - Processing remaining awesome lists'
    puts '=' * 60

    pending = AwesomeList.active.pending.to_a
    total = pending.count

    if total == 0
      puts '✅ All repositories have been processed!'
      return
    end

    puts "📊 Found #{total} pending repositories"
    puts '⚡ Processing in batches with concurrency...'
    puts

    completed = Concurrent::AtomicFixnum.new(0)
    failed = Concurrent::AtomicFixnum.new(0)

    # Process in smaller batches to avoid overwhelming
    batch_size = 10
    pending.each_slice(batch_size) do |batch|
      puts "Processing batch of #{batch.size} repositories..."

      # Use thread pool for concurrent processing
      pool = Concurrent::FixedThreadPool.new(3)
      promises = batch.map do |list|
        Concurrent::Promise.execute(executor: pool) do
          service = ProcessAwesomeListService.new(
            repo_identifier: list.github_repo,
            sync: true
          )
          result = service.call

          if result.success?
            completed.increment
            puts "  ✅ #{list.github_repo}"
            true
          else
            if result.failure.to_s.downcase.include?('rate limit')
              # Don't count rate limits as failures
              puts "  ⚠️  #{list.github_repo} - rate limited"
            else
              failed.increment
              puts "  ❌ #{list.github_repo} - #{result.failure.to_s[0..50]}"
            end
            false
          end
        rescue StandardError => e
          failed.increment
          puts "  ❌ #{list.github_repo} - Error: #{e.message[0..50]}"
          false
        end
      end

      # Wait for batch to complete
      promises.each(&:wait)
      pool.shutdown
      pool.wait_for_termination

      # Check for rate limiting
      if promises.count { |p| p.value == false } > batch_size / 2
        puts '⚠️  Many failures in batch, likely rate limited. Waiting 60 seconds...'
        sleep 60
      else
        # Small delay between batches
        sleep 2
      end

      puts "Progress: #{completed.value}/#{total} completed, #{failed.value} failed"
      puts
    end

    puts '=' * 60
    puts '✅ Fast Sync Complete!'
    puts
    puts '📊 Final Results:'
    puts "  • Processed: #{total}"
    puts "  • Successful: #{completed.value}"
    puts "  • Failed: #{failed.value}"

    # Show database status
    states = AwesomeList.group(:state).count
    puts
    puts '📈 Database Status:'
    states.each { |k, v| puts "  • #{k.capitalize}: #{v}" }

    # Check files
    files = Dir.glob('static/awesomer/*.md')
    puts
    puts "📁 Generated Files: #{files.count}"
  end
end

FastSync.new.run if __FILE__ == $PROGRAM_NAME
