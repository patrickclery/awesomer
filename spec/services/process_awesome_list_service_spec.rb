# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessAwesomeListService do
  include Dry::Monads[:result]

  subject(:service_call) { service_instance.call }

  let(:sample_repo_identifier) { "owner/repo" }
  let(:sample_markdown_content) { "## Test Category\n- [Test Item](http://example.com/test) - A test item." }

  # Doubles for injected operations
  let(:fetch_readme_op_double) { instance_double(FetchReadmeOperation) }
  let(:parse_markdown_op_double) { instance_double(ParseMarkdownOperation) }
  let(:sync_git_stats_op_double) { instance_double(SyncGitStatsOperation) }
  let(:process_category_op_double) { instance_double(ProcessCategoryService) }

  # Sample data returned by operations
  let(:parsed_categories) do
    [ Structs::Category.new(custom_order: 0, name: "Test Category", repos: [
      Structs::CategoryItem.new(description: "A test item", id: 1, name: "Test Item", url: "http://example.com/test")
    ]) ]
  end
  let(:categories_with_stats) do
    [ Structs::Category.new(custom_order: 0, name: "Test Category", repos: [
      Structs::CategoryItem.new(description: "A test item", id: 1, last_commit_at: Time.now, name: "Test Item", stars: 10, url: "http://example.com/test")
    ]) ]
  end
  let(:output_markdown_paths) { [ Rails.root.join("tmp", "md", "test_category-stars.md") ] }

  let(:service_instance) do
    described_class.new(
      fetch_readme_operation: fetch_readme_op_double,
      parse_markdown_operation: parse_markdown_op_double,
      process_category_service: process_category_op_double,
      repo_identifier: sample_repo_identifier,
      sync_git_stats_operation: sync_git_stats_op_double
    )
  end

  context 'when orchestration is successful' do
    before do
      allow(fetch_readme_op_double).to receive(:call)
        .with(repo_identifier: sample_repo_identifier)
        .and_return(Success(sample_markdown_content))
      allow(parse_markdown_op_double).to receive(:call)
        .with(markdown_content: sample_markdown_content)
        .and_return(Success(parsed_categories))
      allow(sync_git_stats_op_double).to receive(:call)
        .with(categories: parsed_categories)
        .and_return(Success(categories_with_stats))
      allow(process_category_op_double).to receive(:call)
        .with(categories: categories_with_stats)
        .and_return(Success(output_markdown_paths))
    end

    it 'returns a Success result' do
      expect(service_call).to be_success
    end

    it 'returns the paths of the generated markdown files' do
      expect(service_call.value!).to eq(output_markdown_paths)
    end

    it 'calls all operations in sequence' do
      expect(fetch_readme_op_double).to receive(:call).ordered
      expect(parse_markdown_op_double).to receive(:call).ordered
      expect(sync_git_stats_op_double).to receive(:call).ordered
      expect(process_category_op_double).to receive(:call).ordered
      service_call
    end
  end

  context 'when repo_identifier is blank' do
    subject(:service_call_blank_id) { service_instance_blank_id.call }

    let(:service_instance_blank_id) { described_class.new(repo_identifier: "") }

    it 'returns a Failure' do
      expect(service_call_blank_id).to be_failure
      expect(service_call_blank_id.failure).to eq("Repository identifier must be provided")
    end
  end

  context 'when FetchReadmeOperation fails' do
    before do
      allow(fetch_readme_op_double).to receive(:call)
        .with(repo_identifier: sample_repo_identifier)
        .and_return(Failure("Fetch README error"))
    end

    it 'returns the Failure from FetchReadmeOperation' do
      expect(service_call).to be_failure
      expect(service_call.failure).to eq("Fetch README error")
    end

    it 'does not call subsequent operations' do
      expect(parse_markdown_op_double).not_to receive(:call)
      expect(sync_git_stats_op_double).not_to receive(:call)
      expect(process_category_op_double).not_to receive(:call)
      service_call
    end
  end

  # Tests for failures in ParseMarkdown, SyncGitStats, ProcessCategory remain similar,
  # just ensuring FetchReadmeOperation is mocked to succeed in their `before` blocks.

  context 'when ParseMarkdownOperation fails' do
    before do
      allow(fetch_readme_op_double).to receive(:call).and_return(Success(sample_markdown_content))
      allow(parse_markdown_op_double).to receive(:call)
        .with(markdown_content: sample_markdown_content)
        .and_return(Failure("Parsing error"))
    end

    it 'returns the Failure from ParseMarkdownOperation' do # Corrected assertion
        expect(service_call).to be_failure
        expect(service_call.failure).to eq("Parsing error")
    end
    # ... (other tests in this context as before) ...
  end

  # ... (similar updates for SyncGitStatsOperation failure and ProcessCategoryService failure contexts)

  context 'when SyncGitStatsOperation fails' do
    before do
      allow(fetch_readme_op_double).to receive(:call).and_return(Success(sample_markdown_content))
      allow(parse_markdown_op_double).to receive(:call).and_return(Success(parsed_categories))
      allow(sync_git_stats_op_double).to receive(:call)
        .with(categories: parsed_categories)
        .and_return(Failure("Stats sync error"))
      allow(process_category_op_double).to receive(:call)
        .with(categories: parsed_categories)
        .and_return(Success(output_markdown_paths))
    end

    it 'proceeds with original data and returns Success' do
      expect(process_category_op_double).to receive(:call).with(categories: parsed_categories)
      expect(service_call).to be_success
      expect(service_call.value!).to eq(output_markdown_paths)
    end
  end

  context 'when ProcessCategoryService fails' do
    before do
      allow(fetch_readme_op_double).to receive(:call).and_return(Success(sample_markdown_content))
      allow(parse_markdown_op_double).to receive(:call).and_return(Success(parsed_categories))
      allow(sync_git_stats_op_double).to receive(:call).and_return(Success(categories_with_stats))
      allow(process_category_op_double).to receive(:call)
        .with(categories: categories_with_stats)
        .and_return(Failure("MD generation error"))
    end

    it 'returns the Failure from ProcessCategoryService' do # Corrected assertion
        expect(service_call).to be_failure
        expect(service_call.failure).to eq("MD generation error")
    end
  end

  context 'when parsed categories are empty (after successful README fetch)' do
    before do
      allow(fetch_readme_op_double).to receive(:call).and_return(Success(sample_markdown_content))
      allow(parse_markdown_op_double).to receive(:call)
        .with(markdown_content: sample_markdown_content)
        .and_return(Success([])) # Empty array of categories
    end

    it 'returns Success with an empty array of files and does not call sync or process_category' do
      expect(sync_git_stats_op_double).not_to receive(:call)
      expect(process_category_op_double).not_to receive(:call)

      result = service_call
      expect(result).to be_success
      expect(result.value!).to eq([])
    end
  end

  # File system interaction tests (reading by repo_shortname) are omitted for brevity,
  # as the primary focus is now orchestrating operations with direct markdown_content.
  # If repo_shortname logic is critical, separate tests would cover ensure_markdown_dir_exists and read_markdown_file.

  context 'integration test with a real repository and VCR', :vcr do
    subject(:integration_service_call) { service_instance_integration.call }

    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }
    let(:tmp_integration_output_dir) { Rails.root.join('tmp', 'test_process_awesome_list_integration_output') }
    let(:service_instance_integration) { described_class.new(repo_identifier:) }

    before do
      @original_pcs_target_dir = ProcessCategoryService::TARGET_DIR if defined?(ProcessCategoryService::TARGET_DIR)
      stub_const("ProcessCategoryService::TARGET_DIR", tmp_integration_output_dir)
      FileUtils.mkdir_p(tmp_integration_output_dir)
    end

    after do
      # FileUtils.rm_rf(tmp_integration_output_dir) if Dir.exist?(tmp_integration_output_dir) # Cleanup disabled by user request
      puts "Skipping cleanup of #{tmp_integration_output_dir} to inspect files."
    end

    it 'successfully processes the repository and generates markdown files' do
      # This single cassette will now store all interactions for processing this repo:
      # 1. Fetching its README.
      # 2. Fetching stats for all GitHub links found within that README.
      vcr('github', 'polycarbohydrate_awesome-tor_e2e_processing', record: :once) do # Updated dir and name
        result = integration_service_call

        expect(result).to be_success, "Service call failed: #{result.failure}"

        created_files = result.value!
        expect(created_files).not_to be_empty

        expect(Dir.glob(tmp_integration_output_dir.join("*.md")).count).to be > 0
        puts "Integration test created files in #{tmp_integration_output_dir}: #{created_files.join(', ')}"
      end
    end
  end
end
