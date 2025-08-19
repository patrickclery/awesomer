# frozen_string_literal: true

require 'rails_helper'
# require_relative '../../app/structs/category' # Rely on eager_load!
# require_relative '../../app/structs/category_item' # Rely on eager_load!

# Note: When referring to Category or CategoryItem in assertions (e.g. be_a(Category)),
# it will resolve to Structs::Category or Structs::CategoryItem due to how they are defined and loaded.

RSpec.describe ParseMarkdownOperation do
  subject(:operation_call) { described_class.new.call(markdown_content:) }

  context 'with basic markdown content including links and multi-line descriptions' do
    let(:markdown_content) do
      <<~MARKDOWN
        ## Category 1
        - [Project A](https://github.com/ownerA/projectA) - Description for A.
          This is a continuation of A's description.
        - [Project B](https://example.com/projectB) - Description for B.
        - [Project C](https://github.com/ownerC/projectC) No dash, so no description here.
          This line should NOT be part of C's description.
        - [Item D](https://example.com/itemD)
          This is D's description spanning multiple
          lines.

        ## Category 2
        * [Project E](https://github.com/ownerE/projectE.git) - Description for E with .git.
        * [No Description Item](https://no-desc.com)
          But this line IS a description for No Description Item.
        ## Category 3 - Empty Category
      MARKDOWN
    end

    it 'returns a Success result' do
      expect(operation_call).to be_success
    end

    it 'parses categories and items correctly, including descriptions' do
      result = operation_call.value!
      expect(result.size).to eq(2)

      # Category 1
      cat1 = result[0]
      expect(cat1[:name]).to eq('Category 1')
      expect(cat1[:items].size).to eq(4)

      expect(cat1[:items][0][:name]).to eq('Project A')
      expect(cat1[:items][0][:description]).to eq("Description for A.\nThis is a continuation of A's description.")
      expect(cat1[:items][0][:github_repo]).to eq('ownerA/projectA')
      expect(cat1[:items][0][:primary_url]).to eq('https://github.com/ownerA/projectA')

      expect(cat1[:items][1][:name]).to eq('Project B')
      expect(cat1[:items][1][:description]).to eq("Description for B.")
      expect(cat1[:items][1][:github_repo]).to be_nil
      expect(cat1[:items][1][:primary_url]).to eq('https://example.com/projectB')

      expect(cat1[:items][2][:name]).to eq('Project C')
      expect(cat1[:items][2][:description]).to eq("This line should NOT be part of C's description.")
      expect(cat1[:items][2][:github_repo]).to eq('ownerC/projectC')

      expect(cat1[:items][3][:name]).to eq('Item D')
      expect(cat1[:items][3][:description]).to eq("This is D's description spanning multiple\nlines.")

      # Category 2
      cat2 = result[1]
      expect(cat2[:name]).to eq('Category 2')
      expect(cat2[:items].size).to eq(2)
      expect(cat2[:items][0][:name]).to eq('Project E')
      expect(cat2[:items][0][:description]).to eq("Description for E with .git.")
      expect(cat2[:items][0][:github_repo]).to eq('ownerE/projectE')
      expect(cat2[:items][1][:name]).to eq('No Description Item')
      expect(cat2[:items][1][:description]).to eq("But this line IS a description for No Description Item.")

      # No cat3 expected
    end
  end

  context 'with category headers having extra spaces' do
    subject(:operation_call_spaced) { described_class.new.call(markdown_content:, skip_external_links: false) }

    let(:markdown_content) { "###   Category spaced   \n- [MyItem](https://example.com) - Desc line 1\n  Desc line 2" }

    it 'strips category names and creates correct item with multi-line description' do
      category = operation_call_spaced.value!.first
      expect(category[:name]).to eq('Category spaced')
      item = category[:items].first
      expect(item[:name]).to eq('MyItem')
      expect(item[:description]).to eq("Desc line 1\nDesc line 2")
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

    it 'only includes valid category items' do
      category = operation_call.value!.first
      expect(category).to be_a(Hash)
      expect(category[:name]).to eq('Mixed Items')
      expect(category[:items].size).to eq(2)

      item1 = category[:items][0]
      expect(item1).to be_a(Hash)
      expect(item1[:id]).to eq(1)
      expect(item1[:name]).to eq('Valid Item')
      expect(item1[:primary_url]).to eq('https://github.com/foo/bar')
      expect(item1[:github_repo]).to eq('foo/bar')

      item2 = category[:items][1]
      expect(item2).to be_a(Hash)
      expect(item2[:id]).to eq(2)
      expect(item2[:name]).to eq('Almost Item')
      expect(item2[:primary_url]).to eq('https://almost.com')
      expect(item2[:github_repo]).to be_nil
    end
  end

  context 'when a category has no items' do
    subject(:operation_call_no_items) { described_class.new.call(markdown_content:, skip_external_links: false) }

    let(:markdown_content) { "## Empty Category\n## Category With Item\n- [My Test Item](g.co/l) - D" }

    it 'parses correctly, skipping empty categories' do
      result = operation_call_no_items.value!
      expect(result.size).to eq(1) # Only "Category With Item" should be present
      cat_with_item = result.first
      expect(cat_with_item[:name]).to eq('Category With Item')
      expect(cat_with_item[:items].first[:description]).to eq("D")
    end
  end

  context 'with items before any category' do
    let(:markdown_content) { "- [Orphan Item](https://orphan.com) - Orphan desc\n## Category 1\n- [Item 1.1](https://github.com/cat/one) - Desc 1.1" }

    it 'ignores items before the first category and parses subsequent correctly' do
      result = operation_call.value!
      expect(result.size).to eq(1)
      category = result.first
      expect(category).to be_a(Hash)
      expect(category[:name]).to eq('Category 1')
      expect(category[:custom_order]).to eq(0)
      expect(category[:items].size).to eq(1)
      item = category[:items].first
      expect(item).to be_a(Hash)
      expect(item[:id]).to eq(1)
      expect(item[:name]).to eq('Item 1.1')
      expect(item[:primary_url]).to eq('https://github.com/cat/one')
      expect(item[:github_repo]).to eq('cat/one')
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

  context 'with skip_external_links option' do
    let(:markdown_with_mixed_links) do
      <<~MARKDOWN
        ## Mixed Links Category
        - [GitHub Project](https://github.com/user/project) - A GitHub link.
        - [External Link](http://example.com/external) - An external link.
        - [Another GitHub](https://github.com/user/another) - Another GitHub link.
        - [HTTP Site](http://othersite.com) - Another external link.

        ## Only External Links Category
        - [External Site A](http://externalsite.com/a)
        - [External Site B](http://externalsite.com/b)

        ## Only GitHub Links Category
        - [GH Only 1](https://github.com/gh/only1)
        - [GH Only 2](https://github.com/gh/only2)

        ## Empty Items Category Initially
        - No actual links here
      MARKDOWN
    end

    context 'when skip_external_links is true (default or explicit)' do
      it 'omits categories that only contain non-GitHub links (or become empty after skipping)' do
        result = described_class.new.call(markdown_content: markdown_with_mixed_links, skip_external_links: true)
        categories = result.value!
        expect(categories.size).to eq(2)
        expect(categories.map { |c| c[:name] }).to match_array([ "Mixed Links Category", "Only GitHub Links Category" ])
        expect(categories.find { |c| c[:name] == "Only External Links Category" }).to be_nil
        expect(categories.find { |c| c[:name] == "Empty Items Category Initially" }).to be_nil
      end

      it 'skips non-GitHub links' do
        result = described_class.new.call(markdown_content: markdown_with_mixed_links, skip_external_links: true)
        categories = result.value!
        mixed_cat = categories.find { |c| c[:name] == "Mixed Links Category" }
        expect(mixed_cat[:items].map { |item| item[:name] }).to eq([ "GitHub Project", "Another GitHub" ])
      end

      it 'includes categories that only contain GitHub links' do
        result = described_class.new.call(markdown_content: markdown_with_mixed_links, skip_external_links: true)
        categories = result.value!
        gh_only_cat = categories.find { |c| c[:name] == "Only GitHub Links Category" }
        expect(gh_only_cat).not_to be_nil
        expect(gh_only_cat[:items].map { |item| item[:name] }).to eq([ "GH Only 1", "GH Only 2" ])
      end

      it 'includes items with GitHub Source Code links and uses GitHub URL as primary' do
        markdown_with_source_code = <<~MARKDOWN
          ## Mixed Sources
          - [External with GitHub](https://external.com/) - External site with source code. ([Source Code](https://github.com/owner/repo))
          - [Pure External](https://pure-external.com/) - No GitHub source code.
          - [Direct GitHub](https://github.com/direct/repo) - Direct GitHub link.
        MARKDOWN

        result = described_class.new.call(markdown_content: markdown_with_source_code, skip_external_links: true)
        categories = result.value!
        expect(categories.size).to eq(1)

        category = categories.first
        expect(category[:items].size).to eq(2) # Only items with GitHub repos

        # Item with GitHub source code should be included and use GitHub URL as primary
        external_with_github = category[:items][0]
        expect(external_with_github[:name]).to eq('External with GitHub')
        expect(external_with_github[:primary_url]).to eq('https://github.com/owner/repo')
        expect(external_with_github[:github_repo]).to eq('owner/repo')

        # Direct GitHub item should be included
        direct_github = category[:items][1]
        expect(direct_github[:name]).to eq('Direct GitHub')
        expect(direct_github[:primary_url]).to eq('https://github.com/direct/repo')
        expect(direct_github[:github_repo]).to eq('direct/repo')
      end
    end

    context 'when skip_external_links is false' do
      it 'includes all links (GitHub and external)' do
        result = described_class.new.call(markdown_content: markdown_with_mixed_links, skip_external_links: false)
        categories = result.value!
        mixed_cat = categories.find { |c| c[:name] == "Mixed Links Category" }
        expect(mixed_cat[:items].map { |item|
 item[:name] }).to eq([ "GitHub Project", "External Link", "Another GitHub", "HTTP Site" ])
        external_only_cat = categories.find { |c| c[:name] == "Only External Links Category" }
        expect(external_only_cat).not_to be_nil
        expect(external_only_cat[:items].map { |item| item[:name] }).to eq([ "External Site A", "External Site B" ])
      end
    end
  end

  context 'with Source Code links in descriptions' do
    let(:markdown_content) do
      <<~MARKDOWN
        ## Applications
        - [Aptabase](https://aptabase.com/) - Privacy first and simple analytics for mobile and desktop apps. ([Source Code](https://github.com/aptabase/aptabase)) `AGPL-3.0` `Docker`
        - [Regular Project](https://example.com/regular) - A regular project without source code link.
        - [Multiple Links](https://main-site.com/) - Has multiple links ([Demo](https://demo.com)) ([Source Code](https://github.com/user/repo)) ([Docs](https://docs.com))
        - [Case Insensitive](https://site.com/) - Testing case insensitive matching ([source code](https://github.com/case/test))
      MARKDOWN
    end

    it 'extracts different URL types correctly' do
      result = operation_call.value!
      expect(result.size).to eq(1)

      category = result.first
      expect(category[:name]).to eq('Applications')
      expect(category[:items].size).to eq(4)

      # First item should keep original URL as primary, but extract GitHub repo from Source Code link
      aptabase = category[:items][0]
      expect(aptabase[:name]).to eq('Aptabase')
      expect(aptabase[:primary_url]).to eq('https://aptabase.com/')
      expect(aptabase[:github_repo]).to eq('aptabase/aptabase')
      expect(aptabase[:description]).to include('Privacy first and simple analytics')

      # Second item has no Source Code link, should have no GitHub repo
      regular = category[:items][1]
      expect(regular[:name]).to eq('Regular Project')
      expect(regular[:primary_url]).to eq('https://example.com/regular')
      expect(regular[:github_repo]).to be_nil

      # Third item should keep original URL as primary, but extract GitHub repo from Source Code link
      multiple = category[:items][2]
      expect(multiple[:name]).to eq('Multiple Links')
      expect(multiple[:primary_url]).to eq('https://main-site.com/')
      expect(multiple[:github_repo]).to eq('user/repo')
      expect(multiple[:demo_url]).to eq('https://demo.com')

      # Fourth item tests case insensitive matching
      case_test = category[:items][3]
      expect(case_test[:name]).to eq('Case Insensitive')
      expect(case_test[:primary_url]).to eq('https://site.com/')
      expect(case_test[:github_repo]).to eq('case/test')
    end

    it 'keeps Source Code and Demo links in descriptions' do
      result = operation_call.value!
      aptabase = result.first[:items].first

      # Source Code link should be kept in description
      expect(aptabase[:description]).to include('([Source Code](https://github.com/aptabase/aptabase))')
      # Core description and metadata should also remain
      expect(aptabase[:description]).to include('Privacy first and simple analytics')
      expect(aptabase[:description]).to include('`AGPL-3.0` `Docker`')

      # Test multiple links are kept
      multiple = result.first[:items][2]
      expect(multiple[:description]).to include('([Demo](https://demo.com))')
      expect(multiple[:description]).to include('([Source Code](https://github.com/user/repo))')
      expect(multiple[:description]).to include('([Docs](https://docs.com))')
      expect(multiple[:description]).to include('Has multiple links')

      # Test case insensitive links are kept
      case_test = result.first[:items][3]
      expect(case_test[:description]).to include('([source code](https://github.com/case/test))')
      expect(case_test[:description]).to include('Testing case insensitive matching')
    end
  end
end
