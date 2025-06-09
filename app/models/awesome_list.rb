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

  # AASM state machine for processing status
  aasm column: :state, enum: true do
    state :pending, initial: true
    state :in_progress
    state :completed
    state :failed

    event :start_processing do
      transitions from: %i[pending failed], to: :in_progress
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
  scope :incomplete, -> { where.not(state: :completed) }
  scope :failed_or_incomplete, -> { where(state: %i[pending in_progress failed]) }
  scope :processing_timeout, ->(timeout = 1.hour.ago) {
    where(processing_started_at: ...timeout, state: :in_progress)
  }
end
