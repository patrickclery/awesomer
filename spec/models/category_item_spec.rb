# frozen_string_literal: true

# == Schema Information
#
# Table name: category_items
#
#  id                :bigint           not null, primary key
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
#  category_id       :integer          not null, indexed
#
# Indexes
#
#  index_category_items_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
require 'rails_helper'

RSpec.describe CategoryItem do
  let(:category) { Category.create!(awesome_list:, name: 'Test Category') }
  let(:awesome_list) { AwesomeList.create!(github_repo: 'test/repo', name: 'Test List') }

  describe 'validations' do
    example 'requires name to be present' do
      item = described_class.new(category:, primary_url: 'https://example.com')
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end

    example 'requires at least one of github_repo or primary_url to be present' do
      item = described_class.new(category:, name: 'Test Item')
      expect(item).not_to be_valid
      expect(item.errors[:base]).to include("At least one of GitHub repo or primary URL must be present")
    end

    example 'is valid with only primary_url' do
      item = described_class.new(
        category:,
        name: 'Test Item',
        primary_url: 'https://example.com'
      )
      expect(item).to be_valid
    end

    example 'is valid with only github_repo' do
      item = described_class.new(
        category:,
        github_repo: 'owner/repo',
        name: 'Test Item'
      )
      expect(item).to be_valid
    end

    example 'is valid with both github_repo and primary_url' do
      item = described_class.new(
        category:,
        github_repo: 'owner/repo',
        name: 'Test Item',
        primary_url: 'https://example.com'
      )
      expect(item).to be_valid
    end
  end

  describe 'associations' do
    example 'belongs to category' do
      item = described_class.create!(
        category:,
        name: 'Test Item',
        primary_url: 'https://example.com'
      )
      expect(item.category).to eq(category)
    end
  end

  describe '#repo_identifier' do
    context 'when github_repo is present' do
      example 'returns the github_repo value' do
        item = described_class.new(
          github_repo: 'owner/repo',
          primary_url: 'https://example.com'
        )
        expect(item.repo_identifier).to eq('owner/repo')
      end
    end

    context 'when github_repo is nil' do
      example 'returns nil' do
        item = described_class.new(
          github_repo: nil,
          primary_url: 'https://example.com'
        )
        expect(item.repo_identifier).to be_nil
      end
    end
  end

  describe 'database columns' do
    example 'has all expected attributes' do
      item = described_class.create!(
        category:,
        commits_past_year: 100,
        demo_url: 'https://demo.example.com',
        description: 'A test item',
        github_repo: 'owner/repo',
        last_commit_at: 1.day.ago,
        name: 'Test Item',
        primary_url: 'https://example.com',
        stars: 50
      )

      expect(item.name).to eq('Test Item')
      expect(item.primary_url).to eq('https://example.com')
      expect(item.github_repo).to eq('owner/repo')
      expect(item.demo_url).to eq('https://demo.example.com')
      expect(item.description).to eq('A test item')
      expect(item.commits_past_year).to eq(100)
      expect(item.last_commit_at).to be_within(1.second).of(1.day.ago)
      expect(item.stars).to eq(50)
    end
  end
end
