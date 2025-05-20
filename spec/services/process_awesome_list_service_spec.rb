# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessAwesomeListService do
  include Dry::Monads[:result]

  subject(:service_call) { service_instance.call }

  let(:sample_repo_identifier) { "owner/repo" }
  let(:sample_repo_owner) { "owner" }
  let(:sample_repo_name) { "repo" }
  let(:sample_repo_description) { "A great repo" }
  let(:sample_readme_last_commit_at) { Time.zone.parse('2024-01-01T12:00:00Z') }
  let(:sample_readme_filename) { "README.md" }
  let(:sample_markdown_content) { "## Test Category\n- [Test Item](http://example.com/test) - A test item." }

  let(:fetch_readme_success_data) do
    {
      content: sample_markdown_content,
      last_commit_at: sample_readme_last_commit_at,
      name: sample_readme_filename,
      owner: sample_repo_owner,
      repo: sample_repo_name,
      repo_description: sample_repo_description
    }
  end

  let(:fetch_readme_op_double) { instance_double(FetchReadmeOperation) }
  let(:parse_markdown_op_double) { instance_double(ParseMarkdownOperation) }
  let(:sync_git_stats_op_double) { instance_double(SyncGitStatsOperation) }
  let(:process_category_op_double) { instance_double(ProcessCategoryService) }
  let(:awesome_list_double) { instance_double(AwesomeList, errors: double(full_messages: []), last_commit_at: sample_readme_last_commit_at, save: true) }

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

  before do
    allow(fetch_readme_op_double).to receive(:call)
      .with(repo_identifier: sample_repo_identifier)
      .and_return(Success(fetch_readme_success_data))

    allow(AwesomeList).to receive(:find_or_initialize_by).and_return(awesome_list_double)
    allow(awesome_list_double).to receive(:name=)
    allow(awesome_list_double).to receive(:description=)
    allow(awesome_list_double).to receive(:last_commit_at=)
    allow(awesome_list_double).to receive(:save).and_return(true)
  end

  context 'when orchestration is successful' do
    before do
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

    it 'upserts the AwesomeList record with correct data' do
      expected_repo_shortname = "#{sample_repo_owner}/#{sample_repo_name}"
      expect(AwesomeList).to receive(:find_or_initialize_by).with(github_repo: expected_repo_shortname).and_return(awesome_list_double)
      expect(awesome_list_double).to receive(:name=).with(sample_repo_name)
      expect(awesome_list_double).to receive(:description=).with(sample_repo_description)
      expect(awesome_list_double).to receive(:last_commit_at=).with(sample_readme_last_commit_at)
      expect(awesome_list_double).to receive(:save).and_return(true)
      service_call
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

  context 'when AwesomeList save fails' do
    before do
      allow(awesome_list_double).to receive(:save).and_return(false)
      allow(awesome_list_double).to receive_message_chain(:errors, :full_messages).and_return([ "Save failed" ])
      allow(parse_markdown_op_double).to receive(:call).and_return(Success(parsed_categories))
    end

    it 'returns a Failure' do
      expect(service_call).to be_failure
      expect(service_call.failure).to eq("Failed to save AwesomeList record for #{sample_repo_owner}/#{sample_repo_name}: Save failed")
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
      expect(AwesomeList).not_to receive(:find_or_initialize_by)
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

  context 'when ParseMarkdownOperation fails' do
    before do
      allow(parse_markdown_op_double).to receive(:call)
        .with(markdown_content: sample_markdown_content)
        .and_return(Failure("Parsing error"))
    end

    it 'returns the Failure from ParseMarkdownOperation' do
      expect(service_call).to be_failure
      expect(service_call.failure).to eq("Parsing error")
    end
  end

  context 'when SyncGitStatsOperation fails' do
    before do
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
      allow(parse_markdown_op_double).to receive(:call).and_return(Success(parsed_categories))
      allow(sync_git_stats_op_double).to receive(:call).and_return(Success(categories_with_stats))
      allow(process_category_op_double).to receive(:call)
        .with(categories: categories_with_stats)
        .and_return(Failure("MD generation error"))
    end

    it 'returns the Failure from ProcessCategoryService' do
      expect(service_call).to be_failure
      expect(service_call.failure).to eq("MD generation error")
    end
  end

  context 'when parsed categories are empty (after successful README fetch)' do
    before do
      allow(parse_markdown_op_double).to receive(:call)
        .with(markdown_content: sample_markdown_content)
        .and_return(Success([]))
    end

    it 'returns Success with an empty array of files and does not call sync or process_category' do
      expect(sync_git_stats_op_double).not_to receive(:call)
      expect(process_category_op_double).not_to receive(:call)

      result = service_call
      expect(result).to be_success
      expect(result.value!).to eq([])
    end
  end

  context 'integration test with a real repository and VCR', :vcr do
    subject(:integration_service_call) { service_instance_integration.call }

    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }
    let(:tmp_integration_output_dir) { Rails.root.join('tmp', 'test_process_awesome_list_integration_output') }
    let(:service_instance_integration) { described_class.new(repo_identifier:) }

    before do
      @original_pcs_target_dir = ProcessCategoryService::TARGET_DIR if defined?(ProcessCategoryService::TARGET_DIR)
      @original_pcs_output_filename = ProcessCategoryService::OUTPUT_FILENAME if defined?(ProcessCategoryService::OUTPUT_FILENAME)
      stub_const("ProcessCategoryService::TARGET_DIR", tmp_integration_output_dir)
      # For this integration test, let ProcessCategoryService use its default OUTPUT_FILENAME
      # but if a custom one was needed for the test, it would be stubbed here too.
      FileUtils.mkdir_p(tmp_integration_output_dir)
    end

    after do
      # FileUtils.rm_rf(tmp_integration_output_dir) if Dir.exist?(tmp_integration_output_dir) # Cleanup disabled by user request
      puts "Skipping cleanup of #{tmp_integration_output_dir} to inspect files."
      # Restore constants if they were defined and if stub_const didn't (though it should)
      ProcessCategoryService.const_set(:TARGET_DIR, @original_pcs_target_dir) if @original_pcs_target_dir && defined?(ProcessCategoryService::TARGET_DIR)
      ProcessCategoryService.const_set(:OUTPUT_FILENAME, @original_pcs_output_filename) if @original_pcs_output_filename && defined?(ProcessCategoryService::OUTPUT_FILENAME)
    end

    it 'successfully processes the repository, upserts AwesomeList, and generates markdown files' do
      # This single cassette will now store all interactions for processing this repo.
      # Using `record: :new_episodes` allows it to add new interactions if the README changes
      # and new repositories are linked, or if existing ones have new API endpoints hit.
      vcr('github', 'polycarbohydrate_awesome-tor', record: :new_episodes) do
        result = integration_service_call

        expect(result).to be_success, "Service call failed: #{result.failure}"

        created_file_path = result.value! # Expecting a single file path now
        expect(created_file_path).to eq(tmp_integration_output_dir.join(ProcessCategoryService::OUTPUT_FILENAME))
        expect(File.exist?(created_file_path)).to be(true)

        puts "Integration test created file: #{created_file_path}"

        # Verify AwesomeList record was updated
        aw_list_record = AwesomeList.find_by(github_repo: 'Polycarbohydrate/awesome-tor')
        expect(aw_list_record).not_to be_nil
        expect(aw_list_record.name).to eq('awesome-tor')
        expect(aw_list_record.last_commit_at).to be_a(Time)
        expect(aw_list_record.description).not_to be_empty if aw_list_record.description.present?
      end
    end
  end
end
