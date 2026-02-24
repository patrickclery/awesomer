#!/usr/bin/env ruby
# frozen_string_literal: true

require File.expand_path('../../config/environment', __dir__)
require 'fileutils'

class SyncOrchestrator
  def self.run
    new.orchestrate
  end

  def orchestrate
    log '🚀 Starting Sync Orchestrator'
    log 'Sequence: Sync → Prune → Generate Markdown'

    # Start monitoring loop
    loop do
      status = check_and_act

      case status
      when :complete
        log '🎉 All tasks completed successfully!'
        break
      when :running
        log '⏱️  Waiting 10 minutes before next check...'
        sleep(600) # 10 minutes
      when :error
        log '❌ Error detected, attempting recovery...'
        sleep(60) # Wait 1 minute before retry
      end
    end
  end

  private

  def log(message)
    puts message

    # Also write to log file
    log_file = Rails.root.join('log', 'orchestrator.log')
    File.open(log_file, 'a') do |f|
      f.puts "[#{Time.current.iso8601}] #{message}"
    end
  end

  def check_and_act
    log_separator
    log "⏰ Status check at #{Time.current.strftime('%H:%M:%S')}"

    # Check sync status
    sync_status = check_sync_progress

    if sync_status[:complete]
      log '✅ Sync complete! Moving to pruning...'

      if run_pruning
        log '✅ Pruning complete! Generating markdown...'

        if generate_markdown
          log '✅ Markdown generation complete!'
          :complete
        else
          log '❌ Markdown generation failed'
          :error
        end
      else
        log '❌ Pruning failed'
        :error
      end
    elsif sync_status[:stalled]
      log '⚠️  Sync appears stalled. Attempting restart...'
      restart_sync
      :running
    else
      log "📈 Sync in progress: #{sync_status[:percentage]}%"
      ensure_sync_running
      :running
    end
  end

  def log_separator
    log('=' * 70)
  end

  def check_sync_progress
    items_with_stars = CategoryItem.where.not(stars: nil).count
    items_without_stars = CategoryItem.where(stars: nil).where.not(github_repo: [nil, '']).count
    total = items_with_stars + items_without_stars

    percentage = total > 0 ? (items_with_stars.to_f / total * 100).round(2) : 0

    # Check for stall
    stall_file = Rails.root.join('tmp', 'sync_progress.txt')
    stalled = false

    if File.exist?(stall_file)
      last_data = JSON.parse(File.read(stall_file))
      if last_data['count'] == items_with_stars &&
         Time.parse(last_data['time']) < 20.minutes.ago
        stalled = true
      end
    end

    # Update progress file
    File.write(stall_file, {
      count: items_with_stars,
      time: Time.current.iso8601
    }.to_json)

    log "  📊 Sync: #{items_with_stars}/#{total} items (#{percentage}%)"

    {
      complete: items_without_stars == 0 && total > 0,
      percentage:,
      remaining: items_without_stars,
      stalled:,
      synced: items_with_stars
    }
  end

  def run_pruning
    log '  🗑️  Running pruning...'

    # Use the validation service
    validator = ListValidationService.new(stale_days: 365)
    result = validator.prune!(dry_run: false)

    if result.success?
      stats = result.value!
      log "  ✅ Pruned #{stats[:total_deleted]} invalid lists"
      true
    else
      log "  ❌ Pruning failed: #{result.failure}"
      false
    end
  rescue StandardError => e
    log "  ❌ Pruning error: #{e.message}"
    false
  end

  def generate_markdown
    log '  📝 Generating markdown files...'

    begin
      service = ProcessCategoryServiceEnhanced.new
      success_count = 0
      error_count = 0

      AwesomeList.all.find_each do |list|
        result = service.call(awesome_list: list)
        if result.success?
          success_count += 1
        else
          error_count += 1
        end
      end

      log "  ✅ Generated #{success_count} files (#{error_count} errors)"
      error_count == 0
    rescue StandardError => e
      log "  ❌ Generation error: #{e.message}"
      false
    end
  end

  def restart_sync
    # Kill any existing sync processes
    system("pkill -f 'sync:stars' 2>/dev/null")

    # Start new sync in background
    Thread.new do
      system("bundle exec rake sync:stars 2>&1 > #{Rails.root.join('log', 'sync.log')} &")
    end

    log '  🔄 Started new sync process'
  end

  def ensure_sync_running
    # Check if sync process is running
    ps_output = `ps aux | grep "sync:stars" | grep -v grep`

    return unless ps_output.empty?

    log '  ⚠️  No sync process found. Starting new sync...'
    restart_sync
  end
end

# Run if executed directly
SyncOrchestrator.run if __FILE__ == $PROGRAM_NAME
