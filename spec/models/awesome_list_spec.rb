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
require 'rails_helper'

RSpec.describe AwesomeList, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:github_repo).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:last_commit_at).of_type(:datetime) } # For README last commit
    it { is_expected.to have_db_column(:skip_external_links).of_type(:boolean).with_options(default: true, null: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe 'validations' do
    subject { described_class.new(github_repo: "owner/repo", name: "repo") }

    it { is_expected.to validate_presence_of(:github_repo) }
    it { is_expected.to validate_uniqueness_of(:github_repo).case_insensitive }
    it { is_expected.to validate_presence_of(:name) }
    # skip_external_links has a default and null:false, so presence isn't typically validated explicitly for booleans
  end

  describe 'default values' do
    it 'defaults skip_external_links to true' do
      new_list = described_class.new
      expect(new_list.skip_external_links).to be(true)
    end
  end
end
