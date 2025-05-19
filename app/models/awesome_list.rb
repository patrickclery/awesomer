# == Schema Information
#
# Table name: awesome_lists
#
#  id          :integer          not null, primary key
#  description :text
#  github_repo :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class AwesomeList < ApplicationRecord
end
