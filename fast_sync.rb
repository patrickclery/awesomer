#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'config/environment'

# Fast sync without excessive rate limiting delays
puts '🚀 Starting FAST sync process...'
puts '=' * 70

start_time = Time.current
client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))

# Get all items that need stars
items_without_stars = CategoryItem
  .where(stars: nil)
  .where.not(github_repo: [nil, ''])

total = items_without_stars.count

if total == 0
  puts '✅ All items already have stars!'
  exit 0
end

puts "📊 Found #{total} items without stars"
puts "Starting fast sync at #{Time.current.strftime('%H:%M:%S')}"

updated = 0
failed = 0
batch_size = 100
last_update_time = Time.current
monitoring_interval = 30 # Check every 30 seconds
request_count = 0
request_batch_start = Time.current

items_without_stars.find_in_batches(batch_size:).with_index do |batch, batch_index|
  puts "\nProcessing batch #{batch_index + 1} (#{batch.size} items)..."

  batch.each_with_index do |item, _index|
    # Show monitoring update every 30 seconds
    if Time.current - last_update_time >= monitoring_interval
      remaining = total - updated - failed
      percentage = ((updated + failed).to_f / total * 100).round(2)
      elapsed = Time.current - start_time
      rate = updated.to_f / elapsed

      puts "\n📊 Progress at #{Time.current.strftime('%H:%M:%S')}"
      puts "  Processed: #{updated + failed}/#{total} (#{percentage}%)"
      puts "  Remaining: #{remaining}"
      puts "  Rate: #{(rate * 60).round(1)} items/minute"

      if remaining > 0 && rate > 0
        eta_seconds = remaining / rate
        eta_minutes = (eta_seconds / 60).round
        puts "  ETA: #{eta_minutes} minutes"
      end

      last_update_time = Time.current
    end

    # Simple rate limiting - 80 requests per minute max (GitHub allows 83)
    request_count += 1
    if request_count >= 80
      elapsed_in_batch = Time.current - request_batch_start
      if elapsed_in_batch < 60
        sleep_time = 60 - elapsed_in_batch
        puts "\n⏸️  Rate limiting: waiting #{sleep_time.round} seconds..."
        sleep(sleep_time)
      end
      request_count = 0
      request_batch_start = Time.current
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

      puts "\n✅ Milestone: #{updated} items updated" if updated % 100 == 0
    rescue Octokit::NotFound
      # Repository doesn't exist or is private
      item.update!(stars: 0) # Mark as checked with 0 stars
      failed += 1
      print 'x'
    rescue Octokit::TooManyRequests => e
      puts "\n🛑 GitHub rate limit hit!"

      # Check actual rate limit
      rate_limit = client.rate_limit
      puts "  Remaining: #{rate_limit.remaining}/#{rate_limit.limit}"
      puts "  Resets at: #{rate_limit.resets_at.strftime('%H:%M:%S')}"

      if rate_limit.remaining == 0
        sleep_time = rate_limit.resets_at - Time.now + 5
        sleep_time = [sleep_time, 3600].min
        puts "  Waiting #{(sleep_time / 60).round} minutes..."

        # Show countdown
        sleep_time.to_i.downto(1) do |remaining|
          if remaining % 60 == 0
            minutes = remaining / 60
            print "\r⏳ Rate limit wait: #{minutes} minutes remaining...     "
          elsif remaining <= 10
            print "\r⏳ Rate limit wait: #{remaining} seconds remaining...    "
          end
          sleep(1)
        end
        print "\r✅ Resuming sync...                                      \n"
      else
        # Short wait if we have remaining quota
        puts '  Brief pause for 10 seconds...'
        sleep(10)
      end

      retry
    rescue StandardError => e
      puts "\n❌ Error with #{item.github_repo}: #{e.message}"
      failed += 1
    end
  end

  puts "\nBatch #{batch_index + 1} complete: #{updated} updated, #{failed} failed"
end

elapsed = Time.current - start_time
minutes = (elapsed / 60).round

puts "\n#{'=' * 70}"
puts '✅ SYNC COMPLETE!'
puts "  Updated: #{updated} items"
puts "  Failed: #{failed} items" if failed > 0
puts "  Total: #{total} items"
puts "  Time taken: #{minutes} minutes"
puts "  Average rate: #{(updated.to_f / elapsed * 60).round(1)} items/minute"

# Now run the rest of the update process
puts "\n#{'=' * 70}"
puts '🔄 Running full update process...'

# Execute the update command
system('./bin/awesomer update')
