# frozen_string_literal: true

class Repo < ApplicationRecord
  has_many :category_items
  has_many :star_snapshots, dependent: :destroy

  validates :github_repo, presence: true, uniqueness: true
end
