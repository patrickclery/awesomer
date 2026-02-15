# frozen_string_literal: true

# Computes stars_30d and stars_90d on repos by diffing star_snapshots.
# Uses the most recent snapshot as "today" and finds the closest snapshot
# within a 3-day tolerance window for the comparison date.
class ComputeTrendingOperation
  include Dry::Monads[:result]

  PERIODS = [
    {column: :stars_7d, days: 7},
    {column: :stars_30d, days: 30},
    {column: :stars_90d, days: 90}
  ].freeze

  TOLERANCE_DAYS = 3

  def call
    counts = PERIODS.map do |period|
      updated = compute_and_update(column: period[:column], days: period[:days])
      {days: period[:days], updated:}
    end

    summary = counts.map { |c| "#{c[:updated]} repos (#{c[:days]}d)" }.join(', ')
    Success("Updated trending: #{summary}")
  rescue StandardError => e
    Rails.logger.error "ComputeTrendingOperation error: #{e.message}"
    Failure("Compute trending failed: #{e.message}")
  end

  private

  def compute_and_update(column:, days:)
    today = Date.current
    past_target = today - days
    updated = 0

    Repo.find_each do |repo|
      today_snap = repo.star_snapshots
        .where(snapshot_date: (today - TOLERANCE_DAYS + 1)..today)
        .order(snapshot_date: :desc)
        .first

      past_snap = repo.star_snapshots
        .where(snapshot_date: (past_target - TOLERANCE_DAYS + 1)..past_target)
        .order(snapshot_date: :desc)
        .first

      next unless today_snap && past_snap

      trending = today_snap.stars - past_snap.stars
      repo.update_column(column, trending)
      updated += 1
    end

    updated
  end
end
