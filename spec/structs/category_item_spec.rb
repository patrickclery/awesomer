# frozen_string_literal: true

require 'rails_helper' # Or spec_helper, assuming it sets up the environment

# Note: Structs::CategoryItem is expected to be available via Rails eager loading.
# Dry::Struct and Dry::Monads should also be available.

RSpec.describe Structs::CategoryItem do
  # Copied from the nested describe block in category_spec.rb
  let(:time_now) { Time.now }
  let(:valid_attributes) { {name: 'Item', primary_url: 'https://example.com'} }
  let(:attributes_with_description) { valid_attributes.merge(description: "Test description") }

  example 'initializes with required attributes only' do
    item = described_class.new(valid_attributes)
    expect(item.name).to eq('Item')
    expect(item.primary_url).to eq('https://example.com')
    expect(item.description).to be_nil
    expect(item.github_repo).to be_nil
    expect(item.demo_url).to be_nil
    expect(item.commits_past_year).to be_nil
    expect(item.last_commit_at).to be_nil
    expect(item.stars).to be_nil
  end

  example 'initializes with description' do
    item = described_class.new(attributes_with_description)
    expect(item.name).to eq('Item')
    expect(item.primary_url).to eq('https://example.com')
    expect(item.description).to eq("Test description")
  end

  example 'initializes with all attributes including description' do
    all_attrs = attributes_with_description.merge(
      commits_past_year: 50,
      demo_url: 'https://demo.example.com',
      github_repo: 'owner/repo',
      last_commit_at: time_now,
      stars: 200
    )
    item = described_class.new(all_attrs)
    expect(item.name).to eq('Item')
    expect(item.primary_url).to eq('https://example.com')
    expect(item.description).to eq("Test description")
    expect(item.github_repo).to eq('owner/repo')
    expect(item.demo_url).to eq('https://demo.example.com')
    expect(item.commits_past_year).to eq(50)
    expect(item.last_commit_at).to be_within(1.second).of(time_now)
    expect(item.stars).to eq(200)
  end

  example 'raises error with missing required attributes (e.g., name)' do
    expect {
      # Using described_class here is correct as it refers to Structs::CategoryItem
      described_class.new(primary_url: 'https://example.com')
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
