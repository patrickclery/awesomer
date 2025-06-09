# frozen_string_literal: true

# == Schema Information
#
# Table name: awesome_lists
#
#  id                      :bigint           not null, primary key
#  description             :text
#  github_repo             :string           not null
#  last_commit_at          :datetime
#  name                    :string           not null
#  processing_completed_at :datetime
#  processing_started_at   :datetime
#  skip_external_links     :boolean          default(TRUE), not null
#  state                   :integer          default(0), not null, indexed
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_awesome_lists_on_state  (state)
#
class AwesomeList < ApplicationRecord
  validates :github_repo, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true

  has_many :categories, dependent: :destroy
end
