# Backfill Star Snapshots Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Bootstrap historical star snapshot data for a specific repo using the OSSInsight API (which tracks daily star counts from GH Archive data), creating StarSnapshot records for each day.

**Architecture:** New `BackfillStarSnapshotsOperation` makes a single HTTP call to the OSSInsight public API (`GET /v1/repos/{owner}/{repo}/stargazers/history?per=day`), which returns daily cumulative star counts sourced from GH Archive. No GitHub token needed, no pagination, no rate limit concerns. The operation parses the JSON response and upserts StarSnapshot records. Exposed through `bin/awesomer bootstrap stars --repo owner/name`.

**Tech Stack:** Net::HTTP (OSSInsight REST API), Dry::Monads Result pattern, Thor CLI, RSpec with VCR cassettes.

**API Research:** Evaluated three options:
- **OSSInsight API** (chosen) - Free, no auth, 1 API call returns all daily history, 600 req/hr limit, data from GH Archive
- daily-stars-explorer - No documented public API, would need self-hosting
- GitHub REST stargazers - Expensive (N/100 calls), lossy (misses unstarred users), 40K cap

**Verified endpoint:** `https://api.ossinsight.io/v1/repos/hesreallyhim/awesome-claude-code/stargazers/history?per=day` returns 271 daily data points.

---

### Task 1: Write BackfillStarSnapshotsOperation spec (happy path)

**Files:**
- Create: `spec/operations/backfill_star_snapshots_operation_spec.rb`

**Step 1: Write the failing test**

The OSSInsight API response format:
```json
{
  "type": "sql_endpoint",
  "data": {
    "columns": [
      {"col": "date", "data_type": "VARCHAR", "nullable": true},
      {"col": "stargazers", "data_type": "DECIMAL", "nullable": true}
    ],
    "rows": [
      {"date": "2025-04-22", "stargazers": "1"},
      {"date": "2025-04-24", "stargazers": "2"},
      {"date": "2025-05-10", "stargazers": "4"}
    ]
  },
  "result": {"code": 200, "message": "Query OK!", "row_count": 3, "limit": 2000}
}
```

Note: `stargazers` values are strings (not integers) and represent cumulative totals.

Tests use VCR cassettes stored under `spec/cassettes/ossinsight/` via the project's `vcr()` helper (see `spec/support/vcr.rb`). The helper is used as `vcr('ossinsight', 'cassette_name')`. Record initial cassettes with `VCR=true VCR_RECORD_MODE=new_episodes bundle exec rspec ...`.

```ruby
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BackfillStarSnapshotsOperation do
  include Test::Support::VCR

  subject(:operation) { described_class.new }

  describe '#call' do
    context 'when OSSInsight returns star history' do
      let!(:repo) { create(:repo, github_repo: 'hesreallyhim/awesome-claude-code', stars: nil) }

      example 'creates star snapshots from OSSInsight data' do
        vcr('ossinsight', 'hesreallyhim_awesome_claude_code', record: :new_episodes) do
          result = operation.call(github_repo: 'hesreallyhim/awesome-claude-code')

          expect(result).to be_success
          expect(result.value!).to match(/Backfilled \d+ snapshots/)

          snapshots = StarSnapshot.where(repo: repo).order(:snapshot_date)
          expect(snapshots.count).to be > 0

          # Verify snapshots are cumulative (non-decreasing)
          star_counts = snapshots.pluck(:stars)
          expect(star_counts).to eq(star_counts.sort)

          # Verify dates are valid and ordered
          dates = snapshots.pluck(:snapshot_date)
          expect(dates).to eq(dates.sort)
        end
      end

      example 'updates repo star_history_fetched_at' do
        vcr('ossinsight', 'hesreallyhim_awesome_claude_code') do
          freeze_time do
            operation.call(github_repo: 'hesreallyhim/awesome-claude-code')
            expect(repo.reload.star_history_fetched_at).to eq(Time.current)
          end
        end
      end
    end
  end
end
```

**Step 2: Run test to verify it fails**

Run: `bundle exec rspec spec/operations/backfill_star_snapshots_operation_spec.rb -v`
Expected: FAIL with `uninitialized constant BackfillStarSnapshotsOperation`

**Step 3: Commit**

```bash
git add spec/operations/backfill_star_snapshots_operation_spec.rb
git commit -m "test: add BackfillStarSnapshotsOperation spec (happy path)"
```

---

### Task 2: Implement BackfillStarSnapshotsOperation

**Files:**
- Create: `app/operations/backfill_star_snapshots_operation.rb`

**Step 1: Write the implementation**

```ruby
# frozen_string_literal: true

require 'net/http'
require 'json'

class BackfillStarSnapshotsOperation
  include Dry::Monads[:result]

  OSSINSIGHT_BASE_URL = 'https://api.ossinsight.io/v1'

  def call(github_repo:)
    repo = Repo.find_by(github_repo: github_repo)
    return Failure("Repo not found in database: #{github_repo}") unless repo

    rows = fetch_star_history(github_repo)
    return Failure("No star history data returned for #{github_repo}") if rows.empty?

    snapshots_created = create_snapshots(repo, rows)

    repo.update!(star_history_fetched_at: Time.current)

    Success("Backfilled #{snapshots_created} snapshots for #{github_repo}")
  rescue StandardError => e
    Rails.logger.error "BackfillStarSnapshotsOperation error: #{e.message}"
    Failure("Backfill failed: #{e.message}")
  end

  private

  def fetch_star_history(github_repo)
    uri = URI("#{OSSINSIGHT_BASE_URL}/repos/#{github_repo}/stargazers/history?per=day")
    response = Net::HTTP.get_response(uri)

    unless response.is_a?(Net::HTTPSuccess)
      raise "OSSInsight API returned #{response.code}: #{response.body}"
    end

    parsed = JSON.parse(response.body)
    parsed.dig('data', 'rows') || []
  end

  def create_snapshots(repo, rows)
    count = 0

    rows.each do |row|
      date = Date.parse(row['date'])
      stars = row['stargazers'].to_i

      snapshot = StarSnapshot.find_or_initialize_by(repo: repo, snapshot_date: date)
      snapshot.stars = stars
      snapshot.save!
      count += 1
    end

    count
  end
end
```

**Step 2: Run test to verify it passes (record cassette on first run)**

Run: `VCR=true VCR_RECORD_MODE=new_episodes bundle exec rspec spec/operations/backfill_star_snapshots_operation_spec.rb -v`
Expected: PASS (cassette recorded at `spec/cassettes/ossinsight/hesreallyhim_awesome_claude_code.yml`)

Then verify cassette was recorded:
Run: `ls spec/cassettes/ossinsight/`
Expected: `hesreallyhim_awesome_claude_code.yml`

**Step 3: Commit (include cassette)**

```bash
git add app/operations/backfill_star_snapshots_operation.rb spec/cassettes/ossinsight/
git commit -m "feat: implement BackfillStarSnapshotsOperation using OSSInsight API"
```

---

### Task 3: Add edge case specs and verify

**Files:**
- Modify: `spec/operations/backfill_star_snapshots_operation_spec.rb`

**Step 1: Add edge case tests**

Append inside the `describe '#call'` block. Edge cases that don't make HTTP calls (repo not in DB) need no VCR. For API error/empty responses, use WebMock stubs since we can't easily record real error cassettes from OSSInsight.

```ruby
    context 'when repo does not exist in database' do
      example 'returns failure without making API call' do
        result = operation.call(github_repo: 'nonexistent/repo')

        expect(result).to be_failure
        expect(result.failure).to include('Repo not found')
      end
    end

    context 'when OSSInsight returns empty rows' do
      let!(:repo) { create(:repo, github_repo: 'owner/empty-repo', stars: nil) }

      before do
        stub_request(:get, 'https://api.ossinsight.io/v1/repos/owner/empty-repo/stargazers/history?per=day')
          .to_return(
            status: 200,
            body: { 'data' => { 'rows' => [] }, 'result' => { 'code' => 200, 'row_count' => 0 } }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      example 'returns failure with no-data message' do
        result = operation.call(github_repo: 'owner/empty-repo')

        expect(result).to be_failure
        expect(result.failure).to include('No star history data')
      end
    end

    context 'when OSSInsight API returns an error' do
      let!(:repo) { create(:repo, github_repo: 'owner/error-repo', stars: nil) }

      before do
        stub_request(:get, 'https://api.ossinsight.io/v1/repos/owner/error-repo/stargazers/history?per=day')
          .to_return(status: 500, body: 'Internal Server Error')
      end

      example 'returns failure' do
        result = operation.call(github_repo: 'owner/error-repo')

        expect(result).to be_failure
        expect(result.failure).to include('Backfill failed')
      end
    end

    context 'when snapshots already exist for some dates' do
      let!(:repo) { create(:repo, github_repo: 'hesreallyhim/awesome-claude-code', stars: nil) }

      before do
        create(:star_snapshot, repo: repo, snapshot_date: Date.parse('2025-04-22'), stars: 999)
      end

      example 'updates existing snapshots with OSSInsight values' do
        vcr('ossinsight', 'hesreallyhim_awesome_claude_code') do
          result = operation.call(github_repo: 'hesreallyhim/awesome-claude-code')

          expect(result).to be_success
          snapshot = StarSnapshot.find_by(repo: repo, snapshot_date: Date.parse('2025-04-22'))
          expect(snapshot.stars).not_to eq(999) # Updated from stale value
        end
      end
    end
```

**Step 2: Run tests to verify they pass**

Run: `VCR=true bundle exec rspec spec/operations/backfill_star_snapshots_operation_spec.rb -v`
Expected: PASS (all examples). Happy path replays from existing cassette, stubs handle synthetic error cases.

**Step 3: Commit**

```bash
git add spec/operations/backfill_star_snapshots_operation_spec.rb
git commit -m "test: add edge case specs for BackfillStarSnapshotsOperation"
```

---

### Task 4: Register in DI container

**Files:**
- Modify: `lib/app/container.rb` (after line 20, the `snapshot_stars_operation` registration)

**Step 1: Add registration**

```ruby
    register('backfill_star_snapshots_operation') { BackfillStarSnapshotsOperation.new }
```

**Step 2: Run all tests to verify nothing broke**

Run: `bundle exec rspec`
Expected: PASS

**Step 3: Commit**

```bash
git add lib/app/container.rb
git commit -m "chore: register BackfillStarSnapshotsOperation in DI container"
```

---

### Task 5: Add `stars` subcommand to Bootstrap CLI

**Files:**
- Modify: `lib/awesomer/commands/bootstrap.rb` (add after the `lists` method, before closing `end`s)

**Step 1: Add the `stars` subcommand**

```ruby
      desc 'stars', 'Backfill historical star snapshots for a specific repository from OSSInsight'
      method_option :repo, required: true, desc: 'GitHub repo identifier (e.g. hesreallyhim/awesome-claude-code)',
                           type: :string
      def stars
        repo_identifier = options[:repo]

        puts "Backfilling star snapshots for #{repo_identifier}"
        puts '=' * 50

        repo = Repo.find_by(github_repo: repo_identifier)
        unless repo
          say("ERROR: Repo '#{repo_identifier}' not found in database. Run 'awesomer refresh' first.", :red)
          exit 1
        end

        # Backup database before modifying data
        backup_database!

        existing_count = StarSnapshot.where(repo: repo).count
        if existing_count > 0
          say("Found #{existing_count} existing snapshots. Backfill will update overlapping dates.", :yellow)
        end

        say("Fetching star history from OSSInsight API...", :cyan)

        operation = BackfillStarSnapshotsOperation.new
        result = operation.call(github_repo: repo_identifier)

        if result.success?
          say(result.value!, :green)

          total_snapshots = StarSnapshot.where(repo: repo).count
          date_range = StarSnapshot.where(repo: repo).order(:snapshot_date)
          say("Total snapshots: #{total_snapshots} (#{date_range.first.snapshot_date} to #{date_range.last.snapshot_date})", :green)
        else
          say("ERROR: #{result.failure}", :red)
          exit 1
        end
      end
      private

      def backup_database!
        backup_dir = File.expand_path('~/tmp/awesomer')
        FileUtils.mkdir_p(backup_dir)

        date_stamp = Date.current.to_s
        backup_path = File.join(backup_dir, "backup-#{date_stamp}.sql")

        if File.exist?(backup_path)
          say("Backup already exists at #{backup_path}, skipping.", :yellow)
          return
        end

        say("Backing up database to #{backup_path}...", :cyan)

        db_config = ActiveRecord::Base.connection_db_config.configuration_hash
        db_name = db_config[:database]

        cmd = "pg_dump #{db_name} > #{backup_path}"
        unless system(cmd)
          say("ERROR: Database backup failed. Aborting.", :red)
          exit 1
        end

        say("Backup complete (#{File.size(backup_path)} bytes).", :green)
      end
```

**Step 2: Test manually**

Run: `bin/awesomer bootstrap stars --repo hesreallyhim/awesome-claude-code`
Expected: Fetches from OSSInsight, creates ~271 snapshots, prints success.

**Step 3: Commit**

```bash
git add lib/awesomer/commands/bootstrap.rb
git commit -m "feat: add 'bootstrap stars' CLI command for backfilling star history"
```

---

### Task 6: Run full test suite and RuboCop

**Step 1: Run all specs**

Run: `bundle exec rspec`
Expected: All tests pass, no regressions.

**Step 2: Run RuboCop**

Run: `bundle exec rubocop app/operations/backfill_star_snapshots_operation.rb spec/operations/backfill_star_snapshots_operation_spec.rb lib/awesomer/commands/bootstrap.rb lib/app/container.rb`
Expected: No offenses. Fix any that arise.

**Step 3: Final commit if any fixes needed**

---

## Notes

- **OSSInsight data source:** GH Archive event stream. Data may lag ~24 hours behind real-time. Not all repos may be tracked - if OSSInsight returns empty data for a repo, the operation returns Failure.
- **Idempotent.** Running backfill again upserts via `find_or_initialize_by`. Existing snapshots from daily `SnapshotStarsOperation` (GraphQL batch) will be overwritten for overlapping dates with OSSInsight values. Since both sources are authoritative, this is fine.
- **No GitHub API token needed.** OSSInsight API is free and unauthenticated (600 req/hr rate limit, but we only make 1 call per repo).
- **One-time operation.** After backfill, daily `SnapshotStarsOperation` keeps data current going forward.
- **VCR cassettes:** Happy path tests use recorded OSSInsight responses under `spec/cassettes/ossinsight/`. Error edge cases use WebMock stubs since we can't easily provoke real API errors. Record new cassettes with `VCR=true VCR_RECORD_MODE=new_episodes`.
