# frozen_string_literal: true

# == Schema Information
#
# Table name: repo_stats
#
#  id                :integer          not null, primary key
#  commits_past_year :integer
#  last_commit_at    :datetime
#  stars             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  awesome_list_id   :integer          not null
#
# Indexes
#
#  index_repo_stats_on_awesome_list_id  (awesome_list_id)
#
# Foreign Keys
#
#  awesome_list_id  (awesome_list_id => awesome_lists.id)
#
class RepoStat < ApplicationRecord
  belongs_to :awesome_list
end
