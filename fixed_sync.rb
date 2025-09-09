#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'config/environment'

# Fixed sync that properly handles 404s and error responses
puts '🚀 Starting FIXED sync process...'
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
puts "Starting at #{Time.current.strftime('%H:%M:%S')}"

updated = 0
failed = 0
not_found = 0
batch_size = 100
last_report = Time.current

items_without_stars.find_in_batches(batch_size:).with_index do |batch, batch_index|
  puts "\nBatch #{batch_index + 1} (#{batch.size} items)..."

  batch.each do |item|
    begin
      repo_data = client.repository(item.github_repo)

      # Check if we got an error response object
      if repo_data.respond_to?(:message) && repo_data.message == 'Not Found'
        # This is actually a 404 error response, not a real repository
        item.update!(stars: 0) # Mark as checked with 0 stars
        not_found += 1
        print 'x'
      elsif repo_data.respond_to?(:stargazers_count) && !repo_data.stargazers_count.nil?
        # Valid repository data
        item.update!(
          last_commit_at: repo_data.pushed_at,
          stars: repo_data.stargazers_count
        )
        updated += 1
        print '.'
      else
        # Unexpected response format
        puts "\n⚠️  Unexpected response for #{item.github_repo}"
        item.update!(stars: 0)
        failed += 1
      end

      # Progress report every 100 items or 30 seconds
      if (updated + failed + not_found) % 100 == 0 || (Time.current - last_report) > 30
        processed = updated + failed + not_found
        remaining = total - processed
        percentage = (processed.to_f / total * 100).round(1)

        puts "\n  Progress: #{processed}/#{total} (#{percentage}%)"
        puts "  ✅ Updated: #{updated}, ❌ Not found: #{not_found}, ⚠️ Failed: #{failed}"

        if processed > 0
          elapsed = Time.current - start_time
          rate = processed.to_f / elapsed * 60
          eta = remaining / (processed.to_f / elapsed)
          puts "  Rate: #{rate.round(1)} items/min, ETA: #{(eta / 60).round} minutes"
        end

        last_report = Time.current
      end
    rescue Octokit::NotFound
      # Explicit 404 from API
      item.update!(stars: 0)
      not_found += 1
      print 'x'
    rescue Octokit::TooManyRequests => e
      puts "\n🛑 Rate limit hit!"

      rate_limit = client.rate_limit
      puts "  Remaining: #{rate_limit.remaining}/#{rate_limit.limit}"

      if rate_limit.remaining == 0
        wait_time = rate_limit.resets_at - Time.now + 5
        puts "  Waiting until #{rate_limit.resets_at.strftime('%H:%M:%S')}..."
        sleep(wait_time)
      else
        sleep(10)
      end

      retry
    rescue StandardError => e
      puts "\n❌ Error with #{item.github_repo}: #{e.class} - #{e.message}"
      item.update!(stars: 0) # Mark as processed to avoid retrying
      failed += 1
    end

    # Small delay to avoid hitting rate limits
    sleep(0.05) # 20 requests per second max
  end

  puts "\nBatch #{batch_index + 1} complete"
end

elapsed = Time.current - start_time
puts "\n#{'=' * 70}"
puts '✅ SYNC COMPLETE!'
puts "  Updated: #{updated} items"
puts "  Not found (404): #{not_found} items"
puts "  Failed: #{failed} items"
puts "  Total: #{total} items"
puts "  Time: #{(elapsed / 60).round} minutes"
puts "  Rate: #{(total.to_f / elapsed * 60).round(1)} items/minute"

# Check final status
remaining = CategoryItem.where(stars: nil).where.not(github_repo: [nil, '']).count
if remaining > 0
  puts "\n⚠️  Still #{remaining} items without stars"
else
  puts "\n✅ All items now have star counts!"
end

puts "\n#{'=' * 70}"
puts '🔄 Starting update process...'
system('./bin/awesomer update')
