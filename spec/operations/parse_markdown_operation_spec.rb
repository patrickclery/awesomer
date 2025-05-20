# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParseMarkdownOperation do
  subject(:operation_call) { described_class.new.call(markdown_content:) }

  context 'with basic markdown content including links' do
    let(:markdown_content) do
      <<~MARKDOWN
        ## Category 1
        - [Project A](https://github.com/ownerA/projectA) - Description for A.
        - [Project B](https://example.com/projectB) - Description for B.
        - [Project C](https://github.com/ownerC/projectC)#{' '}
        - [Link D](https://example.com/linkD)

        ## Category 2
        * [Project E](https://github.com/ownerE/projectE.git) - Description for E with .git.
        * [No Description Link](https://no-desc.com)
      MARKDOWN
    end

    it 'returns a Success result' do
      expect(operation_call).to be_success
    end

    it 'parses categories and structured items correctly' do
      expected_structure = [
        {
          items: [
            {description: 'Description for A.', name: 'Project A', repo_abbreviation: 'ownerA/projectA'},
            {description: 'Description for B.', name: 'Project B', url: 'https://example.com/projectB'},
            {description: nil, name: 'Project C', repo_abbreviation: 'ownerC/projectC'},
            {description: nil, name: 'Link D', url: 'https://example.com/linkD'}
          ],
          name: 'Category 1'
        },
        {
          items: [
            {description: 'Description for E with .git.', name: 'Project E', repo_abbreviation: 'ownerE/projectE'},
            {description: nil, name: 'No Description Link', url: 'https://no-desc.com'}
          ],
          name: 'Category 2'
        }
      ]
      expect(operation_call.value!).to eq(expected_structure)
    end
  end

  context 'with category headers having extra spaces' do
    let(:markdown_content) { "##   Category spaced   \n- [Link](https://example.com) - Desc" }

    it 'strips category names' do
      expect(operation_call.value!.first[:name]).to eq('Category spaced')
      expect(operation_call.value!.first[:items].first).to eq({description: 'Desc', name: 'Link', url: 'https://example.com'})
    end
  end

  context 'with malformed link items or simple text items' do
    let(:markdown_content) do
      <<~MARKDOWN
        ## Mixed Items
        - Just some text item, not a link.
        - [Valid Link](https://github.com/foo/bar) - With description.
        - Another plain text.
        - [NoCloseBracket(https://broken.com)
        - [Almost Link](https://almost.com) but no dash then description
      MARKDOWN
    end

    it 'only includes items matching the LINK_ITEM_REGEX structure' do
      # The LINK_ITEM_REGEX will match "[Almost Link](https://almost.com)".
      # The trailing " but no dash then description" is ignored as it doesn't start with " - ".
      expected_items = [
        {description: 'With description.', name: 'Valid Link', repo_abbreviation: 'foo/bar'},
        {description: nil, name: 'Almost Link', url: 'https://almost.com'} # Corrected expectation
      ]
      # Ensure the test checks the actual items list of the first (and only) category
      expect(operation_call.value!.first[:items]).to eq(expected_items)
    end
  end

  context 'with multi-line descriptions for complex link items' do
    let(:markdown_content) do
      <<~MARKDOWN
        ## Category Multi-line
        - [Item One](https://github.com/multi/one) - This is item one.
          Its description continues on this line.
          And even on this one.
        - [Item Two](https://example.com/two) - Description for two.
          Followed by another line for two.
      MARKDOWN
    end

    it 'appends subsequent lines to the item description' do
      expected_items = [
        {
          description: "This is item one.\nIts description continues on this line.\nAnd even on this one.",
          name: 'Item One',
          repo_abbreviation: 'multi/one'
        },
        {
          description: "Description for two.\nFollowed by another line for two.",
          name: 'Item Two',
          url: 'https://example.com/two'
        }
      ]
      expect(operation_call.value!.first[:items]).to eq(expected_items)
    end
  end

  context 'when a category has no items' do
    let(:markdown_content) { "## Empty Category\n## Category With Item\n- [L](g.co/l) - D" }

    it 'parses correctly' do
      expected_structure = [
        {items: [], name: 'Empty Category'},
        {items: [ {description: 'D', name: 'L', url: 'g.co/l'} ], name: 'Category With Item'}
      ]
      expect(operation_call.value!).to eq(expected_structure)
    end
  end

  context 'with items before any category' do
    let(:markdown_content) { "- [Orphan](https://orphan.com) - Orphan desc\n## Category 1\n- [Item 1.1](https://github.com/cat/one) - Desc 1.1" }

    it 'ignores items before the first category' do
      expect(operation_call.value!).to eq([
        {items: [ {description: 'Desc 1.1', name: 'Item 1.1', repo_abbreviation: 'cat/one'} ], name: 'Category 1'}
      ])
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
      expect(operation_call.failure).to eq('Failed to parse markdown: Simulated processing error')
    end
  end
end
