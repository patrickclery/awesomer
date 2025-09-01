# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessCategoryService do
  let(:service) { described_class.new }
  let(:repo_identifier) { 'owner/awesome-list' }

  describe 'filtering items without stats' do
    after do
      # Clean up generated test files
      Dir.glob(Rails.root.join('static', 'md', '*.md')).each do |file|
        File.delete(file) if File.basename(file).start_with?('test-') || File.basename(file).include?('awesome-list')
      end
    end

    context 'with mixed GitHub and non-GitHub items' do
      let(:categories) do
        [
          {
            custom_order: 0,
            items: [
              {description: 'GitHub tool', last_commit_at: Time.current, name: 'Tool1',
               primary_url: 'https://github.com/user/tool1', stars: 100},
              {description: 'GitHub no stats', last_commit_at: nil, name: 'Tool2',
               primary_url: 'https://github.com/user/tool2', stars: nil},
              {description: 'External tool', last_commit_at: nil, name: 'Tool3',
               primary_url: 'https://example.com/tool3', stars: nil},
              {description: 'GitLab tool', last_commit_at: nil, name: 'Tool4', primary_url: 'https://gitlab.com/user/tool4', stars: nil}
            ],
            name: 'Tools'
          }
        ]
      end

      it 'includes GitHub items with stats' do
        result = service.call(categories:, repo_identifier:)

        expect(result).to be_success
        file_content = File.read(result.value!)

        expect(file_content).to include('Tool1')
        expect(file_content).to include('100')
      end

      it 'excludes GitHub items without stats' do
        result = service.call(categories:, repo_identifier:)

        expect(result).to be_success
        file_content = File.read(result.value!)

        expect(file_content).not_to include('Tool2')
      end

      it 'includes non-GitHub items regardless of stats' do
        result = service.call(categories:, repo_identifier:)

        expect(result).to be_success
        file_content = File.read(result.value!)

        expect(file_content).to include('Tool3')
        expect(file_content).to include('Tool4')
      end

      it 'shows dash for non-GitHub items stars' do
        result = service.call(categories:, repo_identifier:)

        expect(result).to be_success
        file_content = File.read(result.value!)

        # Non-GitHub items should show dash instead of stars
        expect(file_content).to match(/Tool3.*—/)
        expect(file_content).to match(/Tool4.*—/)
      end
    end

    context 'with category containing only items without stats' do
      let(:categories) do
        [
          {
            custom_order: 0,
            items: [
              {description: 'No stats', name: 'NoStats1', primary_url: 'https://github.com/user/nostats1', stars: nil},
              {description: 'No stats', name: 'NoStats2', primary_url: 'https://github.com/user/nostats2', stars: nil}
            ],
            name: 'Empty Category'
          },
          {
            custom_order: 1,
            items: [
              {description: 'Has stats', name: 'ValidItem', primary_url: 'https://github.com/user/valid', stars: 50}
            ],
            name: 'Valid Category'
          }
        ]
      end

      it 'skips categories with no valid items' do
        result = service.call(categories:, repo_identifier:)

        expect(result).to be_success
        file_content = File.read(result.value!)

        expect(file_content).not_to include('Empty Category')
        expect(file_content).to include('Valid Category')
      end
    end

    context 'with all items filtered out' do
      let(:categories) do
        [
          {
            custom_order: 0,
            items: [
              {name: 'NoStats1', primary_url: 'https://github.com/user/nostats1', stars: nil},
              {name: 'NoStats2', primary_url: 'https://github.com/user/nostats2', stars: nil}
            ],
            name: 'All Filtered'
          }
        ]
      end

      it 'creates file with headers but no table data' do
        result = service.call(categories:, repo_identifier:)

        expect(result).to be_success
        file_content = File.read(result.value!)

        expect(file_content).not_to include('|')
        expect(file_content).not_to include('NoStats1')
      end
    end

    context 'with zero stars' do
      let(:categories) do
        [
          {
            custom_order: 0,
            items: [
              {description: 'No popularity', name: 'ZeroStars', primary_url: 'https://github.com/user/zero', stars: 0}
            ],
            name: 'Zero Stars'
          }
        ]
      end

      it 'includes items with zero stars' do
        result = service.call(categories:, repo_identifier:)

        expect(result).to be_success
        file_content = File.read(result.value!)

        expect(file_content).to include('ZeroStars')
        expect(file_content).to include('| 0 ')
      end
    end

    context 'when sorting by stars' do
      let(:categories) do
        [
          {
            custom_order: 0,
            items: [
              {name: 'Low', primary_url: 'https://github.com/user/low', stars: 10},
              {name: 'High', primary_url: 'https://github.com/user/high', stars: 1000},
              {name: 'Medium', primary_url: 'https://github.com/user/medium', stars: 100},
              {name: 'External', primary_url: 'https://example.com/external', stars: nil}
            ],
            name: 'Sorted'
          }
        ]
      end

      it 'sorts items by stars in descending order' do
        result = service.call(categories:, repo_identifier:)

        expect(result).to be_success
        file_content = File.read(result.value!)

        # Extract the order of items from the file
        lines = file_content.lines
        high_index = lines.find_index { |l| l.include?('High') }
        medium_index = lines.find_index { |l| l.include?('Medium') }
        low_index = lines.find_index { |l| l.include?('Low') }

        expect(high_index).to be < medium_index
        expect(medium_index).to be < low_index
      end
    end

    context 'with struct objects' do
      let(:categories) do
        [
          Structs::Category.new(
            custom_order: 0,
            name: 'Struct Category',
            repos: [
              Structs::CategoryItem.new(
                description: 'From struct',
                last_commit_at: Time.current,
                name: 'StructItem',
                primary_url: 'https://github.com/user/struct',
                stars: 200
              )
            ]
          )
        ]
      end

      it 'handles struct objects correctly' do
        result = service.call(categories:, repo_identifier:)

        expect(result).to be_success
        file_content = File.read(result.value!)

        expect(file_content).to include('StructItem')
        expect(file_content).to include('200')
      end
    end

    context 'with markdown formatting' do
      let(:categories) do
        [
          {
            custom_order: 0,
            items: [
              {
                description: "Multi\nline\ndescription",
                last_commit_at: Time.parse('2025-08-15'),
                name: 'Item with "quotes"',
                primary_url: 'https://github.com/user/repo',
                stars: 100
              }
            ],
            name: 'Test Category'
          }
        ]
      end

      it 'escapes special characters in item names' do
        result = service.call(categories:, repo_identifier:)

        file_content = File.read(result.value!)
        expect(file_content).to include('Item with "quotes"')
      end

      it 'replaces newlines in descriptions with <br>' do
        result = service.call(categories:, repo_identifier:)

        file_content = File.read(result.value!)
        expect(file_content).to include('Multi<br>line<br>description')
      end

      it 'formats dates correctly' do
        result = service.call(categories:, repo_identifier:)

        file_content = File.read(result.value!)
        expect(file_content).to include('2025-08-15')
      end
    end

    context 'with file generation' do
      it 'creates file in static/md directory' do
        result = service.call(categories: [], repo_identifier: 'owner/test-repo')

        expect(result).to be_success
        expect(result.value!.to_s).to include('static/md/test-repo.md')
      end

      it 'ensures target directory exists' do
        allow(FileUtils).to receive(:mkdir_p)

        service.call(categories: [], repo_identifier:)

        expect(FileUtils).to have_received(:mkdir_p).with(ProcessCategoryService::TARGET_DIR)
      end

      it 'handles file write errors' do
        allow(File).to receive(:write).and_raise(StandardError, 'Disk full')

        result = service.call(categories: [], repo_identifier:)

        expect(result).to be_failure
        expect(result.failure).to include('Failed to write processed awesome list')
      end
    end
  end
end
