# frozen_string_literal: true

# == Schema Information
#
# Table name: category_items
#
#  id                :integer          not null, primary key
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
#  category_id       :integer          not null
#
# Indexes
#
#  index_category_items_on_category_id  (category_id)
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#
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
