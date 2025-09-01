# frozen_string_literal: true

require 'rails_helper'

RSpec.describe H3AwesomeListAdapter do
  let(:adapter) { described_class.new }

  describe '#matches?' do
    context 'with H3-based awesome list format' do
      let(:content) do
        <<~MARKDOWN
          # Awesome Decentralized

          ### Applications
          * [Item1](https://github.com/user/repo1): Description 1
          * [Item2](https://github.com/user/repo2): Description 2
          * [Item3](https://github.com/user/repo3): Description 3
          * [Item4](https://github.com/user/repo4): Description 4
          * [Item5](https://github.com/user/repo5): Description 5

          ### Tools
          * [Tool1](https://github.com/user/tool1): Tool description
        MARKDOWN
      end

      it 'returns true' do
        expect(adapter.matches?(content)).to be(true)
      end
    end

    context 'with H2-based awesome list format' do
      let(:content) do
        <<~MARKDOWN
          # Awesome List

          ## Applications
          - [Item1](https://github.com/user/repo1) - Description 1
          - [Item2](https://github.com/user/repo2) - Description 2
          - [Item3](https://github.com/user/repo3) - Description 3
          - [Item4](https://github.com/user/repo4) - Description 4
          - [Item5](https://github.com/user/repo5) - Description 5

          ## Tools
          - [Tool1](https://github.com/user/tool1) - Tool description
        MARKDOWN
      end

      it 'returns false' do
        expect(adapter.matches?(content)).to be(false)
      end
    end

    context 'with mixed H2 and H3 headers' do
      let(:content) do
        <<~MARKDOWN
          # Awesome List

          ## Main Category
          - [Item1](https://github.com/user/repo1) - Description 1

          ### Subcategory
          * [Item2](https://github.com/user/repo2): Description 2
        MARKDOWN
      end

      it 'returns false when H2 categories exist' do
        expect(adapter.matches?(content)).to be(false)
      end
    end

    context 'with insufficient items' do
      let(:content) do
        <<~MARKDOWN
          ### Applications
          * [Item1](https://github.com/user/repo1): Description 1
          * [Item2](https://github.com/user/repo2): Description 2
        MARKDOWN
      end

      it 'returns false' do
        expect(adapter.matches?(content)).to be(false)
      end
    end

    context 'with blank content' do
      it 'returns false' do
        expect(adapter.matches?('')).to be(false)
        expect(adapter.matches?(nil)).to be(false)
      end
    end
  end

  describe '#priority' do
    it 'has higher priority than standard adapter' do
      expect(adapter.priority).to eq(15)
      expect(adapter.priority).to be > StandardAwesomeListAdapter.new.priority
    end
  end

  describe '#parse' do
    context 'with valid H3 content' do
      let(:content) do
        <<~MARKDOWN
          # Awesome Decentralized

          Some introduction text here.

          ### Applications
          * [Aether](https://github.com/aethereans/aether-app): P2P ephemeral public communities
          * [Agregore](https://github.com/AgregoreWeb/agregore-browser): A minimalistic web browser
          * [External Tool](https://example.com/tool): Not on GitHub

          ### Other
          * [Bitcoin](https://github.com/bitcoin/bitcoin): Digital currency
          * [Another Item](https://gitlab.com/project): On GitLab

          ### Related Lists
          * [Awesome P2P](https://github.com/user/awesome-p2p): Another list
        MARKDOWN
      end

      let(:result) { adapter.parse(content) }

      it 'returns Success monad' do
        expect(result).to be_success
      end

      it 'parses H3 headers as categories' do
        categories = result.value!
        expect(categories.map { |c| c[:name] }).to eq(%w[Applications Other])
      end

      it 'excludes Related Lists category' do
        categories = result.value!
        expect(categories.map { |c| c[:name] }).not_to include('Related Lists')
      end

      it 'parses items with asterisk bullets' do
        categories = result.value!
        applications = categories.find { |c| c[:name] == 'Applications' }
        expect(applications[:items].size).to eq(3)
      end

      it 'extracts item properties correctly' do
        categories = result.value!
        applications = categories.find { |c| c[:name] == 'Applications' }
        first_item = applications[:items].first

        expect(first_item[:name]).to eq('Aether')
        expect(first_item[:primary_url]).to eq('https://github.com/aethereans/aether-app')
        expect(first_item[:description]).to eq('P2P ephemeral public communities')
        expect(first_item[:github_repo]).to eq('aethereans/aether-app')
      end

      it 'handles items with colon separator' do
        categories = result.value!
        applications = categories.find { |c| c[:name] == 'Applications' }
        items = applications[:items]

        items.each do |item|
          expect(item[:description]).not_to include(':')
        end
      end

      it 'handles non-GitHub URLs' do
        categories = result.value!
        applications = categories.find { |c| c[:name] == 'Applications' }
        external_item = applications[:items].find { |i| i[:name] == 'External Tool' }

        expect(external_item[:primary_url]).to eq('https://example.com/tool')
        expect(external_item[:github_repo]).to be_nil
      end

      context 'with skip_external_links option' do
        let(:result) { adapter.parse(content, skip_external_links: true) }

        it 'excludes non-GitHub items' do
          categories = result.value!
          applications = categories.find { |c| c[:name] == 'Applications' }
          item_names = applications[:items].map { |i| i[:name] }

          expect(item_names).to include('Aether', 'Agregore')
          expect(item_names).not_to include('External Tool')
        end
      end
    end

    context 'with multiline descriptions' do
      let(:content) do
        <<~MARKDOWN
          ### Tools
          * [Tool1](https://github.com/user/tool1): First line
            continuation of description
            another line
          * [Tool2](https://github.com/user/tool2): Single line description
        MARKDOWN
      end

      it 'concatenates multiline descriptions' do
        result = adapter.parse(content)
        categories = result.value!
        tools = categories.first
        first_item = tools[:items].first

        expect(first_item[:description]).to eq('First line continuation of description another line')
      end
    end

    context 'with empty content' do
      it 'returns empty array for blank content' do
        expect(adapter.parse('').value!).to eq([])
        expect(adapter.parse(nil).value!).to eq([])
      end
    end

    context 'with invalid content' do
      let(:content) { 'Just some text without proper structure' }

      it 'returns empty array' do
        result = adapter.parse(content)
        expect(result).to be_success
        expect(result.value!).to eq([])
      end
    end

    context 'with special characters in names' do
      let(:content) do
        <<~MARKDOWN
          ### Applications
          * [Tool ☠️](https://github.com/user/tool): Deprecated tool
          * [App-Name_2.0](https://github.com/user/app): Complex name
        MARKDOWN
      end

      it 'preserves special characters in names' do
        result = adapter.parse(content)
        categories = result.value!
        items = categories.first[:items]

        expect(items[0][:name]).to eq('Tool ☠️')
        expect(items[1][:name]).to eq('App-Name_2.0')
      end
    end

    context 'with custom_order' do
      let(:content) do
        <<~MARKDOWN
          ### First Category
          * [Item1](https://github.com/user/repo1): Description

          ### Second Category
          * [Item2](https://github.com/user/repo2): Description
        MARKDOWN
      end

      it 'assigns incremental custom_order values' do
        result = adapter.parse(content)
        categories = result.value!

        expect(categories[0][:custom_order]).to eq(0)
        expect(categories[1][:custom_order]).to eq(1)
      end
    end
  end
end
