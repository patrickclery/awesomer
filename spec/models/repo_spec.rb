# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo do
  describe 'validations' do
    example 'requires github_repo to be present' do
      repo = described_class.new(github_repo: nil)
      expect(repo).not_to be_valid
      expect(repo.errors[:github_repo]).to include("can't be blank")
    end

    example 'requires github_repo to be unique' do
      described_class.create!(github_repo: 'owner/repo')
      duplicate = described_class.new(github_repo: 'owner/repo')
      expect(duplicate).not_to be_valid
    end

    example 'is valid with just github_repo' do
      repo = described_class.new(github_repo: 'owner/repo')
      expect(repo).to be_valid
    end
  end

  describe 'associations' do
    example 'has many category_items' do
      expect(described_class.reflect_on_association(:category_items).macro).to eq(:has_many)
    end

    example 'has many star_snapshots' do
      expect(described_class.reflect_on_association(:star_snapshots).macro).to eq(:has_many)
    end
  end
end
