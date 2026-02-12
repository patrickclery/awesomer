# frozen_string_literal: true

class StarSnapshot < ApplicationRecord
  belongs_to :repo

  validates :stars, presence: true
  validates :snapshot_date, presence: true
  validates :repo_id, uniqueness: { scope: :snapshot_date }
end
