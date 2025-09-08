# frozen_string_literal: true

class ReprocessEmptyListsService
  include Dry::Monads[:result, :do]

  MAX_RETRIES = 3
  RETRY_DELAY = 2 # seconds

  def call
    Rails.logger.info 'ReprocessEmptyListsService: Starting reprocessing of empty lists'

    # Find lists that need reprocessing
    empty_lists = find_empty_lists
    failed_lists = find_failed_lists
    small_files = find_small_files

    all_to_process = (empty_lists + failed_lists + small_files).uniq

    Rails.logger.info "ReprocessEmptyListsService: Found #{all_to_process.count} lists to reprocess"

    results = {
      deleted: 0,
      failed: 0,
      success: 0
    }

    all_to_process.each do |list|
      result = reprocess_list(list)

      case result
      when :success
        results[:success] += 1
      when :deleted
        results[:deleted] += 1
      else
        results[:failed] += 1
      end
    end

    Rails.logger.info "ReprocessEmptyListsService: Completed - Success: #{results[:success]}, Deleted: #{results[:deleted]}, Failed: #{results[:failed]}"

    # Clean up any remaining empty files
    cleanup_empty_files

    Success(results)
  end

  private

  def find_empty_lists
    # Lists with no categories
    AwesomeList.active
      .left_joins(:categories)
      .group('awesome_lists.id')
      .having('COUNT(categories.id) = 0')
  end

  def find_failed_lists
    # Lists in failed state
    AwesomeList.active.where(state: 'failed')
  end

  def find_small_files
    # Lists whose generated files are too small
    lists = []

    Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).each do |file|
      next if File.basename(file) == 'README.md'

      next unless File.size(file) < 200 # Less than 200 bytes is likely empty

      # Find the corresponding AwesomeList
      filename = File.basename(file, '.md')
      list = AwesomeList.active.where('github_repo LIKE ?', "%#{filename}").first
      lists << list if list
    end

    lists
  end

  def reprocess_list(list)
    Rails.logger.info "ReprocessEmptyListsService: Reprocessing #{list.github_repo}"

    retries = 0

    begin
      # Reset state to pending
      list.update!(state: 'pending')

      # Try to process with sync
      service = ProcessAwesomeListService.new(
        repo_identifier: list.github_repo,
        sync: true # Force sync to get stats
      )

      result = service.call

      if result.success?
        # Check if we actually got content
        categories_with_items = list.reload.categories.joins(:category_items).distinct

        if categories_with_items.any?
          # Generate the markdown file
          ProcessCategoryServiceEnhanced.new.call(awesome_list: list)
          Rails.logger.info "ReprocessEmptyListsService: Successfully reprocessed #{list.github_repo}"
          :success
        else
          # Still no content, delete the file
          cleanup_file_for_list(list)
          :deleted
        end
      else
        Rails.logger.warn "ReprocessEmptyListsService: Failed to reprocess #{list.github_repo}: #{result.failure}"
        :failed
      end
    rescue StandardError => e
      retries += 1

      if retries < MAX_RETRIES
        Rails.logger.info "ReprocessEmptyListsService: Retry #{retries}/#{MAX_RETRIES} for #{list.github_repo}"
        sleep(RETRY_DELAY * retries) # Exponential backoff
        retry
      else
        Rails.logger.error "ReprocessEmptyListsService: Max retries reached for #{list.github_repo}: #{e.message}"
        :failed
      end
    end
  end

  def cleanup_file_for_list(list)
    filename = "#{list.github_repo.split('/').last}.md"
    file_path = Rails.root.join('static', 'awesomer', filename)

    return unless File.exist?(file_path)

    File.delete(file_path)
    Rails.logger.info "ReprocessEmptyListsService: Deleted empty file #{file_path}"
  end

  def cleanup_empty_files
    Dir.glob(Rails.root.join('static', 'awesomer', '*.md')).each do |file|
      next if File.basename(file) == 'README.md'

      # Check file size and content
      next unless File.size(file) < 100

      content = File.read(file)
      # If file only has headers or is essentially empty
      if content.lines.count < 3 || content.strip.empty?
        File.delete(file)
        Rails.logger.info "ReprocessEmptyListsService: Deleted empty file #{file}"
      end
    end
  end
end
