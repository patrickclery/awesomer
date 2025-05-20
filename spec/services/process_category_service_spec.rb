# frozen_string_literal: true

require 'rails_helper'
require 'fileutils'

# Note: Structs::Category, Structs::CategoryItem, ParseMarkdownOperation
# are expected to be available via Rails eager loading.

RSpec.describe ProcessCategoryService do
  include Dry::Monads[:result]

  subject(:service_call) { described_class.new.call(categories: test_categories) }

  let(:tmp_target_dir) { Rails.root.join('tmp', 'test_static_md') }
  let(:time_now) { Time.zone.parse('2024-01-15T10:30:00Z') } # Fixed time for consistent last_commit

  let(:item1_cat1) { Structs::CategoryItem.new(description: "The first tool", id: 1, last_commit_at: time_now, name: "Awesome Tool 1", stars: 100, url: "http://example.com/tool1") }
  let(:item2_cat1) { Structs::CategoryItem.new(description: "The second lib\nwith multi-line desc", id: 2, last_commit_at: time_now - 1.day, name: "Super Lib 2", stars: 250, url: "http://example.com/lib2") }
  let(:item3_cat1_no_stats) { Structs::CategoryItem.new(description: nil, id: 3, name: "Alpha Project", url: "http://example.com/alpha") }

  let(:category1) { Structs::Category.new(custom_order: 1, name: "Dev Tools", repos: [ item1_cat1, item2_cat1, item3_cat1_no_stats ]) }

  let(:item1_cat2) { Structs::CategoryItem.new(description: "Utility for data", id: 10, last_commit_at: time_now - 5.days, name: "Data Util", stars: 50, url: "http://example.com/datautil") }
  let(:category2) { Structs::Category.new(custom_order: 0, name: "Data Science!", repos: [ item1_cat2 ]) }
  let(:category3_empty) { Structs::Category.new(custom_order: 2, name: "Empty Category", repos: []) }

  let(:test_categories) { [ category1, category2, category3_empty ] }

  before do
    # Override the TARGET_DIR for tests to use a temporary directory
    stub_const("ProcessCategoryService::TARGET_DIR", tmp_target_dir)
    FileUtils.mkdir_p(tmp_target_dir)
  end

  after do
    FileUtils.rm_rf(tmp_target_dir) if Dir.exist?(tmp_target_dir)
  end

  context 'when processing categories' do
    it 'returns a Success result with the paths of created files' do
      result = service_call
      expect(result).to be_success
      expect(result.value!.size).to eq(3) # For 3 categories
      expect(result.value!).to include(tmp_target_dir.join('data_science_-stars.md'))
      expect(result.value!).to include(tmp_target_dir.join('dev_tools-stars.md'))
      expect(result.value!).to include(tmp_target_dir.join('empty_category-stars.md'))
    end

    it 'creates markdown files in the correct order with correct content' do
      service_call

      # Check Category 2 (order 0) - data_science!-stars.md
      cat2_filename = tmp_target_dir.join('data_science_-stars.md')
      expect(File.exist?(cat2_filename)).to be(true)
      cat2_content = File.read(cat2_filename)
      expect(cat2_content).to include("## Data Science!\n")
      expect(cat2_content).to include("| Name | Description | Stars | Last Commit |")
      expect(cat2_content).to include("| [Data Util](http://example.com/datautil) | Utility for data | 50 | 2024-01-10 |")

      # Check Category 1 (order 1) - dev_tools-stars.md
      cat1_filename = tmp_target_dir.join('dev_tools-stars.md')
      expect(File.exist?(cat1_filename)).to be(true)
      cat1_content = File.read(cat1_filename)
      expect(cat1_content).to include("## Dev Tools\n")
      expect(cat1_content).to include("| [Awesome Tool 1](http://example.com/tool1) | The first tool | 100 | 2024-01-15 |")
      expect(cat1_content).to include("| [Super Lib 2](http://example.com/lib2) | The second lib<br>with multi-line desc | 250 | 2024-01-14 |")
      expect(cat1_content).to include("| [Alpha Project](http://example.com/alpha) |  | N/A | N/A |") # Note: empty string for nil desc

      # Check Category 3 (order 2) - empty_category-stars.md
      cat3_filename = tmp_target_dir.join('empty_category-stars.md')
      expect(File.exist?(cat3_filename)).to be(true)
      cat3_content = File.read(cat3_filename)
      expect(cat3_content).to include("## Empty Category\n")
      expect(cat3_content).not_to include("|[#{'#'}#") # Should not have item rows
    end

    it 'handles an empty categories array' do
      result = described_class.new.call(categories: [])
      expect(result).to be_success
      expect(result.value!).to be_empty
      # Check that TARGET_DIR was still created (or attempted)
      expect(Dir.exist?(tmp_target_dir)).to be(true)
    end
  end

  context 'when directory creation fails' do
    before do
      # Make FileUtils.mkdir_p raise an error when trying to create TARGET_DIR
      allow(FileUtils).to receive(:mkdir_p).with(tmp_target_dir).and_raise(Errno::EACCES.new("Permission denied"))
    end

    it 'returns a Failure result' do
      result = service_call
      expect(result).to be_failure
      expect(result.failure).to include("Failed to create target directory #{tmp_target_dir}")
    end
  end

  context 'when file writing fails for a category' do
    before do
      # Let directory creation succeed, but make File.write fail for the first processed category
      allow(FileUtils).to receive(:mkdir_p).with(tmp_target_dir).and_call_original
      # The first category to be processed is category2 (order 0)
      expected_failing_path = tmp_target_dir.join('data_science_-stars.md')
      allow(File).to receive(:write).with(expected_failing_path, any_args).and_raise(IOError.new("Disk full"))
    end

    it 'returns a Failure result' do
      result = service_call
      expect(result).to be_failure
      expect(result.failure).to include("Failed to generate or write markdown for category Data Science!")
    end
  end
end
