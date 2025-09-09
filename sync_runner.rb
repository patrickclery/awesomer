#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'config/environment'

# Run the synchronous sync process
puts '🚀 Starting synchronous sync process...'
puts '=' * 70

start_time = Time.current
client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
rate_limiter = GithubRateLimiterService.new

# Get all items that need stars
items_without_stars = CategoryItem
  .where(stars: nil)
  .where.not(github_repo: [nil, ''])

total = items_without_stars.count

if total == 0
  puts '✅ All items already have stars!'
else
  puts "📊 Found #{total} items without stars"
  puts "Starting sync at #{Time.current.strftime('%H:%M:%S')}"

  updated = 0
  failed = 0
  batch_size = 100
  last_update_time = Time.current
  monitoring_interval = 60 # Check every minute

  items_without_stars.find_in_batches(batch_size:).with_index do |batch, batch_index|
    puts "\nProcessing batch #{batch_index + 1} (#{batch.size} items)..."

    batch.each_with_index do |item, _index|
      # Show monitoring update every minute
      if Time.current - last_update_time >= monitoring_interval
        remaining = total - updated - failed
        percentage = ((updated + failed).to_f / total * 100).round(2)
        puts "\n📊 Progress check at #{Time.current.strftime('%H:%M:%S')}"
        puts "  Processed: #{updated + failed}/#{total} (#{percentage}%)"
        puts "  Remaining: #{remaining}"

        if updated > 0
          elapsed = Time.current - start_time
          rate = updated.to_f / elapsed
          eta_seconds = remaining / rate
          eta_minutes = (eta_seconds / 60).round
          puts "  Rate: #{(rate * 60).round(1)} items/minute"
          puts "  ETA: #{eta_minutes} minutes"
        end

        last_update_time = Time.current
      end

      # Rate limiting check
      begin
        rate_limiter.check_and_wait!
      rescue StandardError
        puts "\n⚠️  Rate limit reached, waiting 60 seconds..."
        sleep(60)
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

        puts "\n✅ Progress: #{updated}/#{total} items updated" if updated % 100 == 0
      rescue Octokit::NotFound
        # Repository doesn't exist or is private
        item.update!(stars: 0) # Mark as checked with 0 stars
        failed += 1
        print 'x'
      rescue Octokit::TooManyRequests => e
        puts "\n🛑 GitHub rate limit hit!"
        reset_time = e.response_headers['x-ratelimit-reset'].to_i
        sleep_time = reset_time - Time.now.to_i + 1
        sleep_time = [sleep_time, 3600].min # Max 1 hour
        puts "  Waiting #{sleep_time} seconds (until #{Time.at(reset_time).strftime('%H:%M:%S')})"

        # Show countdown for rate limit wait
        sleep_time.downto(1) do |remaining|
          if remaining % 60 == 0
            minutes = remaining / 60
            print "\r⏳ Rate limit wait: #{minutes} minutes remaining...     "
          elsif remaining <= 10
            print "\r⏳ Rate limit wait: #{remaining} seconds remaining...    "
          end
          sleep(1)
        end
        print "\r✅ Resuming sync...                                      \n"
        retry
      rescue StandardError => e
        puts "\n❌ Error with #{item.github_repo}: #{e.message}"
        failed += 1
      end
    end

    puts "\nBatch #{batch_index + 1} complete: #{updated} updated, #{failed} failed"
  end

  puts "\n#{'=' * 70}"
  puts '✅ SYNC COMPLETE!'
  puts "  Updated: #{updated} items"
  puts "  Failed: #{failed} items" if failed > 0
  puts "  Total: #{total} items"

  elapsed = Time.current - start_time
  minutes = (elapsed / 60).round
  puts "  Time taken: #{minutes} minutes"
end

# Step 2: Run pruning
puts "\n#{'=' * 70}"
puts '🗑️  Running pruning phase...'

validator = ListValidationService.new(stale_days: 365)
result = validator.prune!(dry_run: false)

if result.success?
  stats = result.value!
  puts "✅ Pruned #{stats[:total_deleted]} invalid lists"
  puts "  Stale: #{stats[:stale].size}" if stats[:stale].any?
  puts "  No repos: #{stats[:no_repos].size}" if stats[:no_repos].any?
  puts "  Orphaned: #{stats[:orphaned].size}" if stats[:orphaned].any?
else
  puts "❌ Pruning failed: #{result.failure}"
end

# Step 3: Delete old markdown files
puts "\n#{'=' * 70}"
puts '🗑️  Deleting old markdown files...'

markdown_dir = Rails.root.join('static', 'awesomer')
existing_files = Dir.glob(File.join(markdown_dir, '*.md'))
                   .reject { |f| File.basename(f) == 'README.md' }

existing_files.each { |f| File.delete(f) }
puts "✅ Deleted #{existing_files.count} old markdown files"

# Step 4: Generate fresh markdown
puts "\n#{'=' * 70}"
puts '📝 Generating fresh markdown files...'

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

puts "\n✅ Generated #{success_count} markdown files"
puts "❌ Failed: #{failed_count}" if failed_count > 0

# Final summary
puts "\n#{'=' * 70}"
puts '🎉 COMPLETE SYNC PROCESS FINISHED!'
puts '=' * 70

total_lists = AwesomeList.active.count
completed = AwesomeList.active.completed.count
items_with_stars = CategoryItem.where.not(stars: nil).count
total_items = CategoryItem.where.not(github_repo: [nil, '']).count
files = Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).count - 1

puts "\nFinal Statistics:"
puts '  Awesome Lists:'
puts "    • Total: #{total_lists}"
puts "    • Completed: #{completed}"
puts '  Items:'
puts "    • Total with GitHub: #{total_items}"
puts "    • With stars: #{items_with_stars}"
puts "    • Coverage: #{(items_with_stars.to_f / total_items * 100).round(1)}%"
puts '  Files:'
puts "    • Markdown files: #{files}"

total_elapsed = Time.current - start_time
total_minutes = (total_elapsed / 60).round
puts "\n⏱️  Total time: #{total_minutes} minutes"
puts '✅ All done!'
