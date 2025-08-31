# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractAwesomeListsOperation do
  include Dry::Monads[:result]

  subject(:operation) { described_class.new }

  describe '#call' do
    context 'with valid markdown content containing GitHub links' do
      let(:markdown_content) do
        <<~MARKDOWN
          # Awesome Lists

          ## Platforms
          - [Node.js](https://github.com/sindresorhus/awesome-nodejs) - Awesome Node.js packages and resources.
          - [Frontend Development](https://github.com/dypsilon/frontend-dev-bookmarks) - Frontend development resources.

          ## Programming Languages
          - [JavaScript](https://github.com/sorrycc/awesome-javascript) - JavaScript libraries and resources.
          - [Python](https://github.com/vinta/awesome-python) - Python frameworks, libraries, and resources.

          Also check out https://github.com/awesomedata/awesome-public-datasets for public datasets.

          Some plain text and other content.
        MARKDOWN
      end

      example 'returns success with extracted repository identifiers' do
        result = operation.call(markdown_content:)
        expect(result).to be_success

        repo_links = result.value!
        expect(repo_links).to include(
          'awesomedata/awesome-public-datasets',
          'dypsilon/frontend-dev-bookmarks',
          'sindresorhus/awesome-nodejs',
          'sorrycc/awesome-javascript',
          'vinta/awesome-python'
        )
        expect(repo_links.size).to eq(5)
        expect(repo_links).to eq(repo_links.sort) # Should be sorted alphabetically
      end
    end

    context 'with markdown containing duplicate links' do
      let(:markdown_content) do
        <<~MARKDOWN
          - [Node.js](https://github.com/sindresorhus/awesome-nodejs) - First mention.
          - [Node.js Again](https://github.com/sindresorhus/awesome-nodejs) - Duplicate mention.

          Also: https://github.com/sindresorhus/awesome-nodejs (plain URL)
        MARKDOWN
      end

      example 'removes duplicates and returns unique repositories' do
        result = operation.call(markdown_content:)
        expect(result).to be_success

        repo_links = result.value!
        expect(repo_links).to eq(['sindresorhus/awesome-nodejs'])
        expect(repo_links.size).to eq(1)
      end
    end

    context 'with markdown containing GitHub URLs with various formats' do
      let(:markdown_content) do
        <<~MARKDOWN
          - [Repo1](https://github.com/owner1/repo1) - Basic link
          - [Repo2](https://github.com/owner2/repo2/) - With trailing slash
          - [Repo3](https://github.com/owner3/repo3#readme) - With anchor
          - [Repo4](https://github.com/owner4/repo4.git) - With .git suffix

          Plain URLs:
          https://github.com/owner5/repo5
          https://github.com/owner6/repo6/
        MARKDOWN
      end

      example 'correctly cleans and extracts all repository identifiers' do
        result = operation.call(markdown_content:)
        expect(result).to be_success

        repo_links = result.value!
        expect(repo_links).to match_array([
          'owner1/repo1',
          'owner2/repo2',
          'owner3/repo3',
          'owner4/repo4',
          'owner5/repo5',
          'owner6/repo6'
        ])
      end
    end

    context 'with markdown containing non-GitHub links' do
      let(:markdown_content) do
        <<~MARKDOWN
          - [GitHub](https://github.com/sindresorhus/awesome-nodejs) - Valid GitHub repo
          - [Google](https://google.com) - Not a GitHub link
          - [Documentation Site](https://docs.example.com) - External docs
        MARKDOWN
      end

      example 'only extracts valid GitHub repository links' do
        result = operation.call(markdown_content:)
        expect(result).to be_success

        repo_links = result.value!
        expect(repo_links).to eq(['sindresorhus/awesome-nodejs'])
      end
    end

    context 'with empty markdown content' do
      let(:markdown_content) { '' }

      example 'returns success with empty array' do
        result = operation.call(markdown_content:)
        expect(result).to be_success
        expect(result.value!).to eq([])
      end
    end

    context 'with nil markdown content' do
      let(:markdown_content) { nil }

      example 'returns failure' do
        result = operation.call(markdown_content:)
        expect(result).to be_failure
        expect(result.failure).to eq('Markdown content is required')
      end
    end

    context 'with blank markdown content' do
      let(:markdown_content) { '   ' }

      example 'returns success with empty array' do
        result = operation.call(markdown_content:)
        expect(result).to be_success
        expect(result.value!).to eq([])
      end
    end

    context 'with markdown content containing no GitHub links' do
      let(:markdown_content) do
        <<~MARKDOWN
          # Some Document

          This is just regular markdown content without any GitHub repository links.

          - [Example](https://example.com) - External link
          - [Another Site](https://another-site.org) - Another external link
        MARKDOWN
      end

      example 'returns success with empty array' do
        result = operation.call(markdown_content:)
        expect(result).to be_success
        expect(result.value!).to eq([])
      end
    end
  end
end
