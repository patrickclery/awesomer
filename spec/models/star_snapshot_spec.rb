# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StarSnapshot do
  let(:repo) { create(:repo) }

  describe 'validations' do
    example 'requires repo' do
      snapshot = described_class.new(stars: 100, snapshot_date: Date.current)
      expect(snapshot).not_to be_valid
    end

    example 'requires stars' do
      snapshot = described_class.new(repo:, snapshot_date: Date.current)
      expect(snapshot).not_to be_valid
    end

    example 'requires snapshot_date' do
      snapshot = described_class.new(repo:, stars: 100)
      expect(snapshot).not_to be_valid
    end

    example 'enforces uniqueness of repo + snapshot_date' do
      described_class.create!(repo:, stars: 100, snapshot_date: Date.current)
      duplicate = described_class.new(repo:, stars: 200, snapshot_date: Date.current)
      expect(duplicate).not_to be_valid
    end

    example 'is valid with all required fields' do
      snapshot = described_class.new(repo:, stars: 100, snapshot_date: Date.current)
      expect(snapshot).to be_valid
    end
  end

  describe 'associations' do
    example 'belongs to repo' do
      snapshot = described_class.create!(repo:, stars: 100, snapshot_date: Date.current)
      expect(snapshot.repo).to eq(repo)
    end
  end
end
