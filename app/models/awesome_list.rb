# frozen_string_literal: true

# == Schema Information
#
# Table name: awesome_lists
#
#  id                      :bigint           not null, primary key
#  description             :text
#  github_repo             :string           not null
#  last_commit_at          :datetime
#  name                    :string           not null
#  processing_completed_at :datetime
#  processing_started_at   :datetime
#  skip_external_links     :boolean          default(TRUE), not null
#  state                   :integer          default(0), not null, indexed
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_awesome_lists_on_state  (state)
#
class AwesomeList < ApplicationRecord
  include AASM

  validates :github_repo, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true

  has_many :categories, dependent: :destroy
  has_many :sync_logs, dependent: :destroy
  has_many :category_items, through: :categories

  # AASM state machine for processing status
  aasm column: :state do
    state :pending, initial: true
    state :in_progress
    state :completed
    state :failed

    event :start_processing do
      transitions from: %i[pending failed completed in_progress], to: :in_progress
      after do
        update_columns(
          processing_completed_at: nil,
          processing_started_at: Time.current
        )
      end
    end

    event :complete_processing do
      transitions from: :in_progress, to: :completed
      after do
        update_columns(processing_completed_at: Time.current)
      end
    end

    event :fail_processing do
      transitions from: :in_progress, to: :failed
      after do
        update_columns(processing_completed_at: Time.current)
      end
    end

    event :reset_for_reprocessing do
      transitions from: %i[completed failed in_progress], to: :pending
      after do
        update_columns(
          processing_completed_at: nil,
          processing_started_at: nil
        )
      end
    end
  end

  # Scopes for filtering
  scope :incomplete, -> { where.not(state: 'completed') }
  scope :failed_or_incomplete, -> { where(state: %w[pending in_progress failed]) }
  scope :processing_timeout, lambda { |timeout = 1.hour.ago|
    where(processing_started_at: ...timeout, state: 'in_progress')
  }
  scope :needs_sync, -> { where(last_synced_at: nil).or(where(last_synced_at: ..1.day.ago)) }
  scope :with_sync_threshold, -> { where.not(sync_threshold: nil) }
  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :stale, ->(days = 365) { where(updated_at: ..days.days.ago) }

  def needs_sync?
    last_synced_at.nil? || last_synced_at < 1.day.ago
  end

  def sync_threshold_value
    sync_threshold || 10
  end

  def last_successful_sync
    sync_logs.completed.recent.first
  end

  def sync_in_progress?
    sync_logs.where(status: 'started').exists?
  end

  def archive!
    update!(archived: true, archived_at: Time.current) unless archived?
  end

  def unarchive!
    update!(archived: false, archived_at: nil) if archived?
  end

  def stale?(days = 365)
    updated_at < days.days.ago
  end
end
