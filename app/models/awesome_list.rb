# frozen_string_literal: true

# == Schema Information
#
# Table name: awesome_lists
#
#  id                  :integer          not null, primary key
#  description         :text
#  github_repo         :string           not null
#  last_commit_at      :datetime
#  name                :string           not null
#  skip_external_links :boolean          default(TRUE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class AwesomeList < ApplicationRecord
  validates :github_repo, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true
end
