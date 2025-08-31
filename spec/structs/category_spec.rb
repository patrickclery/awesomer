# frozen_string_literal: true

# require 'dry-struct' # Dry::Struct should be available globally or via rails_helper
# require_relative '../app/structs/category' # Rely on eager_load!
# require_relative '../app/structs/category_item' # Rely on eager_load!

RSpec.describe Structs::Category do
  let(:time_now) { Time.now }
  let(:item1) do
    Structs::CategoryItem.new(
      commits_past_year: 10,
      last_commit_at: time_now,
      name: 'Item One',
      primary_url: 'https://example.com/one',
      stars: 100
    )
  end
  let(:item2) { Structs::CategoryItem.new(name: 'Item Two', primary_url: 'https://example.com/two') }

  example 'initializes with valid attributes' do
    category = described_class.new(custom_order: 1, name: 'Utilities', repos: [item1, item2])
    expect(category.name).to eq('Utilities')
    expect(category.repos).to match_array([item1, item2])
    expect(category.custom_order).to eq(1)
  end

  example 'raises error with invalid name type' do
    expect do
      described_class.new(custom_order: 1, name: 123, repos: [item1])
    end.to raise_error(Dry::Struct::Error)
  end

  example 'raises error with invalid repos type' do
    expect do
      described_class.new(custom_order: 1, name: 'Utilities', repos: ['not_an_item'])
    end.to raise_error(Dry::Struct::Error)
  end

  example 'raises error with invalid custom_order type' do
    expect do
      described_class.new(custom_order: 'one', name: 'Utilities', repos: [item1])
    end.to raise_error(Dry::Struct::Error)
  end

  example 'allows empty repos array' do
    category = described_class.new(custom_order: 0, name: 'Empty', repos: [])
    expect(category.repos).to eq([])
    expect(category.custom_order).to eq(0)
  end
end
