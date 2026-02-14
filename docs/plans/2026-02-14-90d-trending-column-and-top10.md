# 90-Day Trending Column & Top 10 Section

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a 90d column to all markdown tables and a "Top 10: 90-Day Trending" section, using the existing `repos.stars_90d` data.

**Architecture:** `repos.stars_90d` is already computed by `ComputeTrendingOperation` from star snapshot diffs. We only need to surface this data in the markdown output by modifying `ProcessCategoryServiceEnhanced` — adding a 90d column to all three table types (category, Top 10 Stars, Top 10 30-Day Trending) and adding a new "Top 10: 90-Day Trending" section. No migrations or data pipeline changes required.

**Tech Stack:** Rails 8, RSpec, terminal-table gem, dry-monads

---

### Task 1: Add 90d column to category tables

**Files:**
- Modify: `app/services/process_category_service_enhanced.rb:156-178` (category table generation)
- Test: `spec/services/process_category_service_enhanced_spec.rb`

**Step 1: Write the failing test**

Add to the existing `'with 30d trending column'` context in the spec:

```ruby
example 'includes a 90d column in category tables' do
  result = service.call(awesome_list:)

  expect(result).to be_success
  content = File.read(result.value!)

  expect(content).to include('90d')
  expect(content).to include('+1200')
end
```

This requires updating the factory setup in the `'with 30d trending column'` context to also set `stars_90d` on the repos:

```ruby
let!(:repo_with_trend) { create(:repo, github_repo: 'owner/trending-repo', stars: 5000, stars_30d: 500, stars_90d: 1200) }
let!(:repo_no_trend) { create(:repo, github_repo: 'owner/stable-repo', stars: 3000, stars_30d: nil, stars_90d: nil) }
```

Also add:

```ruby
example 'shows blank for items without 90d trending data' do
  result = service.call(awesome_list:)
  content = File.read(result.value!)

  lines = content.lines.select { |l| l.include?('Stable Repo') }
  # Should not show any +N value in the 90d column area
  # The line has at most one "+" which is in the 30d column (if present)
  stable_line = lines.first
  # Count occurrences of "+" - should be 0 for stable repo (no 30d or 90d)
  expect(stable_line.scan(/\+\d+/).size).to eq(0)
end
```

**Step 2: Run test to verify it fails**

Run: `bundle exec rspec spec/services/process_category_service_enhanced_spec.rb -e '90d column'`
Expected: FAIL — "90d" column header not present in output

**Step 3: Implement — add 90d column to category tables**

In `generate_category_content` (around line 167-175), change:

```ruby
# Line 167: add 90d value
trending_md = item.repo&.stars_30d ? "+#{item.repo.stars_30d}" : ''
trending_90d_md = item.repo&.stars_90d ? "+#{item.repo.stars_90d}" : ''

# Line 170: add to row
[name_md, description_md, stars_md, trending_md, trending_90d_md, last_commit_md]
```

Update headings (line 175):
```ruby
t.headings = ['Name', 'Description', 'Stars', '30d', '90d', 'Last Commit']
```

**Step 4: Run test to verify it passes**

Run: `bundle exec rspec spec/services/process_category_service_enhanced_spec.rb -e '90d column'`
Expected: PASS

**Step 5: Run full spec suite for this file**

Run: `bundle exec rspec spec/services/process_category_service_enhanced_spec.rb`
Expected: All pass

**Step 6: Commit**

```bash
git add app/services/process_category_service_enhanced.rb spec/services/process_category_service_enhanced_spec.rb
git commit -m "feat: add 90d column to category tables in markdown output"
```

---

### Task 2: Add 90d column to Top 10: Stars table

**Files:**
- Modify: `app/services/process_category_service_enhanced.rb:199-225` (`generate_top_10_stars_section`)
- Test: `spec/services/process_category_service_enhanced_spec.rb`

**Step 1: Write the failing test**

Add to the `'with top 10 stars section'` context:

```ruby
example 'includes 90d column in the Top 10: Stars table' do
  result = service.call(awesome_list:, star_threshold: 0)
  content = File.read(result.value!)

  top_10_section = content[/## Top 10: Stars\n(.*?)(?=\n## )/m, 1]
  # Should have 90d in the header row
  header_line = top_10_section.lines.find { |l| l.include?('Name') && l.include?('Stars') }
  expect(header_line).to include('90d')
end
```

**Step 2: Run test to verify it fails**

Run: `bundle exec rspec spec/services/process_category_service_enhanced_spec.rb -e '90d column in the Top 10: Stars'`
Expected: FAIL

**Step 3: Implement — add 90d to Top 10 Stars table**

In `generate_top_10_stars_section` (around line 213-221):

```ruby
# Line 213: add 90d
trending_md = item.repo&.stars_30d ? "+#{item.repo.stars_30d}" : ''
trending_90d_md = item.repo&.stars_90d ? "+#{item.repo.stars_90d}" : ''
last_commit_md = item.last_commit_at.nil? ? 'N/A' : item.last_commit_at.strftime('%Y-%m-%d')
[name_md, item.category.name, item.stars.to_s, trending_md, trending_90d_md, last_commit_md]
```

Update headings (line 219):
```ruby
t.headings = ['Name', 'Category', 'Stars', '30d', '90d', 'Last Commit']
```

**Step 4: Run test to verify it passes**

Run: `bundle exec rspec spec/services/process_category_service_enhanced_spec.rb -e '90d column in the Top 10: Stars'`
Expected: PASS

**Step 5: Commit**

```bash
git add app/services/process_category_service_enhanced.rb spec/services/process_category_service_enhanced_spec.rb
git commit -m "feat: add 90d column to Top 10: Stars table"
```

---

### Task 3: Add 90d column to Top 10: 30-Day Trending table

**Files:**
- Modify: `app/services/process_category_service_enhanced.rb:227-254` (`generate_top_10_trending_section`)
- Test: `spec/services/process_category_service_enhanced_spec.rb`

**Step 1: Write the failing test**

In the `'with top 10 trending section'` → `'when 10+ items have positive stars_30d'` context, add:

```ruby
example 'includes 90d column in the trending table' do
  result = service.call(awesome_list:, star_threshold: 0)
  content = File.read(result.value!)

  trending_section = content[/## Top 10: 30-Day Trending\n(.*?)(?=\n## )/m, 1]
  header_line = trending_section.lines.find { |l| l.include?('Name') && l.include?('Stars') }
  expect(header_line).to include('90d')
end
```

Note: The factory setup in this context already creates repos with `stars_30d` — update to also include `stars_90d`:

```ruby
repo = create(:repo, github_repo: "owner/trending#{i}", stars: (12 - i) * 1000, stars_30d: (12 - i) * 100, stars_90d: (12 - i) * 250)
```

**Step 2: Run test to verify it fails**

Run: `bundle exec rspec spec/services/process_category_service_enhanced_spec.rb -e '90d column in the trending'`
Expected: FAIL

**Step 3: Implement — add 90d to Top 10 Trending table**

In `generate_top_10_trending_section` (around line 242-250):

```ruby
trending_md = "+#{item.repo.stars_30d}"
trending_90d_md = item.repo&.stars_90d ? "+#{item.repo.stars_90d}" : ''
last_commit_md = item.last_commit_at.nil? ? 'N/A' : item.last_commit_at.strftime('%Y-%m-%d')
[name_md, item.category.name, item.stars.to_s, trending_md, trending_90d_md, last_commit_md]
```

Update headings:
```ruby
t.headings = ['Name', 'Category', 'Stars', '30d', '90d', 'Last Commit']
```

**Step 4: Run test to verify it passes**

Run: `bundle exec rspec spec/services/process_category_service_enhanced_spec.rb -e '90d column in the trending'`
Expected: PASS

**Step 5: Commit**

```bash
git add app/services/process_category_service_enhanced.rb spec/services/process_category_service_enhanced_spec.rb
git commit -m "feat: add 90d column to Top 10: 30-Day Trending table"
```

---

### Task 4: Add "Top 10: 90-Day Trending" section

**Files:**
- Modify: `app/services/process_category_service_enhanced.rb` (add `generate_top_10_90d_trending_section`, update `generate_content`)
- Test: `spec/services/process_category_service_enhanced_spec.rb`

**Step 1: Write the failing tests**

Add a new context block after the `'with top 10 trending section'` context:

```ruby
context 'with top 10 90-day trending section' do
  let!(:category_a) { create(:category, awesome_list:, name: 'Frameworks') }
  let!(:category_b) { create(:category, awesome_list:, name: 'Libraries') }

  context 'when 10+ items have positive stars_90d' do
    before do
      12.times do |i|
        repo = create(:repo, github_repo: "owner/trend90_#{i}", stars: (12 - i) * 1000,
                             stars_30d: (12 - i) * 100, stars_90d: (12 - i) * 300)
        cat = i.even? ? category_a : category_b
        create(:category_item, category: cat, name: "Trend90 #{i}",
               primary_url: "https://github.com/owner/trend90_#{i}",
               github_repo: "owner/trend90_#{i}", stars: (12 - i) * 1000, repo:)
      end
    end

    example 'includes a Top 10: 90-Day Trending section' do
      result = service.call(awesome_list:, star_threshold: 0)
      content = File.read(result.value!)

      expect(content).to include('## Top 10: 90-Day Trending')
    end

    example 'orders items by stars_90d descending' do
      result = service.call(awesome_list:, star_threshold: 0)
      content = File.read(result.value!)

      trending_section = content[/## Top 10: 90-Day Trending\n(.*?)(?=\n## )/m, 1]

      expect(trending_section).to include('Trend90 0')
      expect(trending_section).to include('Trend90 9')
      expect(trending_section).not_to include('Trend90 10')
      expect(trending_section.index('Trend90 0')).to be < trending_section.index('Trend90 9')
    end

    example 'includes Top 10: 90-Day Trending in the Table of Contents' do
      result = service.call(awesome_list:, star_threshold: 0)
      content = File.read(result.value!)

      expect(content).to include('- [Top 10: 90-Day Trending](#top-10-90-day-trending)')
    end

    example 'places 90d trending section after 30d trending section' do
      result = service.call(awesome_list:, star_threshold: 0)
      content = File.read(result.value!)
      lines = content.lines.map(&:strip)

      trending_30d_idx = lines.index { |l| l == '## Top 10: 30-Day Trending' }
      trending_90d_idx = lines.index { |l| l == '## Top 10: 90-Day Trending' }
      first_category_idx = lines.index { |l| l == '## Frameworks' }

      expect(trending_30d_idx).to be < trending_90d_idx
      expect(trending_90d_idx).to be < first_category_idx
    end
  end

  context 'when fewer than 10 items have 90d trending data' do
    before do
      5.times do |i|
        repo = create(:repo, github_repo: "owner/trend90_#{i}", stars: (5 - i) * 1000,
                             stars_30d: (5 - i) * 100, stars_90d: (5 - i) * 300)
        create(:category_item, category: category_a, name: "Trend90 #{i}",
               primary_url: "https://github.com/owner/trend90_#{i}",
               github_repo: "owner/trend90_#{i}", stars: (5 - i) * 1000, repo:)
      end
      7.times do |i|
        create(:category_item, category: category_b, name: "No Trend90 #{i}",
               primary_url: "https://github.com/owner/notrend90_#{i}",
               stars: (7 - i) * 1000)
      end
    end

    example 'omits the 90-day trending section' do
      result = service.call(awesome_list:, star_threshold: 0)
      content = File.read(result.value!)

      expect(content).not_to include('## Top 10: 90-Day Trending')
    end
  end
end
```

**Step 2: Run tests to verify they fail**

Run: `bundle exec rspec spec/services/process_category_service_enhanced_spec.rb -e '90-day trending section'`
Expected: FAIL — method/section doesn't exist yet

**Step 3: Implement `generate_top_10_90d_trending_section`**

Add new method after `generate_top_10_trending_section`:

```ruby
def generate_top_10_90d_trending_section(awesome_list)
  items = awesome_list.category_items
                      .includes(:category, :repo)
                      .joins(:repo)
                      .where.not(primary_url: [nil, ''])
                      .where.not(repos: {stars_90d: nil})
                      .where('repos.stars_90d > 0')
                      .order('repos.stars_90d DESC')
                      .limit(10)

  items = items.to_a
  return nil if items.size < 10

  table_rows = items.map do |item|
    name_md = "[#{item.name}](#{item.primary_url})"
    trending_30d_md = item.repo&.stars_30d ? "+#{item.repo.stars_30d}" : ''
    trending_90d_md = "+#{item.repo.stars_90d}"
    last_commit_md = item.last_commit_at.nil? ? 'N/A' : item.last_commit_at.strftime('%Y-%m-%d')
    [name_md, item.category.name, item.stars.to_s, trending_30d_md, trending_90d_md, last_commit_md]
  end

  table = Terminal::Table.new do |t|
    t.headings = ['Name', 'Category', 'Stars', '30d', '90d', 'Last Commit']
    table_rows.each { |row| t.add_row(row) }
    t.style = {border: :markdown}
  end

  ['## Top 10: 90-Day Trending', '', table.to_s, '', '[Back to Top](#table-of-contents)', ''].join("\n")
end
```

**Step 4: Update `generate_content` to include the 90d section**

In `generate_content`, update the Top 10 section block (around lines 99-112):

```ruby
# Build Top 10 sections
top_10_stars_section = generate_top_10_stars_section(awesome_list)
top_10_trending_section = generate_top_10_trending_section(awesome_list)
top_10_90d_trending_section = generate_top_10_90d_trending_section(awesome_list)

# Add table of contents using only categories that produced content
visible_names = category_sections.map { |s| s[:name] }
visible_names.unshift('Top 10: 90-Day Trending') if top_10_90d_trending_section
visible_names.unshift('Top 10: 30-Day Trending') if top_10_trending_section
visible_names.unshift('Top 10: Stars') if top_10_stars_section
toc = TableOfContentsGenerator.generate(visible_names)
content << toc if toc.present?

# Add Top 10 sections after ToC, before categories
content << top_10_stars_section if top_10_stars_section
content << top_10_trending_section if top_10_trending_section
content << top_10_90d_trending_section if top_10_90d_trending_section
```

**Step 5: Run tests to verify they pass**

Run: `bundle exec rspec spec/services/process_category_service_enhanced_spec.rb`
Expected: All pass

**Step 6: Run RuboCop**

Run: `bundle exec rubocop app/services/process_category_service_enhanced.rb spec/services/process_category_service_enhanced_spec.rb`
Fix any new offenses introduced by our changes.

**Step 7: Commit**

```bash
git add app/services/process_category_service_enhanced.rb spec/services/process_category_service_enhanced_spec.rb
git commit -m "feat: add Top 10: 90-Day Trending section to markdown output"
```

---

### Task 5: Backfill star history for awesome-claude-code repos

This is an operational task — ensure the awesome-claude-code list's repos have enough historical snapshot data for the 90-day trending computation to work.

**Step 1: Check current snapshot coverage**

```bash
bin/rails runner '
list = AwesomeList.find_by(github_repo: "hesreallyhim/awesome-claude-code")
repos = Repo.joins(:category_items).where(category_items: { category_id: list.category_ids }).distinct
total = repos.count
with_90d = repos.where.not(stars_90d: nil).where("stars_90d > 0").count
with_history = repos.where.not(star_history_fetched_at: nil).count
puts "Total repos: #{total}"
puts "With 90d trending: #{with_90d}"
puts "With star history: #{with_history}"
'
```

**Step 2: If insufficient data, run compute trending**

`ComputeTrendingOperation` computes `stars_90d` from existing star snapshots. If snapshots exist but `stars_90d` hasn't been computed recently:

```bash
bin/rails runner 'puts ComputeTrendingOperation.new.call'
```

**Step 3: Regenerate markdown**

```bash
bin/rails runner '
list = AwesomeList.find_by(github_repo: "hesreallyhim/awesome-claude-code")
result = ProcessCategoryServiceEnhanced.new.call(awesome_list: list)
puts result.success? ? "Generated: #{result.value!}" : result.failure
'
```

**Step 4: Verify output**

```bash
head -80 static/awesomer/awesome-claude-code.md
```

Expected: TOC with "Top 10: Stars", "Top 10: 30-Day Trending", "Top 10: 90-Day Trending", followed by the three sections, each with 30d and 90d columns.

**Step 5: Commit generated markdown and plan**

```bash
git add static/awesomer/awesome-claude-code.md docs/plans/2026-02-14-90d-trending-column-and-top10.md
git commit -m "feat: regenerate markdown with 90d trending data"
```
