# frozen_string_literal: true

namespace :sync do
  desc 'Sync GitHub stars for all items without stats'
  task stars: :environment do
    client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
    rate_limiter = GithubRateLimiterService.new

    # Get all items that need stars
    items_without_stars = CategoryItem
      .where(stars: nil)
      .where.not(github_repo: [nil, ''])

    # Apply limit if specified
    limit = ENV['LIMIT']&.to_i
    items_without_stars = items_without_stars.limit(limit) if limit&.positive?

    total = items_without_stars.count
    puts "Found #{total} items without stars"

    updated = 0
    failed = 0
    batch_size = 100

    items_without_stars.find_in_batches(batch_size:).with_index do |batch, batch_index|
      puts "\nProcessing batch #{batch_index + 1} (#{batch.size} items)..."

      batch.each_with_index do |item, _index|
        # Rate limiting check
        rate_limiter.wait_if_needed

        begin
          repo_data = client.repository(item.github_repo)

          item.update!(
            last_commit_at: repo_data.pushed_at,
            stars: repo_data.stargazers_count
          )

          updated += 1

          # Progress indicator
          puts "  Progress: #{updated}/#{total} items updated" if updated % 10 == 0
        rescue Octokit::NotFound
          # Repository doesn't exist or is private
          item.update!(stars: 0) # Mark as checked with 0 stars
          failed += 1
        rescue Octokit::TooManyRequests => e
          puts '  Rate limit hit! Waiting...'
          sleep_time = e.response_headers['x-ratelimit-reset'].to_i - Time.now.to_i + 1
          sleep_time = [sleep_time, 3600].min # Max 1 hour
          puts "  Sleeping for #{sleep_time} seconds..."
          sleep(sleep_time)
          retry
        rescue StandardError => e
          puts "  Error with #{item.github_repo}: #{e.message}"
          failed += 1
        end
      end

      puts "  Batch complete: #{updated} updated, #{failed} failed so far"
    end

    puts "\n#{'=' * 50}"
    puts 'Sync complete!'
    puts "  Updated: #{updated} items"
    puts "  Failed: #{failed} items"
    puts "  Total: #{total} items"
  end

  desc 'Sync stars for a specific awesome list'
  task :stars_for_list, [:repo] => :environment do |_t, args|
    repo = args[:repo]

    unless repo
      puts 'Usage: rake sync:stars_for_list[repo_owner/repo_name]'
      exit 1
    end

    list = AwesomeList.find_by(github_repo: repo)

    unless list
      puts "Awesome list not found: #{repo}"
      exit 1
    end

    puts "Syncing stars for #{list.github_repo}..."

    service = DeltaSyncService.new(awesome_list: list)
    result = service.call

    if result.success?
      data = result.value!
      puts 'Success!'
      puts "  Items checked: #{data[:items_checked]}"
      puts "  Items updated: #{data[:items_updated]}"

      # Regenerate the markdown file
      puts "\nRegenerating markdown file..."
      markdown_service = ProcessCategoryServiceEnhanced.new
      markdown_result = markdown_service.call(awesome_list: list)

      if markdown_result.success?
        file_path = markdown_result.value!
        if file_path == :deleted
          puts '  File deleted (no content)'
        else
          puts "  Generated: #{file_path}"
        end
      else
        puts "  Failed to generate markdown: #{markdown_result.failure}"
      end
    else
      puts "Failed: #{result.failure}"
    end
  end
end
