# frozen_string_literal: true

require 'rails_helper'

# Note: Structs::Category, Structs::CategoryItem, and ParseMarkdownOperation 
# are expected to be available via Rails eager loading.

RSpec.describe SyncGitStatsOperation do
  include Dry::Monads[:result] # Include monads for direct Success/Failure usage in tests

  subject(:operation_call) { described_class.new.call(categories: initial_categories) }

  let(:markdown_content) { File.read(Rails.root.join('spec/fixtures/awesome_self_hosted_snippet.md')) }
  let!(:initial_categories) do # Use let! to ensure ParseMarkdownOperation runs before mocks might be needed
    parse_result = ParseMarkdownOperation.new.call(markdown_content: markdown_content)
    raise "Failed to parse fixture: #{parse_result.failure}" if parse_result.failure?
    parse_result.value!
  end

  let(:stats_fetcher_mock) { instance_double('GithubStatsFetcherService') } # Assuming a class name

  before do
    App::Container.stub('services.github_stats_fetcher', stats_fetcher_mock)
  end

  # Identify GitHub items from the fixture based on ParseMarkdownOperation's output
  # Davis: https://github.com/tchapi/davis
  # Xandikos: https://github.com/jelmer/xandikos
  let(:davis_item_original) do
    initial_categories.first.repos.find { |item| item.url == 'https://github.com/tchapi/davis' }
  end
  let(:xandikos_item_original) do
    initial_categories.first.repos.find { |item| item.url == 'https://github.com/jelmer/xandikos' }
  end

  context 'when stats are fetched successfully' do
    let(:davis_stars) { 100 }
    let(:davis_last_commit_at) { Time.parse('2023-01-01T10:00:00Z') }
    let(:xandikos_stars) { 200 }
    let(:xandikos_last_commit_at) { Time.parse('2023-02-01T12:00:00Z') }

    before do
      allow(stats_fetcher_mock).to receive(:call)
        .with(owner: 'tchapi', repo: 'davis')
        .and_return(Success({ stars: davis_stars, last_commit_at: davis_last_commit_at }))
      
      allow(stats_fetcher_mock).to receive(:call)
        .with(owner: 'jelmer', repo: 'xandikos')
        .and_return(Success({ stars: xandikos_stars, last_commit_at: xandikos_last_commit_at }))
    end

    it 'returns a Success result' do
      expect(operation_call).to be_success
    end

    it 'updates stars and last_commit_at for GitHub items' do
      updated_categories = operation_call.value!
      updated_davis_item = updated_categories.first.repos.find { |item| item.id == davis_item_original.id }
      updated_xandikos_item = updated_categories.first.repos.find { |item| item.id == xandikos_item_original.id }

      expect(updated_davis_item.stars).to eq(davis_stars)
      expect(updated_davis_item.last_commit_at).to be_within(1.second).of(davis_last_commit_at)
      expect(updated_xandikos_item.stars).to eq(xandikos_stars)
      expect(updated_xandikos_item.last_commit_at).to be_within(1.second).of(xandikos_last_commit_at)
    end

    it 'creates new CategoryItem instances for updated items' do
      updated_categories = operation_call.value!
      updated_davis_item = updated_categories.first.repos.find { |item| item.id == davis_item_original.id }
      expect(updated_davis_item).not_to be(davis_item_original)
      expect(updated_davis_item.object_id).not_to eq(davis_item_original.object_id)
    end

    it 'keeps non-GitHub items unchanged' do
      updated_categories = operation_call.value!
      original_non_gh_item = initial_categories.first.repos.find { |item| item.url == 'https://sabre.io/baikal/' }
      updated_non_gh_item = updated_categories.first.repos.find { |item| item.id == original_non_gh_item.id }
      
      expect(updated_non_gh_item.stars).to be_nil # Was nil initially
      expect(updated_non_gh_item.last_commit_at).to be_nil # Was nil initially
      expect(updated_non_gh_item.name).to eq(original_non_gh_item.name)
      expect(updated_non_gh_item.url).to eq(original_non_gh_item.url)
      # It should be the same instance if not updated
      expect(updated_non_gh_item).to be(original_non_gh_item) 
    end

    it 'creates new Category instances if their items were updated' do
      updated_categories = operation_call.value!
      expect(updated_categories.first).not_to be(initial_categories.first)
    end
  end

  context 'when stats_fetcher fails for a repo' do
    before do
      allow(stats_fetcher_mock).to receive(:call)
        .with(owner: 'tchapi', repo: 'davis')
        .and_return(Failure('GitHub API error for davis'))
      # Xandikos might or might not be called depending on iteration order, 
      # but the operation should fail fast on the first Failure from yield.
    end

    it 'returns a Failure result' do
      expect(operation_call).to be_failure
    end

    it 'returns the error from the stats_fetcher' do
      expect(operation_call.failure).to eq('GitHub API error for davis')
    end
  end

  context 'when input categories array is empty' do
    let(:initial_categories) { [] }
    it 'returns Success with an empty array' do
      expect(operation_call).to be_success
      expect(operation_call.value!).to eq([])
    end
  end

  context 'when a category has no repos' do
    let(:initial_categories) { [Structs::Category.new(id: 1, name: "Empty Cat", custom_order: 0, repos: [])] }
    it 'returns Success with the category unchanged' do
      expect(operation_call).to be_success
      updated_category = operation_call.value!.first
      expect(updated_category.name).to eq "Empty Cat"
      expect(updated_category.repos).to be_empty
    end
  end
end 