# frozen_string_literal: true

# require 'dry-struct' # Dry::Struct should be available globally or via rails_helper
# require_relative '../app/structs/category' # Rely on eager_load!
# require_relative '../app/structs/category_item' # Rely on eager_load!

RSpec.describe Structs::Category do
  let(:time_now) { Time.now }
  let(:item1) { Structs::CategoryItem.new(commits_past_year: 10, id: 1, last_commit_at: time_now, name: 'Item One', stars: 100, url: 'https://example.com/one') }
  let(:item2) { Structs::CategoryItem.new(id: 2, name: 'Item Two', url: 'https://example.com/two') }

  example 'initializes with valid attributes' do
    category = described_class.new(custom_order: 1, name: 'Utilities', repos: [ item1, item2 ])
    expect(category.name).to eq('Utilities')
    expect(category.repos).to match_array([ item1, item2 ])
    expect(category.custom_order).to eq(1)
  end

  example 'raises error with invalid name type' do
    expect {
      described_class.new(custom_order: 1, name: 123, repos: [ item1 ])
    }.to raise_error(Dry::Struct::Error)
  end

  example 'raises error with invalid repos type' do
    expect {
      described_class.new(custom_order: 1, name: 'Utilities', repos: [ 'not_an_item' ])
    }.to raise_error(Dry::Struct::Error)
  end

  example 'raises error with invalid custom_order type' do
    expect {
      described_class.new(custom_order: 'one', name: 'Utilities', repos: [ item1 ])
    }.to raise_error(Dry::Struct::Error)
  end

  example 'allows empty repos array' do
    category = described_class.new(custom_order: 0, name: 'Empty', repos: [])
    expect(category.repos).to eq([])
    expect(category.custom_order).to eq(0)
  end
end

RSpec.describe Structs::CategoryItem do
  let(:time_now) { Time.now }
  let(:valid_attributes) { {id: 1, name: 'Item', url: 'https://example.com'} }

  example 'initializes with required attributes only' do
    item = described_class.new(valid_attributes)
    expect(item.id).to eq(1)
    expect(item.name).to eq('Item')
    expect(item.url).to eq('https://example.com')
    expect(item.commits_past_year).to be_nil
    expect(item.last_commit_at).to be_nil
    expect(item.stars).to be_nil
  end

  example 'initializes with all attributes' do
    item = described_class.new(valid_attributes.merge(commits_past_year: 50, last_commit_at: time_now, stars: 200))
    expect(item.id).to eq(1)
    expect(item.name).to eq('Item')
    expect(item.url).to eq('https://example.com')
    expect(item.commits_past_year).to eq(50)
    expect(item.last_commit_at).to be_within(1.second).of(time_now)
    expect(item.stars).to eq(200)
  end

  example 'raises error with invalid id type' do
    expect {
      described_class.new(valid_attributes.merge(id: 'one'))
    }.to raise_error(Dry::Struct::Error)
  end

  example 'raises error with missing required attributes (e.g., name)' do
    expect {
      described_class.new(id: 1, url: 'https://example.com')
    }.to raise_error(Dry::Struct::Error, /:name is missing/)
  end

  example 'raises error with invalid commits_past_year type' do
    expect {
      described_class.new(valid_attributes.merge(commits_past_year: 'many'))
    }.to raise_error(Dry::Struct::Error)
  end

  example 'raises error with invalid last_commit_at type' do
    expect {
      described_class.new(valid_attributes.merge(last_commit_at: 'yesterday'))
    }.to raise_error(Dry::Struct::Error)
  end

  example 'raises error with invalid stars type' do
    expect {
      described_class.new(valid_attributes.merge(stars: 'lots'))
    }.to raise_error(Dry::Struct::Error)
  end
end
