# frozen_string_literal: true

require 'rails_helper'
# VCR is usually required in spec_helper or rails_helper
# require 'vcr' 

# Note: Structs::Category, Structs::CategoryItem, and ParseMarkdownOperation 
# are expected to be available via Rails eager loading.

RSpec.describe SyncGitStatsOperation, :vcr do # Apply VCR to all examples in this describe block
  include Dry::Monads[:result] # Include monads for direct Success/Failure usage in tests

  subject(:operation_call) { described_class.new.call(categories: initial_categories) }

  let(:markdown_content) { File.read(Rails.root.join('spec/fixtures/awesome_self_hosted_snippet.md')) }
  let!(:initial_categories) do # Use let! to ensure ParseMarkdownOperation runs before mocks might be needed
    parse_result = ParseMarkdownOperation.new.call(markdown_content: markdown_content)
    # Allow parsing to fail if fixture is bad, but this spec focuses on SyncGitStatsOperation
    parse_result.success? ? parse_result.value! : [] 
  end

  # Removed stats_fetcher_mock and App::Container.stub

  # Identify GitHub items from the fixture based on ParseMarkdownOperation's output
  # Davis: https://github.com/tchapi/davis
  # Xandikos: https://github.com/jelmer/xandikos
  let(:davis_item_original) do
    # Ensure initial_categories is not empty and has a first element
    return nil if initial_categories.empty? || initial_categories.first.repos.empty?
    initial_categories.first.repos.find { |item| item.url == 'https://github.com/tchapi/davis' }
  end
  let(:xandikos_item_original) do
    return nil if initial_categories.empty? || initial_categories.first.repos.empty?
    initial_categories.first.repos.find { |item| item.url == 'https://github.com/jelmer/xandikos' }
  end

  context 'when stats are fetched successfully' do
    # IMPORTANT: The expected values below will need to be updated after the first VCR recording
    # to match the actual data returned by the GitHub API for these repositories.
    # For now, they are placeholders.
    let(:expected_davis_stars) { 100 } # Placeholder, update after recording
    let(:expected_davis_last_commit_at) { Time.parse('2023-01-01T10:00:00Z') } # Placeholder
    let(:expected_xandikos_stars) { 200 } # Placeholder
    let(:expected_xandikos_last_commit_at) { Time.parse('2023-02-01T12:00:00Z') } # Placeholder

    # No mock setup needed for stats_fetcher_mock anymore

    it 'returns a Success result' do
      # Ensure items are found before running the test that depends on them
      skip("Davis item not found in fixture") unless davis_item_original
      skip("Xandikos item not found in fixture") unless xandikos_item_original
      VCR.use_cassette('github_stats/successful_fetch') do
        expect(operation_call).to be_success
      end
    end

    it 'updates stars and last_commit_at for GitHub items' do
      skip("Davis item not found in fixture") unless davis_item_original
      skip("Xandikos item not found in fixture") unless xandikos_item_original
      
      updated_categories = nil
      VCR.use_cassette('github_stats/successful_fetch') do # Use the same cassette name
        updated_categories = operation_call.value!
      end

      updated_davis_item = updated_categories.first.repos.find { |item| item.id == davis_item_original.id }
      updated_xandikos_item = updated_categories.first.repos.find { |item| item.id == xandikos_item_original.id }

      # These expectations will likely fail until cassettes are recorded and values are updated.
      expect(updated_davis_item.stars).to eq(expected_davis_stars) # Or use be_a(Integer)
      expect(updated_davis_item.last_commit_at).to be_within(1.hour).of(expected_davis_last_commit_at) # Or use be_a(Time)
      expect(updated_xandikos_item.stars).to eq(expected_xandikos_stars) # Or use be_a(Integer)
      expect(updated_xandikos_item.last_commit_at).to be_within(1.hour).of(expected_xandikos_last_commit_at) # Or use be_a(Time)
    end

    it 'creates new CategoryItem instances for updated items' do
      skip("Davis item not found in fixture") unless davis_item_original
      VCR.use_cassette('github_stats/successful_fetch_for_instance_check') do # Potentially different interactions or same
        updated_categories = operation_call.value!
        updated_davis_item = updated_categories.first.repos.find { |item| item.id == davis_item_original.id }
        expect(updated_davis_item).not_to be(davis_item_original)
        expect(updated_davis_item.object_id).not_to eq(davis_item_original.object_id)
      end
    end

    it 'keeps non-GitHub items unchanged' do
      original_non_gh_item = initial_categories.first.repos.find { |item| item.url == 'https://sabre.io/baikal/' }
      skip("Non-GitHub item Baikal not found in fixture") unless original_non_gh_item
      
      VCR.use_cassette('github_stats/non_github_item_check') do # This cassette won't record GH calls for Baikal
        updated_categories = operation_call.value!
        updated_non_gh_item = updated_categories.first.repos.find { |item| item.id == original_non_gh_item.id }
        
        expect(updated_non_gh_item.stars).to be_nil 
        expect(updated_non_gh_item.last_commit_at).to be_nil 
        expect(updated_non_gh_item.name).to eq(original_non_gh_item.name)
        expect(updated_non_gh_item.url).to eq(original_non_gh_item.url)
        expect(updated_non_gh_item).to be(original_non_gh_item) 
      end
    end

    it 'creates new Category instances if their items were updated' do
      skip("Test requires at least one category in fixture") if initial_categories.empty?
      VCR.use_cassette('github_stats/category_instance_check') do
        updated_categories = operation_call.value!
        expect(updated_categories.first).not_to be(initial_categories.first)
      end
    end
  end

  context 'when GitHub API returns an error for a repo (e.g., 404 Not Found)' do
    # For this test, we want to ensure fetch_repo_stats returns a Failure
    # VCR will record the 404 response from GitHub for a non-existent repo.
    # We modify one of the URLs in `initial_categories` or create a specific category for this.
    let(:categories_with_bad_repo) do
      # Create a new category list with one item pointing to a non-existent GitHub repo
      bad_item = Structs::CategoryItem.new(id: 999, name: "NonExistent", url: "https://github.com/nonexistent-owner/nonexistent-repo")
      original_category = initial_categories.first
      # Ensure original_category is not nil before trying to access its attributes
      if original_category
        [original_category.new(repos: [bad_item] + original_category.repos)]
      else
        # Fallback if initial_categories was empty or malformed from parsing, create a dummy
        [Structs::Category.new(name: "Test Cat", custom_order: 0, repos: [bad_item])]
      end
    end

    subject(:operation_call_with_bad_repo) { described_class.new.call(categories: categories_with_bad_repo) }

    it 'returns a Failure result' do
      VCR.use_cassette('github_stats/repo_not_found') do
        expect(operation_call_with_bad_repo).to be_failure
      end
    end

    it 'returns an error message indicating the repo was not found' do
      VCR.use_cassette('github_stats/repo_not_found') do
        # The exact message comes from our `fetch_repo_stats` method
        expect(operation_call_with_bad_repo.failure).to eq('GitHub repository not found: nonexistent-owner/nonexistent-repo')
      end
    end
  end

  context 'when input categories array is empty' do
    let(:initial_categories) { [] }
    it 'returns Success with an empty array' do
      # No VCR needed as no API calls will be made
      expect(operation_call).to be_success
      expect(operation_call.value!).to eq([])
    end
  end

  context 'when a category has no repos' do
    let(:initial_categories) { [Structs::Category.new(name: "Empty Cat", custom_order: 0, repos: [])] }
    it 'returns Success with the category unchanged' do
      # No VCR needed
      expect(operation_call).to be_success
      updated_category = operation_call.value!.first
      expect(updated_category.name).to eq "Empty Cat"
      expect(updated_category.repos).to be_empty
    end
  end
end 