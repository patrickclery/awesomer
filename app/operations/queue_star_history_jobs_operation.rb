# frozen_string_literal: true

# Queues FetchStarHistoryJob for eligible CategoryItems in an AwesomeList.
# Filters out items that don't have GitHub repos, have too many stars,
# or were recently fetched.
class QueueStarHistoryJobsOperation
  include Dry::Monads[:result]

  # Max stars threshold - repos above this are too expensive to fetch history for
  MAX_STARS_FOR_HISTORY = FetchStarHistoryJob::MAX_STARS_FOR_HISTORY

  def call(awesome_list:)
    return Failure('AwesomeList is required') unless awesome_list

    items = awesome_list.categories.flat_map(&:category_items)
                        .select { |item| eligible_for_history?(item) }

    if items.empty?
      Rails.logger.info "QueueStarHistoryJobsOperation: No eligible items for #{awesome_list.github_repo}"
      return Success(queued: 0)
    end

    queued_count = 0

    items.each do |item|
      FetchStarHistoryJob.perform_later(category_item_id: item.id)
      queued_count += 1
    end

    Rails.logger.info "QueueStarHistoryJobsOperation: Queued #{queued_count} star history jobs " \
                      "for #{awesome_list.github_repo}"

    Success(queued: queued_count)
  end

  private

  def eligible_for_history?(item)
    # Must have a GitHub repo
    return false if item.github_repo.blank?

    # Skip if we've fetched recently
    return false if item.star_history_fetched_at.present? && item.star_history_fetched_at > 1.week.ago

    # Skip repos with too many stars (too expensive)
    return false if item.stars.present? && item.stars > MAX_STARS_FOR_HISTORY

    true
  end
end
