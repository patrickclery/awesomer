# 30-Day Trending for Repository Stars

## Problem

Star counts are overwritten on each fetch with no historical data preserved. Without daily snapshots, we cannot compute trending (stars gained over 30 days). There is no server running to collect data daily -- the user runs syncs manually from a MacBook.

## Solution

Store daily star snapshots via a new `repos` table (stable identity for GitHub repos) and a `star_snapshots` table (one row per repo per day). Use GitHub's GraphQL API to batch-fetch current star counts for all repos in under 2 minutes (~85 queries for 8,431 repos). Compute 30-day trending by diffing today's snapshot against 30 days ago.

## Data Model

### New table: `repos`

A first-class representation of a GitHub repository, decoupled from any particular awesome list's category structure.

```ruby
create_table :repos do |t|
  t.string :github_repo, null: false  # "owner/repo" normalized
  t.string :description
  t.integer :stars
  t.integer :previous_stars
  t.datetime :last_commit_at
  t.integer :stars_30d
  t.integer :stars_90d
  t.datetime :star_history_fetched_at
  t.timestamps
end

add_index :repos, :github_repo, unique: true
```

### New table: `star_snapshots`

One row per repo per day. At 8,431 repos, grows ~250k rows/month. Trivial for PostgreSQL.

```ruby
create_table :star_snapshots do |t|
  t.references :repo, null: false, foreign_key: true
  t.integer :stars, null: false
  t.date :snapshot_date, null: false
  t.timestamps
end

add_index :star_snapshots, [:repo_id, :snapshot_date], unique: true
add_index :star_snapshots, :snapshot_date
```

### Modified table: `category_items`

Add a foreign key to `repos`. Star-related columns migrate to `repos`.

```ruby
add_reference :category_items, :repo, foreign_key: true
```

`CategoryItem` keeps: `name`, `description`, `url`, `position`, `category_id`.
Star data (`stars`, `previous_stars`, `stars_30d`, `stars_90d`, `star_history_fetched_at`) moves to `Repo`.

### Modified table: `awesome_lists`

```ruby
add_column :awesome_lists, :sort_preference, :string, default: "stars", null: false
# Valid values: "stars", "trending_30d"
```

### Relationships

```ruby
class Repo < ApplicationRecord
  has_many :category_items
  has_many :star_snapshots

  def stars_30d_computed
    today = star_snapshots.find_by(snapshot_date: Date.current)
    past = star_snapshots.find_by(snapshot_date: Date.current - 30)
    return nil unless today && past
    today.stars - past.stars
  end
end

class CategoryItem < ApplicationRecord
  belongs_to :repo, optional: true  # nil for non-GitHub items
  belongs_to :category
end

class StarSnapshot < ApplicationRecord
  belongs_to :repo
end
```

## GraphQL Batch Fetching

### Operation: `SnapshotStarsOperation`

Fetches current star counts for all repos using GitHub's GraphQL API.

- Batches of 100 repos per query (each `repository` field = 1 point)
- 8,431 repos = 85 queries, ~1.5 minutes total
- Integrates with existing `GithubRateLimiterService` and `GithubApiRequest` tracking
- Enterprise rate limits are more forgiving

```graphql
query {
  repo0: repository(owner: "torvalds", name: "linux") {
    stargazerCount
    pushedAt
  }
  repo1: repository(owner: "facebook", name: "react") {
    stargazerCount
    pushedAt
  }
  # ... up to 100 per query
}
```

For each result:
1. Upsert `StarSnapshot` for today's date (idempotent -- safe to run multiple times per day)
2. Update `Repo.stars` with the current value
3. Record the API request via `GithubApiRequest`

### Rake task

```bash
bin/rails awesomer:snapshot_stars
# Output with progress:
# Fetching stars for 8,431 repos in 85 batches...
# [============================] 85/85 batches - 1m 23s
# Stored 8,431 snapshots for 2026-02-11
```

### Error handling

- Deleted/renamed repos return `null` in GraphQL response -- log warning, skip
- Rate limit exceeded -- pause and retry after `GithubRateLimiterService.time_until_reset`
- Network errors -- retry with exponential backoff (existing pattern)
- Partial batch failures -- store what succeeded, report what failed

## Trending Computation

### Bulk query (used during markdown generation)

```sql
SELECT today.repo_id, today.stars, (today.stars - COALESCE(past.stars, 0)) AS stars_30d
FROM star_snapshots today
LEFT JOIN star_snapshots past
  ON today.repo_id = past.repo_id
  AND past.snapshot_date = CURRENT_DATE - 30
WHERE today.snapshot_date = CURRENT_DATE
```

`LEFT JOIN` handles repos with fewer than 30 days of snapshots (trending will be null for those).

### Updating denormalized columns

After computing trending, update `repos.stars_30d` and `repos.stars_90d` for fast access during markdown generation.

## Markdown Output

### Per-category table (new `30d` column)

```markdown
## Web Frameworks

| Name | Description | Stars | 30d | Last Commit |
|------|-------------|------:|----:|-------------|
| [next.js](url) | The React Framework | 128,432 | +1,205 | 2026-02-10 |
| [nuxt](url) | Intuitive Vue Framework | 56,891 | +892 | 2026-02-11 |
```

### Top 10 Trending section (before categories)

```markdown
## Top 10 Trending (30 days)

| # | Name | Category | Stars | 30d |
|---|------|----------|------:|----:|
| 1 | [repo-name](url) | Media Streaming | 12,345 | +2,100 |
| 2 | [another-repo](url) | Automation | 8,901 | +1,850 |
```

Pulls the top 10 repos by `stars_30d` across all categories in the awesome list.

### Sort preference

Each `AwesomeList` has a `sort_preference` column (`"stars"` or `"trending_30d"`). The default is `"stars"`. When set to `"trending_30d"`, categories sort items by 30-day star gains instead of total stars.

## Migration Strategy

### Phase 1: Schema changes
1. Create `repos` table
2. Create `star_snapshots` table
3. Add `repo_id` to `category_items` (nullable)
4. Add `sort_preference` to `awesome_lists`

### Phase 2: Data migration
5. Populate `repos` from existing `category_items` (deduplicate by `github_repo`)
6. Copy star data from `category_items` to `repos`
7. Link `category_items` to their `repos` via `repo_id`

### Phase 3: Code changes
8. New `Repo` model
9. New `StarSnapshot` model
10. New `SnapshotStarsOperation` (GraphQL batch fetching)
11. New rake task `awesomer:snapshot_stars`
12. Update `PersistParsedCategoriesOperation` to find-or-create repos
13. Update `FetchGithubStatsJob` to write to repos instead of category_items
14. Update `ProcessCategoryService` to read stars from repos, add 30d column, add Top 10 section
15. Update `ProcessCategoryService` to respect `sort_preference`

### Phase 4: Cleanup
16. Remove star columns from `category_items` (after all code paths updated)
17. Remove unused `repo_stats` table
