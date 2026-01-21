# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessCategoryServiceEnhanced do
  let(:service) { described_class.new }
  let(:awesome_list) { create(:awesome_list, github_repo: 'test/awesome-test') }

  describe '#call' do
    context 'when categories are in random order' do
      let!(:category_z) { create(:category, awesome_list: awesome_list, name: 'Zebra Category') }
      let!(:category_a) { create(:category, awesome_list: awesome_list, name: 'Alpha Category') }
      let!(:category_m) { create(:category, awesome_list: awesome_list, name: 'Middle Category') }

      before do
        # Create items for each category so they're not empty
        create(:category_item, category: category_z, name: 'Item Z', primary_url: 'https://example.com/z', stars: 100)
        create(:category_item, category: category_a, name: 'Item A', primary_url: 'https://example.com/a', stars: 200)
        create(:category_item, category: category_m, name: 'Item M', primary_url: 'https://example.com/m', stars: 150)
      end

      example 'generates categories in alphabetical order' do
        result = service.call(awesome_list: awesome_list)

        expect(result).to be_success
        file_path = result.value!
        expect(File.exist?(file_path)).to be true

        content = File.read(file_path)

        # Extract category headers in order they appear (excluding Table of Contents)
        category_headers = content.scan(/^## (.+)$/).flatten.reject { |h| h == 'Table of Contents' }

        expect(category_headers).to eq(['Alpha Category', 'Middle Category', 'Zebra Category'])
      end

      example 'maintains alphabetical order across multiple generations' do
        # Generate markdown multiple times and verify order is consistent
        results = []

        3.times do
          result = service.call(awesome_list: awesome_list)
          expect(result).to be_success

          content = File.read(result.value!)
          category_headers = content.scan(/^## (.+)$/).flatten.reject { |h| h == 'Table of Contents' }
          results << category_headers
        end

        # All three generations should have identical ordering
        expect(results.uniq.size).to eq(1)
        expect(results.first).to eq(['Alpha Category', 'Middle Category', 'Zebra Category'])
      end
    end

    context 'when GitHub items have missing stars' do
      let!(:category) { create(:category, awesome_list: awesome_list, name: 'Test Category') }

      example 'raises MissingStarsError when GitHub items have no stars data' do
        # Create a GitHub item without stars (simulates failed API fetch)
        create(:category_item, category: category, name: 'Missing Stars Item',
               primary_url: 'https://github.com/owner/missing-repo',
               stars: nil)

        expect {
          service.call(awesome_list: awesome_list)
        }.to raise_error(ProcessCategoryServiceEnhanced::MissingStarsError, /Missing star data for GitHub items/)
      end

      example 'includes names of items missing stars in the error message' do
        create(:category_item, category: category, name: 'Repo Without Stars',
               primary_url: 'https://github.com/owner/repo-without-stars',
               stars: nil)
        create(:category_item, category: category, name: 'Another Missing',
               primary_url: 'https://github.com/owner/another-missing',
               stars: nil)

        expect {
          service.call(awesome_list: awesome_list)
        }.to raise_error(ProcessCategoryServiceEnhanced::MissingStarsError) do |error|
          expect(error.message).to include('Repo Without Stars')
          expect(error.message).to include('Another Missing')
        end
      end

      example 'does not raise error when non-GitHub items have no stars' do
        # Non-GitHub URLs don't require stars
        create(:category_item, category: category, name: 'External Site',
               primary_url: 'https://example.com/tool',
               stars: nil)

        expect { service.call(awesome_list: awesome_list) }.not_to raise_error
      end

      example 'does not raise error when all GitHub items have stars' do
        create(:category_item, category: category, name: 'Item With Stars',
               primary_url: 'https://github.com/owner/repo',
               stars: 100)

        expect { service.call(awesome_list: awesome_list) }.not_to raise_error
      end
    end

    context 'source link' do
      let!(:category) { create(:category, awesome_list: awesome_list, name: 'Test Category') }

      before do
        create(:category_item, category: category, name: 'Test Item', primary_url: 'https://example.com/test', stars: 100)
      end

      example 'includes a link to the original GitHub repository' do
        result = service.call(awesome_list: awesome_list)

        expect(result).to be_success
        content = File.read(result.value!)

        # Should contain a source link to the original repo
        expect(content).to include('https://github.com/test/awesome-test')
        expect(content).to match(/Source:.*github\.com\/test\/awesome-test/)
      end

      example 'places the source link after the title/description and before the table of contents' do
        awesome_list.update!(name: 'Test List', description: 'A test description')

        result = service.call(awesome_list: awesome_list)

        expect(result).to be_success
        content = File.read(result.value!)

        lines = content.lines.map(&:strip)

        # Find positions
        title_idx = lines.index { |l| l.start_with?('# ') }
        source_idx = lines.index { |l| l.include?('Source:') }
        toc_idx = lines.index { |l| l == '## Table of Contents' }

        expect(title_idx).to be < source_idx
        expect(source_idx).to be < toc_idx if toc_idx
      end
    end

    context 'back to top links' do
      let!(:category_a) { create(:category, awesome_list: awesome_list, name: 'Alpha Category') }
      let!(:category_b) { create(:category, awesome_list: awesome_list, name: 'Beta Category') }

      before do
        create(:category_item, category: category_a, name: 'Item A', primary_url: 'https://example.com/a', stars: 100)
        create(:category_item, category: category_b, name: 'Item B', primary_url: 'https://example.com/b', stars: 200)
      end

      example 'includes a Back to Top link after each category table' do
        result = service.call(awesome_list: awesome_list)

        expect(result).to be_success
        content = File.read(result.value!)

        # Should have Back to Top links
        back_to_top_links = content.scan(/\[Back to Top\]\(#table-of-contents\)/)
        expect(back_to_top_links.count).to eq(2) # One for each category
      end

      example 'places Back to Top link after the category table' do
        result = service.call(awesome_list: awesome_list)

        expect(result).to be_success
        content = File.read(result.value!)

        lines = content.lines.map(&:strip)

        # Find the first category header and its corresponding Back to Top
        alpha_idx = lines.index { |l| l == '## Alpha Category' }
        beta_idx = lines.index { |l| l == '## Beta Category' }
        first_back_to_top_idx = lines.index { |l| l.include?('[Back to Top]') }

        # Back to Top should be between the two categories
        expect(first_back_to_top_idx).to be > alpha_idx
        expect(first_back_to_top_idx).to be < beta_idx
      end
    end
  end
end
