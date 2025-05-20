# frozen_string_literal: true

require 'rails_helper'
# require_relative '../../app/structs/category' # Rely on eager_load!
# require_relative '../../app/structs/category_item' # Rely on eager_load!

# Note: When referring to Category or CategoryItem in assertions (e.g. be_a(Category)),
# it will resolve to Structs::Category or Structs::CategoryItem due to how they are defined and loaded.

RSpec.describe ParseMarkdownOperation do
  subject(:operation_call) { described_class.new.call(markdown_content:) }

  context 'with basic markdown content including links' do
    let(:markdown_content) do
      <<~MARKDOWN
        ## Category 1
        - [Project A](https://github.com/ownerA/projectA) - Description for A.
        - [Project B](https://example.com/projectB) - Description for B.
        - [Project C](https://github.com/ownerC/projectC)
        - [Item D](https://example.com/itemD)

        ## Category 2
        * [Project E](https://github.com/ownerE/projectE.git) - Description for E with .git.
        * [No Description Item](https://no-desc.com)
      MARKDOWN
    end

    it 'returns a Success result' do
      expect(operation_call).to be_success
    end

    it 'parses categories and items correctly into Structs::Category and Structs::CategoryItem structs' do
      result = operation_call.value!
      expect(result.size).to eq(2)

      # Category 1
      cat1 = result.first
      expect(cat1).to be_a(Structs::Category)
      expect(cat1.name).to eq('Category 1')
      expect(cat1.custom_order).to eq(0)
      expect(cat1.repos.size).to eq(4)

      item1_cat1 = cat1.repos[0]
      expect(item1_cat1).to be_a(Structs::CategoryItem)
      expect(item1_cat1.id).to eq(1)
      expect(item1_cat1.name).to eq('Project A')
      expect(item1_cat1.url).to eq('https://github.com/ownerA/projectA')
      expect(item1_cat1.commits_past_year).to be_nil
      expect(item1_cat1.last_commit_at).to be_nil
      expect(item1_cat1.stars).to be_nil

      item2_cat1 = cat1.repos[1]
      expect(item2_cat1).to be_a(Structs::CategoryItem)
      expect(item2_cat1.id).to eq(2)
      expect(item2_cat1.name).to eq('Project B')
      expect(item2_cat1.url).to eq('https://example.com/projectB')
      expect(item2_cat1.commits_past_year).to be_nil
      expect(item2_cat1.last_commit_at).to be_nil
      expect(item2_cat1.stars).to be_nil

      expect(cat1.repos[2]).to be_a(Structs::CategoryItem)
      expect(cat1.repos[2].id).to eq(3)
      expect(cat1.repos[2].name).to eq('Project C')
      expect(cat1.repos[2].url).to eq('https://github.com/ownerC/projectC')
      expect(cat1.repos[2].commits_past_year).to be_nil
      expect(cat1.repos[2].last_commit_at).to be_nil
      expect(cat1.repos[2].stars).to be_nil

      expect(cat1.repos[3]).to be_a(Structs::CategoryItem)
      expect(cat1.repos[3].id).to eq(4)
      expect(cat1.repos[3].name).to eq('Item D')
      expect(cat1.repos[3].url).to eq('https://example.com/itemD')
      expect(cat1.repos[3].commits_past_year).to be_nil
      expect(cat1.repos[3].last_commit_at).to be_nil
      expect(cat1.repos[3].stars).to be_nil

      # Category 2
      cat2 = result.last
      expect(cat2).to be_a(Structs::Category)
      expect(cat2.name).to eq('Category 2')
      expect(cat2.custom_order).to eq(1)
      expect(cat2.repos.size).to eq(2)

      expect(cat2.repos[0]).to be_a(Structs::CategoryItem)
      expect(cat2.repos[0].id).to eq(5) # Link ID counter continues
      expect(cat2.repos[0].name).to eq('Project E')
      expect(cat2.repos[0].url).to eq('https://github.com/ownerE/projectE.git')
      expect(cat2.repos[0].commits_past_year).to be_nil
      expect(cat2.repos[0].last_commit_at).to be_nil
      expect(cat2.repos[0].stars).to be_nil

      expect(cat2.repos[1]).to be_a(Structs::CategoryItem)
      expect(cat2.repos[1].id).to eq(6)
      expect(cat2.repos[1].name).to eq('No Description Item')
      expect(cat2.repos[1].url).to eq('https://no-desc.com')
      expect(cat2.repos[1].commits_past_year).to be_nil
      expect(cat2.repos[1].last_commit_at).to be_nil
      expect(cat2.repos[1].stars).to be_nil

      cat1.repos[2..].each do |item|
        expect(item).to be_a(Structs::CategoryItem)
        expect(item.commits_past_year).to be_nil
        expect(item.last_commit_at).to be_nil
        expect(item.stars).to be_nil
      end

      cat2.repos.each do |item|
        expect(item).to be_a(Structs::CategoryItem)
        expect(item.commits_past_year).to be_nil
        expect(item.last_commit_at).to be_nil
        expect(item.stars).to be_nil
      end
    end
  end

  context 'with category headers having extra spaces' do
    let(:markdown_content) { "##   Category spaced   \n- [MyItem](https://example.com) - Desc" }

    it 'strips category names and creates correct Structs::CategoryItem struct' do
      category = operation_call.value!.first
      item = category.repos.first
      expect(item).to be_a(Structs::CategoryItem)
      expect(item.name).to eq('MyItem')
      expect(item.id).to eq(1)
      expect(item.url).to eq('https://example.com')
      expect(item.commits_past_year).to be_nil
      expect(item.last_commit_at).to be_nil
      expect(item.stars).to be_nil
    end
  end

  context 'with malformed link items or simple text items' do
    let(:markdown_content) do
      <<~MARKDOWN
        ## Mixed Items
        - Just some text item, not a link.
        - [Valid Item](https://github.com/foo/bar) - With description.
        - Another plain text.
        - [NoCloseBracket(https://broken.com)
        - [Almost Item](https://almost.com) but no dash then description
      MARKDOWN
    end

    it 'only includes valid Structs::CategoryItem structs' do
      category = operation_call.value!.first
      expect(category).to be_a(Structs::Category)
      expect(category.name).to eq('Mixed Items')
      expect(category.repos.size).to eq(2)

      item1 = category.repos[0]
      expect(item1).to be_a(Structs::CategoryItem)
      expect(item1.id).to eq(1)
      expect(item1.name).to eq('Valid Item')
      expect(item1.url).to eq('https://github.com/foo/bar')
      expect(item1.commits_past_year).to be_nil
      expect(item1.last_commit_at).to be_nil
      expect(item1.stars).to be_nil

      item2 = category.repos[1]
      expect(item2).to be_a(Structs::CategoryItem)
      expect(item2.id).to eq(2)
      expect(item2.name).to eq('Almost Item')
      expect(item2.url).to eq('https://almost.com')
      expect(item2.commits_past_year).to be_nil
      expect(item2.last_commit_at).to be_nil
      expect(item2.stars).to be_nil
    end
  end

  context 'when a category has no items' do
    let(:markdown_content) { "## Empty Category\n## Category With Item\n- [My Test Item](g.co/l) - D" }

    it 'parses correctly, Structs::CategoryItem struct has nil for new fields' do
      result = operation_call.value!
      expect(result.size).to eq(2)

      empty_cat = result.first
      expect(empty_cat.name).to eq('Empty Category')
      expect(empty_cat.custom_order).to eq(0)
      expect(empty_cat.repos).to be_empty

      cat_with_item = result.last
      expect(cat_with_item).to be_a(Structs::Category)
      expect(cat_with_item.name).to eq('Category With Item')
      expect(cat_with_item.custom_order).to eq(1)
      expect(cat_with_item.repos.size).to eq(1)
      item = cat_with_item.repos.first
      expect(item).to be_a(Structs::CategoryItem)
      expect(item.id).to eq(1) # Link ID is per operation call, resets for this test case implicitly
      expect(item.name).to eq('My Test Item')
      expect(item.url).to eq('g.co/l')
      expect(item.commits_past_year).to be_nil
      expect(item.last_commit_at).to be_nil
      expect(item.stars).to be_nil
    end
  end

  context 'with items before any category' do
    let(:markdown_content) { "- [Orphan Item](https://orphan.com) - Orphan desc\n## Category 1\n- [Item 1.1](https://github.com/cat/one) - Desc 1.1" }

    it 'ignores items before the first category and parses subsequent correctly' do
      result = operation_call.value!
      expect(result.size).to eq(1)
      category = result.first
      expect(category).to be_a(Structs::Category)
      expect(category.name).to eq('Category 1')
      expect(category.custom_order).to eq(0)
      expect(category.repos.size).to eq(1)
      item = category.repos.first
      expect(item).to be_a(Structs::CategoryItem)
      expect(item.id).to eq(1)
      expect(item.name).to eq('Item 1.1')
      expect(item.url).to eq('https://github.com/cat/one')
      expect(item.commits_past_year).to be_nil
      expect(item.last_commit_at).to be_nil
      expect(item.stars).to be_nil
    end
  end

  context 'when markdown content is blank or nil' do
    [ nil, '', '   ' ].each do |content|
      context "with content: #{content.inspect}" do
        let(:markdown_content) { content }

        it 'returns Success with an empty array' do
          expect(operation_call).to be_success
          expect(operation_call.value!).to eq([])
        end
      end
    end
  end

  context 'when an error occurs during parsing (e.g., bad regex input)' do
    subject(:operation_call) { described_class.new.call(markdown_content: failing_markdown_content) }

    let(:failing_markdown_content) { instance_double(String, :failing_markdown_content) }

    before do
      allow(failing_markdown_content).to receive(:blank?).and_return(false)
      allow(failing_markdown_content).to receive(:lines).and_raise(StandardError.new("Simulated processing error"))
    end

    it 'returns a Failure result' do
      expect(operation_call).to be_failure
    end

    it 'includes the error message in the failure' do
      expect(operation_call.failure).to eq('Failed to parse markdown (Standard error): Simulated processing error')
    end
  end
end
