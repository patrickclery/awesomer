# frozen_string_literal: true

require 'rails_helper'
require 'fileutils'

# Note: Structs::Category, Structs::CategoryItem, ParseMarkdownOperation
# are expected to be available via Rails eager loading.

RSpec.describe ProcessCategoryService do
  include Dry::Monads[:result]

  subject(:service_call) { described_class.new.call(categories: test_categories) }

  let(:tmp_target_dir) { Rails.root.join('tmp', 'test_static_md_process_category') } # Unique temp dir
  let(:time_now) { Time.zone.parse('2024-01-15T10:30:00Z') }
  let(:expected_output_filename) { ProcessCategoryService::OUTPUT_FILENAME } # Use constant
  let(:expected_output_filepath) { tmp_target_dir.join(expected_output_filename) }

  let(:item1_cat1) {
    Structs::CategoryItem.new(description: "The first tool", id: 1, last_commit_at: time_now, name: "Awesome Tool 1",
primary_url: "http://example.com/tool1", stars: 100)
  }
  let(:item2_cat1) {
    Structs::CategoryItem.new(description: "The second lib\nwith multi-line desc", id: 2,
last_commit_at: time_now - 1.day, name: "Super Lib 2", primary_url: "http://example.com/lib2", stars: 250)
  }
  let(:item3_cat1_no_stats) {
    Structs::CategoryItem.new(description: nil, id: 3, name: "Alpha Project", primary_url: "http://example.com/alpha")
  }
  let(:category1) {
    Structs::Category.new(custom_order: 1, id: 1, name: "Dev Tools",
repos: [ item1_cat1, item2_cat1, item3_cat1_no_stats ])
  }
  let(:item1_cat2) {
    Structs::CategoryItem.new(description: "Utility for data", id: 10, last_commit_at: time_now - 5.days,
name: "Data Util", primary_url: "http://example.com/datautil", stars: 50)
  }
  let(:category2) { Structs::Category.new(custom_order: 0, id: 2, name: "Data Science!", repos: [ item1_cat2 ]) }
  let(:category3_empty) { Structs::Category.new(custom_order: 2, id: 3, name: "Empty Category", repos: []) }

  let(:test_categories) {
 [ category2, category1, category3_empty ] } # Intentionally unsorted by custom_order, service receives them sorted

  before do
    # Store original constants to restore them after tests
    @original_pcs_target_dir = ProcessCategoryService::TARGET_DIR if defined?(ProcessCategoryService::TARGET_DIR)
    if defined?(ProcessCategoryService::OUTPUT_FILENAME)
      @original_pcs_output_filename = ProcessCategoryService::OUTPUT_FILENAME
    end

    stub_const("ProcessCategoryService::TARGET_DIR", tmp_target_dir)
    # For this spec, we test with the default OUTPUT_FILENAME. If a test needed to change it:
    # stub_const("ProcessCategoryService::OUTPUT_FILENAME", "custom_name.md")
    FileUtils.mkdir_p(tmp_target_dir)
  end

  after do
    FileUtils.rm_rf(tmp_target_dir) if Dir.exist?(tmp_target_dir)
    # RSpec's stub_const should restore the original constants.
    # Manual restoration would look like (but usually not needed with stub_const):
    # ProcessCategoryService.const_set(:TARGET_DIR, @original_pcs_target_dir) if @original_pcs_target_dir
    # ProcessCategoryService.const_set(:OUTPUT_FILENAME, @original_pcs_output_filename) if @original_pcs_output_filename
  end

  context 'when processing categories' do
    it 'returns a Success result with the path to the single created file' do
      result = service_call
      expect(result).to be_success
      expect(result.value!).to eq(expected_output_filepath)
    end

    example(
      'creates a single markdown file with aggregated content from all categories in order, ' \
      'with items sorted by stars'
    ) do
      # ProcessCategoryService receives categories already sorted by custom_order from ProcessAwesomeListService.
      # For this unit test, we simulate this by sorting the input to the service call.
      sorted_test_categories_by_custom_order = test_categories.sort_by(&:custom_order)

      call_result = described_class.new.call(categories: sorted_test_categories_by_custom_order)
      expect(call_result).to be_success
      output_file_path = call_result.value!
      expect(File.exist?(output_file_path)).to be(true)
      content = File.read(output_file_path)

      expected_content_order = <<~MARKDOWN.strip_heredoc
        ## Data Science!

        | Name                                     | Description      | Stars | Last Commit |
        |------------------------------------------|------------------|-------|-------------|
        | [Data Util](http://example.com/datautil) | Utility for data | 50    | #{ (time_now - 5.days).strftime('%Y-%m-%d')}  |

        ## Dev Tools

        | Name                                       | Description                            | Stars | Last Commit |
        |--------------------------------------------|----------------------------------------|-------|-------------|
        | [Super Lib 2](http://example.com/lib2)     | The second lib<br>with multi-line desc | 250   | #{ (time_now - 1.day).strftime('%Y-%m-%d')}  |
        | [Awesome Tool 1](http://example.com/tool1) | The first tool                         | 100   | #{time_now.strftime('%Y-%m-%d')}  |
        | [Alpha Project](http://example.com/alpha)  |                                        | N/A   | N/A         |

        ## Empty Category

        | Name                         | Description | Stars | Last Commit |
        |------------------------------|-------------|-------|-------------|
        | *No items in this category.* |             |       |             |
      MARKDOWN
      expected_final_content = expected_content_order.strip + "\n"

      expect(content.strip.gsub(/\r\n?/, "\n")).to eq(expected_final_content.strip.gsub(/\r\n?/, "\n"))
    end

    it 'handles an empty categories array' do
      result = described_class.new.call(categories: [])
      expect(result).to be_success
      expect(File.read(result.value!).strip).to eq("")
    end
  end

  context 'when directory creation fails' do
    before do
      allow(FileUtils).to receive(:mkdir_p).with(tmp_target_dir).and_raise(Errno::EACCES.new("Permission denied"))
    end

    it 'returns a Failure result' do
      result = service_call # subject uses test_categories (which is unsorted by default)
      expect(result).to be_failure
      expect(result.failure).to include("Failed to create target directory #{tmp_target_dir}")
    end
  end

  context 'when file writing fails' do
    before do
      allow(FileUtils).to receive(:mkdir_p).with(tmp_target_dir).and_call_original
      allow(File).to receive(:write).with(expected_output_filepath, any_args).and_raise(IOError.new("Disk full"))
    end

    it 'returns a Failure result' do
      # Pass sorted categories as the service expects them, matching the success case for file write attempt
      sorted_test_categories = test_categories.sort_by(&:custom_order)
      result = described_class.new.call(categories: sorted_test_categories)
      expect(result).to be_failure
      expect(result.failure).to include("Failed to write processed awesome list to #{expected_output_filepath}")
    end
  end

  context 'when repo_identifier is provided' do
    let(:repo_identifier) { 'awesome-selfhosted/awesome-selfhosted' }
    let(:expected_filename) { 'awesome-selfhosted.md' }
    let(:expected_filepath_with_repo) { tmp_target_dir.join(expected_filename) }

    it 'generates filename based on repository identifier' do
      result = described_class.new.call(categories: test_categories, repo_identifier:)
      expect(result).to be_success
      expect(result.value!).to eq(expected_filepath_with_repo)
      expect(File.exist?(expected_filepath_with_repo)).to be(true)
    end

    context 'with different repository identifier formats' do
      [
        [ 'owner/repo', 'repo.md' ],
        [ 'https://github.com/owner/repo', 'repo.md' ],
        [ 'https://github.com/owner/repo.git', 'repo.md' ],
        [ 'awesome-selfhosted/awesome-selfhosted', 'awesome-selfhosted.md' ],
        [ 'user-name/project-name', 'project-name.md' ]
      ].each do |input, expected_output|
        it "converts '#{input}' to '#{expected_output}'" do
          service = described_class.new
          result = service.send(:generate_filename_from_repo, input)
          expect(result).to eq(expected_output)
        end
      end
    end
  end
end
