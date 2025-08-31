# frozen_string_literal: true

class SyncLog < ApplicationRecord
  belongs_to :awesome_list

  # Status constants
  STATUSES = {
    completed: 'completed',
    failed: 'failed',
    partial: 'partial',
    started: 'started'
  }.freeze

  validates :status, inclusion: {in: STATUSES.values}
  validates :started_at, presence: true

  scope :completed, -> { where(status: STATUSES[:completed]) }
  scope :failed, -> { where(status: STATUSES[:failed]) }
  scope :recent, -> { order(started_at: :desc) }

  def duration
    return nil unless started_at && completed_at

    completed_at - started_at
  end

  def success?
    status == STATUSES[:completed]
  end

  def failed?
    status == STATUSES[:failed]
  end
end
