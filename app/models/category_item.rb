# frozen_string_literal: true

# == Schema Information
#
# Table name: category_items
#
#  id                :bigint           not null, primary key
#  commits_past_year :integer
#  demo_url          :string
#  description       :text
#  github_repo       :string
#  last_commit_at    :datetime
#  name              :string
#  primary_url       :string
#  stars             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  category_id       :integer          not null, indexed
#
# Indexes
#
#  index_category_items_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
class CategoryItem < ApplicationRecord
  belongs_to :category

  validates :name, presence: true
  validate :validate_at_least_one_url_present

  # Scopes
  scope :needing_update, ->(threshold = 10) {
    where.not(stars: nil).where(
      "previous_stars IS NULL OR ABS(stars - previous_stars) >= ?", threshold
    )
  }

  # Extract repository identifier from GitHub URL
  def repo_identifier
    github_repo
  end

  # Delta tracking methods
  def star_delta
    return 0 if stars.nil? || previous_stars.nil?
    stars - previous_stars
  end

  def needs_update?(threshold = 10)
    return true if previous_stars.nil? && stars.present?
    star_delta.abs >= threshold
  end

  def update_previous_stars!
    update_column(:previous_stars, stars)
  end

  private

  def validate_at_least_one_url_present
    if github_repo.blank? && primary_url.blank?
      errors.add(:base, "At least one of GitHub repo or primary URL must be present")
    end
  end
end
