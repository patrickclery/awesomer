# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessAwesomeListService do
  include Dry::Monads[:result]

  # Common `let` definitions for data and doubles, available to all contexts
  let(:sample_repo_identifier) { "owner/repo" }
  let(:sample_repo_owner) { "owner" }
  let(:sample_repo_name) { "repo" }
  let(:sample_repo_description) { "A great repo" }
  let(:sample_readme_last_commit_at) { Time.zone.parse('2024-01-01T12:00:00Z') }
  let(:sample_readme_filename) { "README.md" }
  let(:sample_markdown_content) { "## Test Category\n- [Test Item](http://example.com/test) - A test item." }

  let(:fetch_readme_success_data) do
    {
      content: sample_markdown_content, last_commit_at: sample_readme_last_commit_at, name: sample_readme_filename, owner: sample_repo_owner, repo: sample_repo_name, repo_description: sample_repo_description
    }
  end

  let(:fetch_readme_op_double) { instance_double(FetchReadmeOperation) }
  let(:parse_markdown_op_double) { instance_double(ParseMarkdownOperation) }
  let(:sync_git_stats_op_double) { instance_double(SyncGitStatsOperation) }
  let(:process_category_op_double) { instance_double(ProcessCategoryService) }
  let(:find_or_create_aw_list_op_double) { instance_double(FindOrCreateAwesomeListOperation) }

  let(:errors_double) { instance_double(ActiveModel::Errors, full_messages: [ "Save failed" ]) }
  let(:awesome_list_model_double) {
    instance_double(AwesomeList, description: sample_repo_description, errors: errors_double, github_repo: "#{sample_repo_owner}/#{sample_repo_name}", id: 1, last_commit_at: sample_readme_last_commit_at, name: sample_repo_name, save: true)
  }

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

  # No top-level `service_instance` or `subject` for unit tests to ensure context-specific setup.

  context 'when orchestration is successful' do
    let(:service_instance) do
      described_class.new(
        fetch_readme_operation: fetch_readme_op_double,
        find_or_create_awesome_list_operation: find_or_create_aw_list_op_double,
        parse_markdown_operation: parse_markdown_op_double,
        process_category_service: process_category_op_double,
        repo_identifier: sample_repo_identifier,
        sync_git_stats_operation: sync_git_stats_op_double
      )
    end

    before do
      allow(fetch_readme_op_double).to receive(:call).with(repo_identifier: sample_repo_identifier).and_return(Success(fetch_readme_success_data))
      allow(find_or_create_aw_list_op_double).to receive(:call).with(fetched_repo_data: fetch_readme_success_data).and_return(Success(awesome_list_model_double))
      allow(parse_markdown_op_double).to receive(:call).with(markdown_content: sample_markdown_content).and_return(Success(parsed_categories))
      allow(sync_git_stats_op_double).to receive(:call).with(categories: parsed_categories).and_return(Success(categories_with_stats))
      allow(process_category_op_double).to receive(:call).with(categories: categories_with_stats).and_return(Success(output_markdown_paths))
    end

    it 'returns a Success result' do
      expect(service_instance.call).to be_success
    end

    it 'returns the paths of the generated markdown files' do
      expect(service_instance.call.value!).to eq(output_markdown_paths)
    end

    it 'calls all operations in sequence' do
      expect(fetch_readme_op_double).to receive(:call).ordered
      expect(find_or_create_aw_list_op_double).to receive(:call).ordered
      expect(parse_markdown_op_double).to receive(:call).ordered
      expect(sync_git_stats_op_double).to receive(:call).ordered
      expect(process_category_op_double).to receive(:call).ordered
      service_instance.call
    end

    it 'calls FindOrCreateAwesomeListOperation with fetched_data' do
      expect(find_or_create_aw_list_op_double).to receive(:call).with(fetched_repo_data: fetch_readme_success_data)
      service_instance.call
    end
  end

  context 'when repo_identifier is blank' do
    let(:service_instance) { described_class.new(fetch_readme_operation: fetch_readme_op_double, repo_identifier: "") }

    it 'returns a Failure' do
      expect(fetch_readme_op_double).not_to receive(:call)
      result = service_instance.call
      expect(result).to be_failure
      expect(result.failure).to eq("Repository identifier must be provided")
    end
  end

  context 'when FetchReadmeOperation fails' do
    let(:service_instance) { described_class.new(fetch_readme_operation: fetch_readme_op_double, repo_identifier: sample_repo_identifier) }

    before do
      allow(fetch_readme_op_double).to receive(:call)
        .with(repo_identifier: sample_repo_identifier)
        .and_return(Failure("Fetch README error"))
    end

    it 'returns the Failure from FetchReadmeOperation' do
      result = service_instance.call
      expect(result).to be_failure
      expect(result.failure).to eq("Fetch README error")
    end

    it 'does not call subsequent operations' do
      expect(find_or_create_aw_list_op_double).not_to receive(:call)
      expect(parse_markdown_op_double).not_to receive(:call)
      service_instance.call
    end
  end

  context 'when FindOrCreateAwesomeListOperation fails' do
    let(:service_instance) do
      described_class.new(
        fetch_readme_operation: fetch_readme_op_double, find_or_create_awesome_list_operation: find_or_create_aw_list_op_double, parse_markdown_operation: parse_markdown_op_double, process_category_service: process_category_op_double, repo_identifier: sample_repo_identifier, sync_git_stats_operation: sync_git_stats_op_double
      )
    end

    before do
      allow(fetch_readme_op_double).to receive(:call).with(repo_identifier: sample_repo_identifier).and_return(Success(fetch_readme_success_data))
      allow(find_or_create_aw_list_op_double).to receive(:call).with(fetched_repo_data: fetch_readme_success_data).and_return(Failure("DB save error"))
    end

    it 'returns the Failure' do # Renamed for clarity
      result = service_instance.call
      expect(result).to be_failure
      expect(result.failure).to eq("DB save error")
    end

    it 'does not call operations after it' do # Renamed
      expect(parse_markdown_op_double).not_to receive(:call)
      service_instance.call
    end
  end

  context 'when ParseMarkdownOperation fails' do
    let(:service_instance) { described_class.new(fetch_readme_operation: fetch_readme_op_double, find_or_create_awesome_list_operation: find_or_create_aw_list_op_double, parse_markdown_operation: parse_markdown_op_double, repo_identifier: sample_repo_identifier) }

    before do
      allow(fetch_readme_op_double).to receive(:call).and_return(Success(fetch_readme_success_data))
      allow(find_or_create_aw_list_op_double).to receive(:call).and_return(Success(awesome_list_model_double))
      allow(parse_markdown_op_double).to receive(:call).with(markdown_content: sample_markdown_content).and_return(Failure("Parsing error"))
    end

    it 'returns the Failure' do
        result = service_instance.call
        expect(result).to be_failure
        expect(result.failure).to eq("Parsing error")
    end
  end

  context 'when SyncGitStatsOperation fails' do
    let(:service_instance) { described_class.new(fetch_readme_operation: fetch_readme_op_double, find_or_create_awesome_list_operation: find_or_create_aw_list_op_double, parse_markdown_operation: parse_markdown_op_double, process_category_service: process_category_op_double, repo_identifier: sample_repo_identifier, sync_git_stats_operation: sync_git_stats_op_double) }

    before do
      allow(fetch_readme_op_double).to receive(:call).and_return(Success(fetch_readme_success_data))
      allow(find_or_create_aw_list_op_double).to receive(:call).and_return(Success(awesome_list_model_double))
      allow(parse_markdown_op_double).to receive(:call).and_return(Success(parsed_categories))
      allow(sync_git_stats_op_double).to receive(:call).with(categories: parsed_categories).and_return(Failure("Stats sync error"))
      allow(process_category_op_double).to receive(:call).with(categories: parsed_categories).and_return(Success(output_markdown_paths))
    end

    it 'proceeds with original data and returns Success' do
      expect(process_category_op_double).to receive(:call).with(categories: parsed_categories)
      result = service_instance.call
      expect(result).to be_success
      expect(result.value!).to eq(output_markdown_paths)
    end
  end

  context 'when ProcessCategoryService fails' do
    let(:service_instance) { described_class.new(fetch_readme_operation: fetch_readme_op_double, find_or_create_awesome_list_operation: find_or_create_aw_list_op_double, parse_markdown_operation: parse_markdown_op_double, process_category_service: process_category_op_double, repo_identifier: sample_repo_identifier, sync_git_stats_operation: sync_git_stats_op_double) }

    before do
      allow(fetch_readme_op_double).to receive(:call).and_return(Success(fetch_readme_success_data))
      allow(find_or_create_aw_list_op_double).to receive(:call).and_return(Success(awesome_list_model_double))
      allow(parse_markdown_op_double).to receive(:call).and_return(Success(parsed_categories))
      allow(sync_git_stats_op_double).to receive(:call).and_return(Success(categories_with_stats))
      allow(process_category_op_double).to receive(:call).with(categories: categories_with_stats).and_return(Failure("MD generation error"))
    end

    it 'returns the Failure' do
        result = service_instance.call
        expect(result).to be_failure
        expect(result.failure).to eq("MD generation error")
    end
  end

  context 'when parsed categories are empty (after successful README fetch & DB upsert)' do
    let(:service_instance) { described_class.new(fetch_readme_operation: fetch_readme_op_double, find_or_create_awesome_list_operation: find_or_create_aw_list_op_double, parse_markdown_operation: parse_markdown_op_double, process_category_service: process_category_op_double, repo_identifier: sample_repo_identifier, sync_git_stats_operation: sync_git_stats_op_double) }

    before do
      allow(fetch_readme_op_double).to receive(:call).and_return(Success(fetch_readme_success_data))
      allow(find_or_create_aw_list_op_double).to receive(:call).and_return(Success(awesome_list_model_double))
      allow(parse_markdown_op_double).to receive(:call).with(markdown_content: sample_markdown_content).and_return(Success([]))
    end

    it 'returns Success with an empty array of files and does not call sync or process_category' do
      expect(sync_git_stats_op_double).not_to receive(:call)
      expect(process_category_op_double).not_to receive(:call)
      result = service_instance.call
      expect(result).to be_success
      expect(result.value!).to eq([])
    end
  end

  context 'when running as an integration test with a real repository and VCR', :vcr do
    subject(:integration_service_call) { service_instance_integration.call }

    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }
    let(:tmp_integration_output_dir) { Rails.root.join('tmp', 'test_process_awesome_list_integration_output') }
    # For integration test, service instance is created without injected doubles, using real operations from container
    let(:service_instance_integration) { described_class.new(repo_identifier:) }

    before do
      @original_pcs_target_dir = ProcessCategoryService::TARGET_DIR if defined?(ProcessCategoryService::TARGET_DIR)
      @original_pcs_output_filename = ProcessCategoryService::OUTPUT_FILENAME if defined?(ProcessCategoryService::OUTPUT_FILENAME)
      stub_const("ProcessCategoryService::TARGET_DIR", tmp_integration_output_dir)
      FileUtils.mkdir_p(tmp_integration_output_dir)
    end

    after do
      puts "Skipping cleanup of #{tmp_integration_output_dir} to inspect files."
      ProcessCategoryService.const_set(:TARGET_DIR, @original_pcs_target_dir) if @original_pcs_target_dir && defined?(ProcessCategoryService::TARGET_DIR)
      ProcessCategoryService.const_set(:OUTPUT_FILENAME, @original_pcs_output_filename) if @original_pcs_output_filename && defined?(ProcessCategoryService::OUTPUT_FILENAME)
    end

    it 'successfully processes the repository, upserts AwesomeList, and generates markdown files' do
      vcr('github', 'polycarbohydrate_awesome-tor', record: :new_episodes) do
        initial_count = AwesomeList.count
        result = integration_service_call
        expect(result).to be_success, "Service call failed: #{result.failure}"
        expect(AwesomeList.where(github_repo: 'Polycarbohydrate/awesome-tor').count).to eq(1)
        aw_list_record = AwesomeList.find_by(github_repo: 'Polycarbohydrate/awesome-tor')
        expect(aw_list_record).not_to be_nil
        expect(aw_list_record.name).to eq('awesome-tor')
        expect(aw_list_record.last_commit_at).to be_a(Time)
        expect(aw_list_record.description).not_to be_empty if aw_list_record.description.present?
        created_file_path = result.value!
        expect(File.exist?(created_file_path)).to be(true)
      end
    end
  end
end
