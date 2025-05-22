# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  repo_count      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  awesome_list_id :integer          not null
#  parent_id       :integer
#
# Indexes
#
#  index_categories_on_awesome_list_id  (awesome_list_id)
#  index_categories_on_parent_id        (parent_id)
#
# Foreign Keys
#
#  awesome_list_id  (awesome_list_id => awesome_lists.id)
#  parent_id        (parent_id => categories.id)
#
class Category < ApplicationRecord
  belongs_to :awesome_list_version
  belongs_to :parent
end
