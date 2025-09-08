# frozen_string_literal: true

class SyncAwesomeListsJob < ApplicationJob
  queue_as :default

  def perform(force: false)
    Rails.logger.info "SyncAwesomeListsJob: Starting sync job (force: #{force})"

    files_updated = []
    total_items_updated = 0

    # Find lists that need syncing (excluding archived)
    lists_to_sync = if force
                      AwesomeList.active.completed
                    else
                      AwesomeList.active.completed.needs_sync
                    end

    Rails.logger.info "Found #{lists_to_sync.count} lists to sync"

    lists_to_sync.find_each do |awesome_list|
      Rails.logger.info "Syncing #{awesome_list.github_repo}"

      # Run delta sync for this list
      delta_service = DeltaSyncService.new(awesome_list:)
      result = delta_service.call

      if result.success?
        sync_data = result.value!

        if sync_data[:items_updated] > 0
          total_items_updated += sync_data[:items_updated]

          # Regenerate markdown file if items were updated
          Rails.logger.info "Regenerating markdown for #{awesome_list.github_repo}"

          # Use enhanced processing with awesome_list object
          service = ProcessCategoryServiceEnhanced.new
          markdown_result = service.call(awesome_list:)

          if markdown_result.success?
            file_path = markdown_result.value!
            files_updated << file_path.to_s
            Rails.logger.info "Updated markdown file: #{file_path}"
          else
            Rails.logger.error "Failed to generate markdown: #{markdown_result.failure}"
          end
        end
      else
        Rails.logger.error "Delta sync failed for #{awesome_list.github_repo}: #{result.failure}"
      end
    end

    # Push changes to GitHub if any files were updated
    if files_updated.any?
      Rails.logger.info "Pushing #{files_updated.count} updated files to GitHub"

      push_service = GithubPushService.new(files_changed: files_updated)
      push_result = push_service.call

      if push_result.success?
        push_data = push_result.value!
        Rails.logger.info "Successfully pushed to GitHub: #{push_data[:commit_sha]}"
      else
        Rails.logger.error "Failed to push to GitHub: #{push_result.failure}"
      end
    else
      Rails.logger.info 'No files were updated, skipping GitHub push'
    end

    Rails.logger.info "SyncAwesomeListsJob completed: #{total_items_updated} items updated across #{files_updated.count} files"
  end
end
