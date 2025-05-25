# frozen_string_literal: true

class CategoryItem < ApplicationRecord
  belongs_to :category

  validates :name, presence: true
  validate :at_least_one_url_present

  # Extract repository identifier from GitHub URL
  def repo_identifier
    github_repo
  end

  private

  def at_least_one_url_present
    if github_repo.blank? && primary_url.blank?
      errors.add(:base, "At least one of GitHub repo or primary URL must be present")
    end
  end
end
