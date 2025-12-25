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
  end
end
