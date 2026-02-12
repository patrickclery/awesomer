# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessCategoryServiceEnhanced do
  let(:service) { described_class.new }
  let(:awesome_list) { create(:awesome_list, github_repo: 'test/awesome-test') }

  describe '#call' do
    context 'when categories are in random order' do
      let!(:category_z) { create(:category, awesome_list:, name: 'Zebra Category') }
      let!(:category_a) { create(:category, awesome_list:, name: 'Alpha Category') }
      let!(:category_m) { create(:category, awesome_list:, name: 'Middle Category') }

      before do
        # Create items for each category so they're not empty
        create(:category_item, category: category_z, name: 'Item Z', primary_url: 'https://example.com/z', stars: 100)
        create(:category_item, category: category_a, name: 'Item A', primary_url: 'https://example.com/a', stars: 200)
        create(:category_item, category: category_m, name: 'Item M', primary_url: 'https://example.com/m', stars: 150)
      end

      example 'generates categories in alphabetical order' do
        result = service.call(awesome_list:)

        expect(result).to be_success
        file_path = result.value!
        expect(File.exist?(file_path)).to be(true)

        content = File.read(file_path)

        # Extract category headers in order they appear (excluding Table of Contents)
        category_headers = content.scan(/^## (.+)$/).flatten.reject { |h| h == 'Table of Contents' }

        expect(category_headers).to eq(['Alpha Category', 'Middle Category', 'Zebra Category'])
      end

      example 'maintains alphabetical order across multiple generations' do
        # Generate markdown multiple times and verify order is consistent
        results = []

        3.times do
          result = service.call(awesome_list:)
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
      let!(:category) { create(:category, awesome_list:, name: 'Test Category') }

      example 'raises MissingStarsError when GitHub items have no stars data' do
        # Create a GitHub item without stars (simulates failed API fetch)
        create(:category_item, category:, name: 'Missing Stars Item',
                               primary_url: 'https://github.com/owner/missing-repo',
                               stars: nil)

        expect do
          service.call(awesome_list:)
        end.to raise_error(ProcessCategoryServiceEnhanced::MissingStarsError, /Missing star data for GitHub items/)
      end

      example 'includes names of items missing stars in the error message' do
        create(:category_item, category:, name: 'Repo Without Stars',
                               primary_url: 'https://github.com/owner/repo-without-stars',
                               stars: nil)
        create(:category_item, category:, name: 'Another Missing',
                               primary_url: 'https://github.com/owner/another-missing',
                               stars: nil)

        expect do
          service.call(awesome_list:)
        end.to raise_error(ProcessCategoryServiceEnhanced::MissingStarsError) do |error|
          expect(error.message).to include('Repo Without Stars')
          expect(error.message).to include('Another Missing')
        end
      end

      example 'does not raise error when non-GitHub items have no stars' do
        # Non-GitHub URLs don't require stars
        create(:category_item, category:, name: 'External Site',
                               primary_url: 'https://example.com/tool',
                               stars: nil)

        expect { service.call(awesome_list:) }.not_to raise_error
      end

      example 'does not raise error when all GitHub items have stars' do
        create(:category_item, category:, name: 'Item With Stars',
                               primary_url: 'https://github.com/owner/repo',
                               stars: 100)

        expect { service.call(awesome_list:) }.not_to raise_error
      end
    end

    context 'source link' do
      let!(:category) { create(:category, awesome_list:, name: 'Test Category') }

      before do
        create(:category_item, category:, name: 'Test Item', primary_url: 'https://example.com/test',
                               stars: 100)
      end

      example 'includes a link to the original GitHub repository' do
        result = service.call(awesome_list:)

        expect(result).to be_success
        content = File.read(result.value!)

        # Should contain a source link to the original repo
        expect(content).to include('https://github.com/test/awesome-test')
        expect(content).to match(%r{Source:.*github\.com/test/awesome-test})
      end

      example 'places the source link after the title/description and before the table of contents' do
        awesome_list.update!(name: 'Test List', description: 'A test description')

        result = service.call(awesome_list:)

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
      let!(:category_a) { create(:category, awesome_list:, name: 'Alpha Category') }
      let!(:category_b) { create(:category, awesome_list:, name: 'Beta Category') }

      before do
        create(:category_item, category: category_a, name: 'Item A', primary_url: 'https://example.com/a', stars: 100)
        create(:category_item, category: category_b, name: 'Item B', primary_url: 'https://example.com/b', stars: 200)
      end

      example 'includes a Back to Top link after each category table' do
        result = service.call(awesome_list:)

        expect(result).to be_success
        content = File.read(result.value!)

        # Should have Back to Top links
        back_to_top_links = content.scan('[Back to Top](#table-of-contents)')
        expect(back_to_top_links.count).to eq(2) # One for each category
      end

      example 'places Back to Top link after the category table' do
        result = service.call(awesome_list:)

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

    context 'with star threshold filtering' do
      let!(:category) { create(:category, awesome_list:, name: 'Tools') }

      before do
        create(:category_item, category:, name: 'Popular Repo',
                               primary_url: 'https://github.com/owner/popular', stars: 500)
        create(:category_item, category:, name: 'Small Repo',
                               primary_url: 'https://github.com/owner/small', stars: 3)
        create(:category_item, category:, name: 'Medium Repo',
                               primary_url: 'https://github.com/owner/medium', stars: 15)
        create(:category_item, category:, name: 'Non-GitHub Tool',
                               primary_url: 'https://example.com/tool', stars: nil)
      end

      example 'excludes items below the star threshold' do
        result = service.call(awesome_list:, star_threshold: 10)

        expect(result).to be_success
        content = File.read(result.value!)

        expect(content).to include('Popular Repo')
        expect(content).to include('Medium Repo')
        expect(content).not_to include('Small Repo')
      end

      example 'always includes non-GitHub items regardless of threshold' do
        result = service.call(awesome_list:, star_threshold: 10)

        expect(result).to be_success
        content = File.read(result.value!)

        expect(content).to include('Non-GitHub Tool')
      end

      example 'uses the awesome_list sync_threshold_value as default when no threshold given' do
        awesome_list.update!(sync_threshold: 100)

        result = service.call(awesome_list:)

        expect(result).to be_success
        content = File.read(result.value!)

        expect(content).to include('Popular Repo')
        expect(content).not_to include('Medium Repo')
        expect(content).not_to include('Small Repo')
      end

      example 'includes all items when threshold is 0' do
        result = service.call(awesome_list:, star_threshold: 0)

        expect(result).to be_success
        content = File.read(result.value!)

        expect(content).to include('Popular Repo')
        expect(content).to include('Medium Repo')
        expect(content).to include('Small Repo')
      end

      example 'removes category when all GitHub items are below threshold and no non-GitHub items exist' do
        # Create a separate category with only GitHub items
        github_only_category = create(:category, awesome_list:, name: 'GitHub Only')
        create(:category_item, category: github_only_category, name: 'Low Stars Repo',
                               primary_url: 'https://github.com/owner/low', stars: 5)
        create(:category_item, category: github_only_category, name: 'Also Low Repo',
                               primary_url: 'https://github.com/owner/also-low', stars: 8)

        result = service.call(awesome_list:, star_threshold: 1000)

        expect(result).to be_success
        content = File.read(result.value!)

        expect(content).not_to include('## GitHub Only')
      end
    end

    context 'with top 10 section' do
      let!(:category_a) { create(:category, awesome_list:, name: 'Frameworks') }
      let!(:category_b) { create(:category, awesome_list:, name: 'Libraries') }

      before do
        create(:category_item, category: category_a, name: 'Top One',
                               primary_url: 'https://github.com/owner/top1', stars: 50_000)
        create(:category_item, category: category_a, name: 'Top Two',
                               primary_url: 'https://github.com/owner/top2', stars: 40_000)
        create(:category_item, category: category_b, name: 'Top Three',
                               primary_url: 'https://github.com/owner/top3', stars: 30_000)
        create(:category_item, category: category_a, name: 'Top Four',
                               primary_url: 'https://github.com/owner/top4', stars: 20_000)
        create(:category_item, category: category_b, name: 'Top Five',
                               primary_url: 'https://github.com/owner/top5', stars: 15_000)
        create(:category_item, category: category_a, name: 'Top Six',
                               primary_url: 'https://github.com/owner/top6', stars: 10_000)
        create(:category_item, category: category_b, name: 'Top Seven',
                               primary_url: 'https://github.com/owner/top7', stars: 8_000)
        create(:category_item, category: category_a, name: 'Top Eight',
                               primary_url: 'https://github.com/owner/top8', stars: 5_000)
        create(:category_item, category: category_b, name: 'Top Nine',
                               primary_url: 'https://github.com/owner/top9', stars: 3_000)
        create(:category_item, category: category_a, name: 'Top Ten',
                               primary_url: 'https://github.com/owner/top10', stars: 2_000)
        create(:category_item, category: category_b, name: 'Eleventh',
                               primary_url: 'https://github.com/owner/eleventh', stars: 1_000)
        create(:category_item, category: category_a, name: 'Twelfth',
                               primary_url: 'https://github.com/owner/twelfth', stars: 500)
      end

      example 'includes a Top 10 section in the output' do
        result = service.call(awesome_list:, star_threshold: 0)
        content = File.read(result.value!)

        expect(content).to include('## Top 10')
      end

      example 'shows exactly 10 items in the Top 10 table' do
        result = service.call(awesome_list:, star_threshold: 0)
        content = File.read(result.value!)

        top_10_section = content[/## Top 10\n(.*?)(?=\n## )/m, 1]

        data_rows = top_10_section.lines.select { |l| l.start_with?('|') && !l.include?('---') && !l.include?('Name') }
        expect(data_rows.size).to eq(10)
      end

      example 'lists items in descending star order' do
        result = service.call(awesome_list:, star_threshold: 0)
        content = File.read(result.value!)

        top_10_section = content[/## Top 10\n(.*?)(?=\n## )/m, 1]

        expect(top_10_section).to include('Top One')
        expect(top_10_section).to include('Top Ten')
        expect(top_10_section).not_to include('Eleventh')
        expect(top_10_section).not_to include('Twelfth')

        expect(top_10_section.index('Top One')).to be < top_10_section.index('Top Ten')
      end

      example 'includes category name in the Top 10 table' do
        result = service.call(awesome_list:, star_threshold: 0)
        content = File.read(result.value!)

        top_10_section = content[/## Top 10\n(.*?)(?=\n## )/m, 1]

        expect(top_10_section).to include('Frameworks')
        expect(top_10_section).to include('Libraries')
      end

      example 'places Top 10 after Table of Contents and before first category' do
        result = service.call(awesome_list:, star_threshold: 0)
        content = File.read(result.value!)
        lines = content.lines.map(&:strip)

        toc_idx = lines.index { |l| l == '## Table of Contents' }
        top_10_idx = lines.index { |l| l == '## Top 10' }
        first_category_idx = lines.index { |l| l == '## Frameworks' }

        expect(toc_idx).to be < top_10_idx
        expect(top_10_idx).to be < first_category_idx
      end

      example 'includes Top 10 in the Table of Contents' do
        result = service.call(awesome_list:, star_threshold: 0)
        content = File.read(result.value!)

        expect(content).to include('- [Top 10](#top-10)')
      end

      example 'omits Top 10 when threshold leaves fewer than 10 qualifying items' do
        # threshold 10_000 leaves only 6 qualifying items (Top One through Top Six)
        result = service.call(awesome_list:, star_threshold: 10_000)
        content = File.read(result.value!)

        expect(content).not_to include('## Top 10')
      end

      example 'excludes items below threshold from Top 10' do
        # threshold 500 leaves all 12 items qualifying; Top 10 renders, Twelfth (500) is at boundary
        result = service.call(awesome_list:, star_threshold: 500)
        content = File.read(result.value!)

        top_10_section = content[/## Top 10\n(.*?)(?=\n## )/m, 1]

        expect(top_10_section).to include('Top One')
        expect(top_10_section).to include('Top Ten')
        expect(top_10_section).not_to include('Eleventh')
      end

      example 'omits Top 10 section when fewer than 10 items exist' do
        CategoryItem.where(name: ['Top Six', 'Top Seven', 'Top Eight', 'Top Nine', 'Top Ten', 'Eleventh',
                                  'Twelfth']).destroy_all

        result = service.call(awesome_list:, star_threshold: 0)
        content = File.read(result.value!)

        expect(content).not_to include('## Top 10')
      end
    end

    context 'with sort_preference set to trending_30d' do
      let!(:category) { create(:category, awesome_list:, name: 'Tools') }
      let!(:repo_high_stars) { create(:repo, github_repo: 'owner/high-stars', stars: 50_000, stars_30d: 100) }
      let!(:repo_high_trend) { create(:repo, github_repo: 'owner/high-trend', stars: 5000, stars_30d: 2000) }

      before do
        awesome_list.update!(sort_preference: 'trending_30d')
        create(:category_item, category:, name: 'High Stars',
               primary_url: 'https://github.com/owner/high-stars',
               github_repo: 'owner/high-stars', stars: 50_000, repo: repo_high_stars)
        create(:category_item, category:, name: 'High Trend',
               primary_url: 'https://github.com/owner/high-trend',
               github_repo: 'owner/high-trend', stars: 5000, repo: repo_high_trend)
      end

      example 'sorts items by 30d trending instead of total stars' do
        result = service.call(awesome_list:)

        expect(result).to be_success
        content = File.read(result.value!)

        # High Trend (2000 30d) should appear before High Stars (100 30d)
        expect(content.index('High Trend')).to be < content.index('High Stars')
      end
    end

    context 'with 30d trending column' do
      let!(:category) { create(:category, awesome_list:, name: 'Tools') }
      let!(:repo_with_trend) { create(:repo, github_repo: 'owner/trending-repo', stars: 5000, stars_30d: 500) }
      let!(:repo_no_trend) { create(:repo, github_repo: 'owner/stable-repo', stars: 3000, stars_30d: nil) }

      before do
        create(:category_item, category:, name: 'Trending Repo',
               primary_url: 'https://github.com/owner/trending-repo',
               github_repo: 'owner/trending-repo', stars: 5000, repo: repo_with_trend)
        create(:category_item, category:, name: 'Stable Repo',
               primary_url: 'https://github.com/owner/stable-repo',
               github_repo: 'owner/stable-repo', stars: 3000, repo: repo_no_trend)
      end

      example 'includes a 30d column in category tables' do
        result = service.call(awesome_list:)

        expect(result).to be_success
        content = File.read(result.value!)

        expect(content).to include('30d')
        expect(content).to include('+500')
      end

      example 'shows blank for items without trending data' do
        result = service.call(awesome_list:)
        content = File.read(result.value!)

        # The stable repo row should not show any +N value in the 30d column
        lines = content.lines.select { |l| l.include?('Stable Repo') }
        expect(lines.first).not_to include('+')
      end
    end
  end
end
