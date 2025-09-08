# frozen_string_literal: true

require 'logger'

class SyncMonitor
  attr_reader :logger, :start_time, :last_check_time

  def initialize
    @logger = Logger.new($stdout)
    @logger.formatter = proc do |severity, datetime, _progname, msg|
      "#{datetime.strftime('%H:%M:%S')} [#{severity}] #{msg}\n"
    end
    @start_time = Time.current
    @last_check_time = Time.current
    @last_synced_count = 0
    @stall_counter = 0
  end

  def run
    logger.info '🚀 Starting sync monitoring system'
    logger.info 'Will check every 10 minutes for progress and stalls'

    loop do
      check_status
      sleep(600) # 10 minutes
    end
  rescue Interrupt
    logger.info '👋 Monitoring stopped by user'
  end

  def check_status
    logger.info '=' * 60
    logger.info "⏰ Status check at #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}"

    # Check sync progress
    sync_status = check_sync_progress

    if sync_status[:completed]
      logger.info '✅ Sync completed! Moving to pruning phase...'
      run_pruning
      generate_markdown
      logger.info '🎉 All tasks completed successfully!'
      exit 0
    elsif sync_status[:stalled]
      handle_stalled_sync
    else
      logger.info "📈 Sync progressing normally (#{sync_status[:percentage]}% complete)"
    end

    @last_check_time = Time.current
  end

  private

  def check_sync_progress
    items_with_stars = CategoryItem.where.not(stars: nil).count
    items_without_stars = CategoryItem.where(stars: nil).where.not(github_repo: [nil, '']).count
    total_items = items_with_stars + items_without_stars

    percentage = total_items > 0 ? (items_with_stars.to_f / total_items * 100).round(2) : 0

    # Check if progress has stalled
    stalled = false
    if items_with_stars == @last_synced_count
      @stall_counter += 1
      stalled = @stall_counter >= 2 # Stalled if no progress for 20 minutes
    else
      @stall_counter = 0
    end

    @last_synced_count = items_with_stars

    logger.info "  📊 Items synced: #{items_with_stars}/#{total_items} (#{percentage}%)"
    logger.info "  ⏱️  Time elapsed: #{format_duration(Time.current - start_time)}"

    if total_items > 0 && items_with_stars > 0
      rate = items_with_stars.to_f / (Time.current - start_time)
      eta = items_without_stars / rate
      logger.info "  🔮 Estimated completion: #{format_duration(eta)}"
    end

    {
      completed: items_without_stars == 0 && total_items > 0,
      items_remaining: items_without_stars,
      items_synced: items_with_stars,
      percentage:,
      stalled:
    }
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

  def run_pruning
    logger.info '🗑️  Starting pruning phase...'

    result = system('bundle exec bin/awesomer prune --force < /dev/null')

    if result
      logger.info '✅ Pruning completed successfully'
    else
      logger.error '❌ Pruning failed!'
    end
  end

  def generate_markdown
    logger.info '📝 Generating markdown files...'

    result = system(%{
      bundle exec rails runner "
        service = ProcessCategoryServiceEnhanced.new
        count = 0

        AwesomeList.all.each do |list|
          result = service.call(awesome_list: list)
          count += 1 if result.success?
        end

        puts "Generated #{count} markdown files"
      "
    })

    if result
      logger.info '✅ Markdown generation completed'
    else
      logger.error '❌ Markdown generation failed!'
    end
  end

  def handle_stalled_sync
    logger.warn '⚠️  Sync appears to be stalled! Restarting sync process...'

    # Kill any existing sync processes
    `pkill -f "rake sync:stars" 2>/dev/null`
    `pkill -f "rails runner.*sync" 2>/dev/null`

    # Start a new sync process
    logger.info '🔄 Starting new sync process...'

    Thread.new do
      system(%{
        bundle exec rails runner "
          puts 'Restarting sync with enhanced rate limiting...'

          client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
          rate_limiter = GithubRateLimiterService.new

          while true
            items = CategoryItem
              .where(stars: nil)
              .where.not(github_repo: [nil, ''])
              .limit(100)

            break if items.empty?

            items.each do |item|
              rate_limiter.wait_if_needed

              begin
                repo_data = client.repository(item.github_repo)
                item.update!(
                  last_commit_at: repo_data.pushed_at,
                  stars: repo_data.stargazers_count
                )
              rescue Octokit::NotFound
                item.update!(stars: 0)
              rescue Octokit::TooManyRequests => e
                wait_time = [e.response_headers['x-ratelimit-reset'].to_i - Time.now.to_i + 1, 3600].min
                sleep(wait_time)
                retry
              rescue StandardError
                # Skip and continue
              end
            end

            remaining = CategoryItem.where(stars: nil).where.not(github_repo: [nil, '']).count
            puts "Remaining: #{remaining}"
            break if remaining == 0
          end
        " &
      })
    end

    @stall_counter = 0
  end
end

# Run the monitor if this file is executed directly
if __FILE__ == $PROGRAM_NAME
  require File.expand_path('../../config/environment', __dir__)
  SyncMonitor.new.run
end
