# frozen_string_literal: true

require 'rails_helper'
require 'fileutils'

RSpec.describe ProcessAwesomeListService do
  subject(:service_call) { service_instance.call }

  let(:repo_shortname) { 'test-user/test-repo' }
  let(:repo_shortname_fs) { repo_shortname.tr('/', '_') }
  let(:tmp_markdown_dir) { Rails.root.join('tmp', 'markdown') }
  let(:tmp_json_dir) { Rails.root.join('tmp', 'json') }
  let(:markdown_file_path) { tmp_markdown_dir.join("#{repo_shortname_fs}.md") }
  let(:json_file_path) { tmp_json_dir.join("#{repo_shortname_fs}.json") }
  let(:sample_markdown_content) { "## Awesome Test Repo\n\n- Item 1 (not a link)\n- Item 2 (also not a link)" }
  let(:parse_markdown_op_double) { instance_double(ParseMarkdownOperation) }
  let(:parsed_data_from_op) do
    [
      {items: [], name: 'Awesome Test Repo'}
    ]
  end
  let(:parsed_data_success) { Dry::Monads::Success(parsed_data_from_op) }
  let(:parsed_data_failure) { Dry::Monads::Failure("Markdown parsing failed") }
  let(:service_instance) { described_class.new(repo_shortname:) }

  before do
    # Stub the container resolution for the dependency using App::Container.stub
    App::Container.stub('parse_markdown_operation', parse_markdown_op_double)

    FileUtils.mkdir_p(tmp_markdown_dir)
    FileUtils.mkdir_p(tmp_json_dir)
    File.write(markdown_file_path, sample_markdown_content)
  end

  after do # General file cleanup
    FileUtils.rm_f(markdown_file_path)
    FileUtils.rm_f(json_file_path)
    Dir.rmdir(tmp_markdown_dir) if Dir.exist?(tmp_markdown_dir) && Dir.empty?(tmp_markdown_dir)
    Dir.rmdir(tmp_json_dir) if Dir.exist?(tmp_json_dir) && Dir.empty?(tmp_json_dir)
  end

  context 'when the markdown file exists and parsing is successful (with default content)' do
    before do
      expect(parse_markdown_op_double).to receive(:call)
        .with(markdown_content: sample_markdown_content)
        .and_return(parsed_data_success)
    end

    it 'returns a Success result' do
      expect(service_call).to be_success
    end

    it 'returns the path to the created JSON file' do
      expect(service_call.value!).to eq(json_file_path)
    end

    it 'creates a JSON file with data from ParseMarkdown operation' do
      service_call
      expect(File.exist?(json_file_path)).to be(true)
      json_content = JSON.parse(File.read(json_file_path))
      expected_json_content = parsed_data_from_op.map { |h| h.deep_stringify_keys }
      expect(json_content).to eq(expected_json_content)
    end

    it 'calls ParseMarkdownOperation with the markdown content' do
      expect { service_call }.not_to raise_error
      expect(service_call).to be_a(Dry::Monads::Result)
    end
  end

  context 'when ParseMarkdownOperation returns a Failure' do
    before do
      expect(parse_markdown_op_double).to receive(:call)
        .with(markdown_content: sample_markdown_content)
        .and_return(parsed_data_failure)
    end

    it 'returns a Failure result' do
      expect(service_call).to be_failure
    end

    it 'returns the failure message from ParseMarkdownOperation' do
      expect(service_call.failure).to eq("Markdown parsing failed")
    end

    it 'does not create a JSON file' do
      service_call
      expect(File.exist?(json_file_path)).to be(false)
    end
  end

  context 'when the markdown file does not exist' do
    before do
      FileUtils.rm_f(markdown_file_path)
      expect(parse_markdown_op_double).not_to receive(:call) # Should not be called
    end

    it 'returns a Failure result' do
      expect(service_call).to be_failure
    end

    it 'returns an error message about missing file' do
      expect(service_call.failure).to eq("Markdown file not found or empty: #{markdown_file_path}")
    end

    it 'does not create a JSON file' do
      service_call
      expect(File.exist?(json_file_path)).to be(false)
    end
  end

  context 'when an unexpected error occurs before parsing (e.g., file read error)' do
    before do
      expect(File).to receive(:read).with(markdown_file_path).and_raise(StandardError.new("Unexpected read error"))
      expect(parse_markdown_op_double).not_to receive(:call) # Should not be called
    end

    it 'returns a Failure result' do
      expect(service_call).to be_failure
    end

    it 'returns a generic error message' do
      expect(service_call.failure).to eq("Error processing awesome list for #{repo_shortname}: Unexpected read error")
    end
  end

  context 'with awesome_self_hosted_snippet.md content' do
    let(:snippet_file_path) { Rails.root.join('spec', 'fixtures', 'awesome_self_hosted_snippet.md') }
    let(:snippet_markdown_content) { File.read(snippet_file_path) }
    let(:parsed_data_for_snippet) do # Mocked parsed structure for the snippet
      {
        categories: [
          {items_count: 8, name: 'Calendar & Contacts'} # Simplified representation
        ],
        source_file: 'awesome_self_hosted_snippet.md'
      }
    end
    let(:snippet_parsed_data_success) { Dry::Monads::Success(parsed_data_for_snippet) }

    before do
      # Overwrite the default markdown content with the snippet content
      File.write(markdown_file_path, snippet_markdown_content)

      expect(parse_markdown_op_double).to receive(:call)
        .with(markdown_content: snippet_markdown_content)
        .and_return(snippet_parsed_data_success)
    end

    it 'returns a Success result' do
      expect(service_call).to be_success
    end

    it 'creates a JSON file with parsed data from the snippet' do
      service_call
      expect(File.exist?(json_file_path)).to be(true)
      json_content = JSON.parse(File.read(json_file_path))
      # Ensure deep_stringify_keys if parsed_data_for_snippet has symbol keys
      expect(json_content).to eq(parsed_data_for_snippet.deep_stringify_keys)
    end

    it 'calls ParseMarkdownOperation with the snippet markdown content' do
      expect { service_call }.not_to raise_error
      expect(service_call).to be_a(Dry::Monads::Result)
    end
  end
end
