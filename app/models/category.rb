# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  repo_count      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  awesome_list_id :integer          not null, indexed
#  parent_id       :integer          indexed
#
# Indexes
#
#  index_categories_on_awesome_list_id  (awesome_list_id)
#  index_categories_on_parent_id        (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (awesome_list_id => awesome_lists.id)
#  fk_rails_...  (parent_id => categories.id)
#
class Category < ApplicationRecord
  belongs_to :awesome_list
  belongs_to :parent, class_name: "Category", optional: true
  has_many :category_items, dependent: :destroy
end
