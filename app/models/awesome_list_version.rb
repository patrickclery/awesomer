# == Schema Information
#
# Table name: awesome_list_versions
#
#  id                :integer          not null, primary key
#  category_count    :integer
#  commits_past_year :integer
#  last_commit_at    :datetime
#  repo_count        :integer
#  stars             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  awesome_list_id   :integer          not null
#
# Indexes
#
#  index_awesome_list_versions_on_awesome_list_id  (awesome_list_id)
#
# Foreign Keys
#
#  awesome_list_id  (awesome_list_id => awesome_lists.id)
#
class AwesomeListVersion < ApplicationRecord
  belongs_to :awesome_list
end
