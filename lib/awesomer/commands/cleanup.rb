# frozen_string_literal: true

require 'thor'

module Awesomer
  module Commands
    class Cleanup < Thor::Group
      include Thor::Actions

      def self.banner
        'awesomer cleanup'
      end

      desc 'Clean up empty files and reprocess failed lists'

      def check_empty_files
        say '🔍 Checking for empty/small files...', :cyan

        @small_files = Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).select do |f|
          File.basename(f) != 'README.md' && File.size(f) < 200
        end

        if @small_files.any?
          say "Found #{@small_files.count} small/empty files", :yellow
        else
          say 'No empty files found', :green
        end
      end

      def delete_empty_files
        return unless @small_files&.any?

        return unless yes?('Delete these empty files?', :red)

        @small_files.each do |file|
          File.delete(file)
          say "  ✗ Deleted #{File.basename(file)}", :red
        end
        say "Deleted #{@small_files.count} files", :green
      end

      def check_failed_lists
        say "\n🔍 Checking for failed/empty lists...", :cyan

        @failed_lists = AwesomeList.active.where(state: 'failed')
        @empty_lists = AwesomeList.active
          .left_joins(:categories)
          .group('awesome_lists.id')
          .having('COUNT(categories.id) = 0')

        say "  Failed lists: #{@failed_lists.count}", :yellow
        say "  Lists with no categories: #{@empty_lists.count}", :yellow
      end

      def reprocess_failed_lists
        total = (@failed_lists.to_a + @empty_lists.to_a).uniq.count

        return if total == 0

        return unless yes?("\nReprocess #{total} failed/empty lists?", :yellow)

        say 'Processing lists...', :cyan

        processed = 0
        success = 0

        (@failed_lists.to_a + @empty_lists.to_a).uniq.each do |list|
          say "  Processing #{list.github_repo}...", :blue

          # Reset to pending
          list.update!(state: 'pending')

          # Process with sync
          service = ProcessAwesomeListService.new(
            repo_identifier: list.github_repo,
            sync: true
          )

          result = service.call

          if result.success?
            # Generate markdown
            categories_with_items = list.reload.categories.joins(:category_items).distinct

            if categories_with_items.any?
              ProcessCategoryServiceEnhanced.new.call(awesome_list: list)
              say '    ✅ Success', :green
              success += 1
            else
              say '    ⚠️  No content found', :yellow
            end
          else
            say "    ❌ Failed: #{result.failure}", :red
          end

          processed += 1

          # Rate limit
          sleep(1) if processed % 5 == 0
        end

        say "\n✅ Reprocessed #{processed} lists (#{success} successful)", :green
      end

      def regenerate_all_markdown
        return unless yes?("\nRegenerate all markdown files from database?", :cyan)

        say 'Regenerating markdown files...', :cyan

        count = 0
        AwesomeList.active.completed.find_each do |list|
          categories_with_items = list.categories.joins(:category_items).distinct

          if categories_with_items.any?
            result = ProcessCategoryServiceEnhanced.new.call(awesome_list: list)
            count += 1 if result.success?
          end
        end

        say "✅ Regenerated #{count} markdown files", :green
      end

      def final_cleanup
        say "\n🧹 Final cleanup...", :cyan

        # Delete any remaining tiny files
        Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).each do |file|
          next if File.basename(file) == 'README.md'

          if File.size(file) < 100
            File.delete(file)
            say "  ✗ Deleted tiny file: #{File.basename(file)}", :red
          end
        end

        # Count final results
        total_files = Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).count - 1
        say "\n📊 Final count: #{total_files} markdown files", :green
      end

      def summary
        say "\n#{'=' * 50}", :green
        say '✅ Cleanup complete!', :green
        say '=' * 50, :green

        # Show stats
        total_lists = AwesomeList.active.count
        completed = AwesomeList.active.completed.count
        with_content = AwesomeList.active.joins(:categories).distinct.count
        files = Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).count - 1

        say "\n📊 Statistics:"
        say "  Total lists: #{total_lists}"
        say "  Completed: #{completed}"
        say "  With content: #{with_content}"
        say "  Markdown files: #{files}"
      end
    end
  end
end
