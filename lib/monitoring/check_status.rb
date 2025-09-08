#!/usr/bin/env ruby
# frozen_string_literal: true

require File.expand_path('../../config/environment', __dir__)

class StatusChecker
  def self.run
    puts '=' * 70
    puts "⏰ STATUS CHECK at #{Time.current.strftime('%H:%M:%S')}"
    puts '=' * 70

    # Check GitHub sync progress
    items_with_stars = CategoryItem.where.not(stars: nil).count
    items_without_stars = CategoryItem.where(stars: nil).where.not(github_repo: [nil, '']).count
    total_items = items_with_stars + items_without_stars

    if total_items > 0
      percentage = (items_with_stars.to_f / total_items * 100).round(2)
      puts "\n⭐ GitHub Sync Progress:"
      puts "  Synced: #{items_with_stars}/#{total_items} (#{percentage}%)"
      puts "  Remaining: #{items_without_stars}"

      # Check if sync is complete
      if items_without_stars == 0
        puts '  ✅ SYNC COMPLETE! Ready for pruning.'
        return :sync_complete
      end
    end

    # Check for stalled processes
    last_synced_file = Rails.root.join('tmp', 'last_synced_count.txt')

    if File.exist?(last_synced_file)
      last_count = File.read(last_synced_file).to_i
      if last_count == items_with_stars
        puts '  ⚠️  WARNING: No progress since last check!'
        return :stalled
      end
    end

    File.write(last_synced_file, items_with_stars.to_s)

    # Check AwesomeList states
    puts "\n📚 AwesomeList States:"
    AwesomeList.group(:state).count.each do |state, count|
      puts "  #{state}: #{count}"
    end

    # Check background processes
    puts "\n🔄 Active Processes:"
    ps_output = `ps aux | grep -E "(rails|rake)" | grep -v grep`
    active_count = ps_output.lines.count
    puts "  Found #{active_count} Ruby processes"

    puts "\n#{'=' * 70}"

    :running
  end
end

# Run if executed directly
if __FILE__ == $PROGRAM_NAME
  status = StatusChecker.run

  case status
  when :sync_complete
    puts "\n🎯 NEXT STEP: Run pruning!"
    puts 'Command: bundle exec bin/awesomer prune --force'
  when :stalled
    puts "\n🔧 RECOMMENDATION: Restart sync process"
    puts 'Command: bundle exec rake sync:stars'
  when :running
    puts "\n✅ Everything running normally. Check again in 10 minutes."
  end
end
