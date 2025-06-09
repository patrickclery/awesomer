# frozen_string_literal: true

# == Schema Information
#
# Table name: github_api_requests
#
#  id              :bigint           not null, primary key
#  endpoint        :string
#  owner           :string
#  repo            :string
#  requested_at    :datetime
#  response_status :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class GithubApiRequest < ApplicationRecord
  validates :endpoint, presence: true
  validates :requested_at, presence: true
  validates :response_status, presence: true

  scope :recent, ->(hours = 1) { where(requested_at: hours.hours.ago..Time.current) }
  scope :successful, -> { where(response_status: 200..299) }
  scope :failed, -> { where.not(response_status: 200..299) }

  def self.within_rate_limit?(limit: 4000, window_hours: 1)
    recent(window_hours).count < limit
  end

  def self.time_until_reset(limit: 4000, window_hours: 1)
    oldest_in_window = recent(window_hours).order(:requested_at).first
    return 0 unless oldest_in_window

    window_end = oldest_in_window.requested_at + window_hours.hours
    [ (window_end - Time.current).to_i, 0 ].max
  end
end
