# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PersistParsedCategoriesOperation do
  subject(:operation_call) do
    described_class.new.call(awesome_list:, parsed_categories:)
  end

  let(:awesome_list) { AwesomeList.create!(github_repo: 'test/repo', name: 'Test List') }

  let(:parsed_categories) do
    [
      {
        custom_order: 0,
        items: [
          {
            demo_url: nil,
            description: 'Privacy first analytics ([Source Code](https://github.com/aptabase/aptabase))',
            github_repo: 'aptabase/aptabase',
            id: 1,
            name: 'Aptabase',
            primary_url: 'https://aptabase.com/'
          },
          {
            demo_url: 'https://demo.example.com',
            description: 'Some external tool',
            github_repo: nil,
            id: 2,
            name: 'External Tool',
            primary_url: 'https://example.com/'
          }
        ],
        name: 'Analytics'
      },
      {
        custom_order: 1,
        items: [
          {
            demo_url: nil,
            description: 'Code editor',
            github_repo: 'microsoft/vscode',
            id: 3,
            name: 'VS Code',
            primary_url: 'https://github.com/microsoft/vscode'
          }
        ],
        name: 'Development'
      }
    ]
  end

  example 'returns a Success result' do
    expect(operation_call).to be_success
  end

  example 'creates categories and category items in the database' do
    result = operation_call.value!

    expect(result.size).to eq(2)
    expect(Category.count).to eq(2)
    expect(CategoryItem.count).to eq(3)

    # Check first category
    analytics_category = result.find { |cat| cat.name == 'Analytics' }
    expect(analytics_category).to be_present
    expect(analytics_category.awesome_list).to eq(awesome_list)
    expect(analytics_category.category_items.count).to eq(2)

    # Check category items
    aptabase = analytics_category.category_items.find_by(name: 'Aptabase')
    expect(aptabase.primary_url).to eq('https://aptabase.com/')
    expect(aptabase.github_repo).to eq('aptabase/aptabase')
    expect(aptabase.demo_url).to be_nil
    expect(aptabase.description).to include('Privacy first analytics')

    external_tool = analytics_category.category_items.find_by(name: 'External Tool')
    expect(external_tool.primary_url).to eq('https://example.com/')
    expect(external_tool.github_repo).to be_nil
    expect(external_tool.demo_url).to eq('https://demo.example.com')

    # Check second category
    dev_category = result.find { |cat| cat.name == 'Development' }
    expect(dev_category).to be_present
    expect(dev_category.category_items.count).to eq(1)

    vscode = dev_category.category_items.first
    expect(vscode.name).to eq('VS Code')
    expect(vscode.github_repo).to eq('microsoft/vscode')
  end

  example 'clears all existing categories when re-processing' do
    # Use a separate awesome list for this test
    test_list = AwesomeList.create!(github_repo: 'test/reprocess', name: 'Reprocess Test')

    # First run
    described_class.new.call(awesome_list: test_list, parsed_categories:)
    test_list.reload
    expect(test_list.categories.count).to eq(2)

    total_items = test_list.categories.includes(:category_items).sum { |c| c.category_items.count }
    expect(total_items).to eq(3)

    # Second run with different data - should replace ALL categories
    new_parsed_categories = [
      {
        custom_order: 0,
        items: [
          {
            demo_url: nil,
            description: 'A new analytics tool',
            github_repo: 'new/tool',
            id: 1,
            name: 'New Tool',
            primary_url: 'https://newtool.com/'
          }
        ],
        name: 'Analytics'
      }
    ]

    described_class.new.call(awesome_list: test_list, parsed_categories: new_parsed_categories)

    # Should have only the new categories and items for this awesome list
    test_list.reload
    expect(test_list.categories.count).to eq(1)
    expect(test_list.categories.first.name).to eq('Analytics')
    expect(test_list.categories.first.category_items.count).to eq(1)
    expect(test_list.categories.first.category_items.first.name).to eq('New Tool')
  end

  context 'with empty parsed categories' do
    let(:parsed_categories) { [] }

    example 'returns success with empty array' do
      expect(operation_call).to be_success
      expect(operation_call.value!).to eq([])
      expect(Category.count).to eq(0)
      expect(CategoryItem.count).to eq(0)
    end
  end

  context 'with invalid category item data' do
    let(:parsed_categories) do
      [
        {
          custom_order: 0,
          items: [
            {
              demo_url: nil,
              description: 'Invalid item',
              github_repo: nil,
              id: 1,
              name: '',
              primary_url: ''
            }
          ],
          name: 'Invalid Category'
        }
      ]
    end

    example 'returns a Failure result' do
      expect(operation_call).to be_failure
      expect(operation_call.failure).to include('Failed to persist categories')
    end
  end
end
