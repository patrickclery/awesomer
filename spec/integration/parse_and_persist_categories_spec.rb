# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Parse and Persist Categories Integration' do
  let(:awesome_list) { AwesomeList.create!(github_repo: 'test/repo', name: 'Test List') }

  let(:markdown_content) do
    <<~MARKDOWN
      ## Analytics
      - [Aptabase](https://aptabase.com/) - Privacy first and simple analytics for mobile and desktop apps. ([Source Code](https://github.com/aptabase/aptabase)) `AGPL-3.0` `Docker`
      - [External Tool](https://example.com/) - Some external tool ([Demo](https://demo.example.com))

      ## Development
      - [VS Code](https://github.com/microsoft/vscode) - Code editor
    MARKDOWN
  end

  example 'parses markdown and persists to database with new schema' do
    # Step 1: Parse markdown content
    parse_result = ParseMarkdownOperation.new.call(markdown_content:)
    expect(parse_result).to be_success

    parsed_categories = parse_result.value!
    expect(parsed_categories.size).to eq(2)

    # Step 2: Persist to database
    persist_result = PersistParsedCategoriesOperation.new.call(
      awesome_list:,
      parsed_categories:
    )
    expect(persist_result).to be_success

    # Step 3: Verify database state
    expect(Category.count).to eq(2)
    expect(CategoryItem.count).to eq(3)

    # Check Analytics category
    analytics_category = Category.find_by(name: 'Analytics')
    expect(analytics_category.awesome_list).to eq(awesome_list)
    expect(analytics_category.category_items.count).to eq(2)

    # Check Aptabase item - should have GitHub repo extracted from Source Code link
    aptabase = analytics_category.category_items.find_by(name: 'Aptabase')
    expect(aptabase.primary_url).to eq('https://aptabase.com/')
    expect(aptabase.github_repo).to eq('aptabase/aptabase')
    expect(aptabase.demo_url).to be_nil
    expect(aptabase.description).to include('Privacy first and simple analytics')
    expect(aptabase.description).to include('([Source Code](https://github.com/aptabase/aptabase))')

    # Check External Tool item - should have demo URL extracted
    external_tool = analytics_category.category_items.find_by(name: 'External Tool')
    expect(external_tool.primary_url).to eq('https://example.com/')
    expect(external_tool.github_repo).to be_nil
    expect(external_tool.demo_url).to eq('https://demo.example.com')

    # Check Development category
    dev_category = Category.find_by(name: 'Development')
    expect(dev_category.category_items.count).to eq(1)

    # Check VS Code item - GitHub repo should be extracted from primary URL
    vscode = dev_category.category_items.first
    expect(vscode.name).to eq('VS Code')
    expect(vscode.primary_url).to eq('https://github.com/microsoft/vscode')
    expect(vscode.github_repo).to eq('microsoft/vscode')
    expect(vscode.demo_url).to be_nil
  end

  example 'demonstrates backward compatibility with url method' do
    parse_result = ParseMarkdownOperation.new.call(markdown_content:)
    persist_result = PersistParsedCategoriesOperation.new.call(
      awesome_list:,
      parsed_categories: parse_result.value!
    )

    aptabase = CategoryItem.find_by(name: 'Aptabase')

    # The url method should return primary_url for backward compatibility
    expect(aptabase.url).to eq(aptabase.primary_url)
    expect(aptabase.url).to eq('https://aptabase.com/')

    # But we can also access the GitHub repo separately
    expect(aptabase.repo_identifier).to eq('aptabase/aptabase')
  end

  example 'handles re-processing by clearing existing items' do
    # Create a separate awesome list for this test
    test_list = AwesomeList.create!(github_repo: 'test/reprocess', name: 'Reprocess Test List')

    # First processing
    parse_result = ParseMarkdownOperation.new.call(markdown_content:)
    PersistParsedCategoriesOperation.new.call(
      awesome_list: test_list,
      parsed_categories: parse_result.value!
    )

    test_list.reload
    expect(test_list.categories.count).to eq(2)

    total_items = test_list.categories.includes(:category_items).sum { |c| c.category_items.count }
    expect(total_items).to eq(3)

    # Second processing with different content
    new_markdown = <<~MARKDOWN
      ## Analytics
      - [New Tool](https://newtool.com/) - A new analytics tool ([Source Code](https://github.com/new/tool))
    MARKDOWN

    new_parse_result = ParseMarkdownOperation.new.call(markdown_content: new_markdown)
    PersistParsedCategoriesOperation.new.call(
      awesome_list: test_list,
      parsed_categories: new_parse_result.value!
    )

    # Should have only the new items for this awesome list
    test_list.reload
    expect(test_list.categories.count).to eq(1)
    expect(test_list.categories.first.category_items.count).to eq(1)
    expect(test_list.categories.first.category_items.first.name).to eq('New Tool')
    expect(test_list.categories.first.category_items.first.github_repo).to eq('new/tool')
  end
end
