#!/usr/bin/env ruby
# frozen_string_literal: true

require File.expand_path('../../config/environment', __dir__)

class ProperSequenceRunner
  def self.run
    new.execute_sequence
  end

  def execute_sequence
    log '🚀 Starting Proper Sequence Runner'
    log 'Correct order:'
    log '1. Sync all lists (add new entries)'
    log '2. Delete orphaned category items'
    log '3. Prune invalid lists'
    log '4. Update all category items with GitHub stats'
    log '5. Delete all markdown files'
    log '6. Generate fresh markdown files'
    log '=' * 70

    # Step 1: Wait for sync to complete
    wait_for_sync_completion

    # Step 2: Delete orphaned category items
    delete_orphaned_items

    # Step 3: Run pruning
    run_pruning

    # Step 4: Update category items (already done in sync)
    log "\n✅ Step 4: Category items already updated during sync"

    # Step 5: Delete all markdown files
    delete_all_markdown

    # Step 6: Generate fresh markdown
    generate_markdown

    log "\n🎉 Sequence completed successfully!"
  end

  private

  def log(message)
    puts message

    # Also write to log file
    log_file = Rails.root.join('log', 'proper_sequence.log')
    File.open(log_file, 'a') do |f|
      f.puts "[#{Time.current.iso8601}] #{message}"
    end
  end

  def wait_for_sync_completion
    log "\n📊 Step 1: Waiting for sync to complete..."

    loop do
      items_without_stars = CategoryItem.where(stars: nil).where.not(github_repo: [nil, '']).count
      items_with_stars = CategoryItem.where.not(stars: nil).count
      total = items_with_stars + items_without_stars

      if items_without_stars == 0 && total > 0
        log "  ✅ Sync complete! All #{total} items have stars."
        break
      else
        percentage = total > 0 ? (items_with_stars.to_f / total * 100).round(2) : 0
        log "  ⏳ Sync in progress: #{items_with_stars}/#{total} (#{percentage}%)"
        log '     Waiting 2 minutes before next check...'
        sleep(120)
      end
    end
  end

  def delete_orphaned_items
    log "\n🗑️ Step 2: Deleting orphaned category items..."

    # Find all CategoryItem github_repos
    CategoryItem.where.not(github_repo: [nil, '']).pluck(:github_repo).uniq

    # Find all repos that are actually referenced in current awesome lists
    AwesomeList.find_each do |list|
      # Here we'd need to parse the list content to find referenced repos
      # For now, we'll just check if items belong to active lists
    end

    # Delete items that don't belong to any active list
    orphaned = CategoryItem.joins(:category)
                          .where(categories: {awesome_list_id: nil})
                          .count

    if orphaned > 0
      CategoryItem.joins(:category)
                  .where(categories: {awesome_list_id: nil})
                  .destroy_all
      log "  ✅ Deleted #{orphaned} orphaned items"
    else
      log '  ✅ No orphaned items found'
    end
  end

  def run_pruning
    log "\n🗑️ Step 3: Running pruning..."

    validator = ListValidationService.new(stale_days: 365)
    result = validator.prune!(dry_run: false)

    if result.success?
      stats = result.value!
      log "  ✅ Pruned #{stats[:total_deleted]} invalid lists"
      log "     Stale: #{stats[:stale].size}" if stats[:stale].any?
      log "     No repos: #{stats[:no_repos].size}" if stats[:no_repos].any?
      log "     Orphaned: #{stats[:orphaned].size}" if stats[:orphaned].any?
    else
      log "  ❌ Pruning failed: #{result.failure}"
    end
  end

  def delete_all_markdown
    log "\n🗑️ Step 5: Deleting all existing markdown files..."

    markdown_dir = Rails.root.join('static', 'awesomer')
    existing_files = Dir.glob(File.join(markdown_dir, '*.md'))
                       .reject { |f| File.basename(f) == 'README.md' }

    existing_files.each { |f| File.delete(f) }

    log "  ✅ Deleted #{existing_files.count} markdown files"
  end

  def generate_markdown
    log "\n📝 Step 6: Generating fresh markdown files..."

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

    puts # New line after progress dots
    log "  ✅ Generated #{success_count} markdown files"
    log "  ❌ Failed: #{failed_count}" if failed_count > 0
  end
end

# Run if executed directly
ProperSequenceRunner.run if __FILE__ == $PROGRAM_NAME
