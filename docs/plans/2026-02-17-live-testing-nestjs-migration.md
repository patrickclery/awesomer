# Live Testing: NestJS Migration Verification

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Verify every key feature of the NestJS + Next.js platform works end-to-end with real data, confirming the migration from Rails is complete and correct.

**Architecture:** The API runs at `localhost:4000`, the frontend at `localhost:3000`. PostgreSQL (port 5433) has 77 awesome lists, 12.8k repos, 998 categories, 13.7k items, and 1M star snapshots migrated from the Rails database. We test each feature in isolation, fix issues as found, and commit fixes before moving on.

**Tech Stack:** NestJS 11 (ESM), Next.js 16, Prisma 7, PostgreSQL, Octokit (GitHub API)

**Prerequisites:**
- Docker containers running: `docker ps` should show postgres (5433) and redis
- API running: `DATABASE_URL="postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" node dist/src/main.js`
- Frontend running: `cd web && npm run dev` (port 3000)
- A valid `GITHUB_API_KEY` in `api/.env` (needed for sync tasks)
- `ADMIN_API_KEY` in `api/.env` (needed for sync trigger endpoints)

---

## Task 1: Verify Read-Only API Endpoints

Test that all GET endpoints return correct data from the migrated database.

**Step 1: Test awesome-lists endpoints**

```bash
# List all verticals — expect 77 results
curl -s http://localhost:4000/api/awesome-lists | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Lists: {len(d[\"data\"])}')"

# Get a specific list — expect categories array
curl -s http://localhost:4000/api/awesome-lists/awesome-claude-code | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Name: {d[\"data\"][\"name\"]}, Categories: {len(d[\"data\"][\"categories\"])}')"
```

Expected: `Lists: 77` and `Name: awesome-claude-code, Categories: <N>` where N > 0.

**Step 2: Test repos endpoints**

```bash
# Repos by list with pagination
curl -s 'http://localhost:4000/api/awesome-lists/awesome-selfhosted/repos?page=1&per_page=5' | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Items: {len(d[\"data\"])}, Total: {d[\"meta\"][\"total\"]}')"

# Repos sorted by trending
curl -s 'http://localhost:4000/api/awesome-lists/awesome-selfhosted/repos?sort=trending_7d&per_page=3' | python3 -c "import sys,json; d=json.load(sys.stdin); [print(f'  {i[\"name\"]}: stars={i[\"stars\"]}, 7d={i[\"repo\"] and i[\"repo\"][\"stars7d\"]}') for i in d['data']]"

# Repo by GitHub owner/name
curl -s http://localhost:4000/api/repos/by-github/obra/superpowers | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Repo: {d[\"data\"][\"githubRepo\"]}, Stars: {d[\"data\"][\"stars\"]}')"

# Star history
REPO_ID=$(curl -s http://localhost:4000/api/repos/by-github/obra/superpowers | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])")
curl -s "http://localhost:4000/api/repos/$REPO_ID/star-history" | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Snapshots: {len(d[\"data\"])}')"
```

Expected: Items > 0, total > 100 for selfhosted; repo found by GitHub slug; star history has snapshots.

**Step 3: Test trending endpoints**

```bash
# Global trending
curl -s 'http://localhost:4000/api/trending?period=7d&limit=5' | python3 -c "import sys,json; d=json.load(sys.stdin); [print(f'  {r[\"githubRepo\"]}: +{r[\"stars7d\"]}') for r in d['data']]"

# Trending by vertical
curl -s 'http://localhost:4000/api/trending/awesome-claude-code?period=30d&limit=5' | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Trending repos: {len(d[\"data\"])}')"
```

Expected: Global trending returns repos with positive stars7d. Vertical trending returns repos from that list.

**Step 4: Test global search**

```bash
curl -s 'http://localhost:4000/api/search?q=docker&page=1&per_page=5' | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Results: {d[\"meta\"][\"total\"]}, First: {d[\"data\"][0][\"name\"] if d[\"data\"] else \"none\"}')"
```

Expected: Multiple results matching "docker".

**Step 5: Test categories and featured endpoints**

```bash
# Categories
curl -s http://localhost:4000/api/categories | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Categories: {len(d[\"data\"])}')"

# Featured (may be empty — that's OK)
curl -s 'http://localhost:4000/api/featured?list=awesome-claude-code' | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Featured: {len(d[\"data\"])}')"
```

Expected: Categories > 0. Featured may be 0 (no featured profiles migrated from Rails).

**Step 6: If any endpoint returns errors or unexpected results, investigate and fix before continuing.**

**Step 7: Commit any fixes**

---

## Task 2: Verify Frontend Pages Render Correctly

Open each page in a browser (or curl) and verify it renders with real data from the API.

**Step 1: Home page**

```bash
# Check that the home page SSR includes awesome list data
curl -s http://localhost:3000 | grep -o 'awesome-selfhosted' | head -1
```

Expected: The slug appears in the rendered HTML (proves API data flows to frontend).

**Step 2: Vertical page**

```bash
curl -s http://localhost:3000/awesome-claude-code | grep -c 'Trending'
```

Expected: Count > 0 (trending tables rendered).

**Step 3: Repos list page**

```bash
curl -s 'http://localhost:3000/awesome-selfhosted/repos' | grep -o '<table' | wc -l
```

Expected: At least 1 table rendered.

**Step 4: Trending page**

```bash
curl -s http://localhost:3000/trending | grep -c 'stars'
```

Expected: Count > 0.

**Step 5: Search page**

```bash
curl -s 'http://localhost:3000/search?q=docker' | grep -o 'search' | head -1
```

Expected: Page renders (search is client-side, so just verify the page loads without error).

**Step 6: If any page fails to render or shows errors, check the Next.js terminal for errors, investigate the API response, and fix.**

**Step 7: Commit any fixes**

---

## Task 3: Test Sync — Import a Single Awesome List

Re-import `awesome-claude-code` (ID 223) from GitHub to verify the full import pipeline: README fetch, markdown parsing, category/item upsert.

**Prerequisites:** Add `GITHUB_API_KEY` and `ADMIN_API_KEY` to `api/.env`, then restart the API with env vars loaded.

**Step 1: Set up environment**

Ensure `api/.env` has:
```
GITHUB_API_KEY=ghp_...  (a valid GitHub PAT)
ADMIN_API_KEY=test-admin-key-123
```

Restart the API so it picks up the keys:
```bash
# Kill existing API process, then:
cd api && source .env && DATABASE_URL="$DATABASE_URL" GITHUB_API_KEY="$GITHUB_API_KEY" ADMIN_API_KEY="$ADMIN_API_KEY" node dist/src/main.js
```

Verify the key is loaded — should NOT see the "GITHUB_API_KEY not set" warning in startup logs.

**Step 2: Record before-state**

```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  SELECT c.name, count(ci.id) as items
  FROM categories c
  LEFT JOIN category_items ci ON ci.category_id = c.id
  WHERE c.awesome_list_id = 223
  GROUP BY c.name
  ORDER BY c.name;"
```

Save this output to compare after re-import.

**Step 3: Trigger the import**

```bash
curl -X POST http://localhost:4000/api/sync/import/223 \
  -H "Authorization: Bearer test-admin-key-123" \
  -H "Content-Type: application/json" 2>&1
```

Expected: A JSON response with `{ categories: N, items: N }` showing items were parsed and upserted. Check the API terminal for detailed logs.

**Step 4: Verify the import updated data**

```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  SELECT c.name, count(ci.id) as items
  FROM categories c
  LEFT JOIN category_items ci ON ci.category_id = c.id
  WHERE c.awesome_list_id = 223
  GROUP BY c.name
  ORDER BY c.name;"
```

Compare with before-state. The category names should match (or be a superset of) the sections in the awesome-claude-code README on GitHub.

**Step 5: Verify on the frontend**

```bash
curl -s http://localhost:4000/api/awesome-lists/awesome-claude-code | python3 -c "
import sys,json
d = json.load(sys.stdin)['data']
print(f'Categories: {len(d[\"categories\"])}')
for c in d['categories'][:5]:
    print(f'  {c[\"name\"]}: {c[\"_count\"][\"categoryItems\"]} items')
"
```

Expected: Categories with non-zero item counts.

**Step 6: If import fails (README fetch error, parse error, DB error), check the API logs, fix the issue, rebuild, and retry.**

**Step 7: Commit any fixes**

---

## Task 4: Test Sync — GitHub Stats Fetch (REST API)

Verify that `syncGithubStats()` can fetch stars/description/lastCommit for repos via the GitHub REST API.

**Step 1: Pick a small subset to test**

Rather than syncing all 12.8k repos, test the sync on a controlled subset by calling the method indirectly. We'll test via the full pipeline trigger but watch for specific repos.

Record current state of a few known repos:
```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  SELECT github_repo, stars, description, last_commit_at
  FROM repos
  WHERE github_repo IN ('obra/superpowers', 'anthropics/claude-code', 'heyform/heyform');"
```

**Step 2: Trigger the full daily sync (this runs all 5 steps)**

```bash
curl -X POST http://localhost:4000/api/sync/run \
  -H "Authorization: Bearer test-admin-key-123" \
  -H "Content-Type: application/json" 2>&1
```

Watch the API terminal for logs. The sync will:
1. Import all non-archived lists (may take a while)
2. Fetch GitHub stats for all repos (rate-limited, ~5000 calls/hour)
3. Take star snapshots via GraphQL
4. Compute trending
5. Generate markdown

**Important:** This may take 30+ minutes with 12.8k repos. Monitor the API logs for progress.

If the full sync is too slow for testing, consider an alternative: create a temporary test that calls just `syncGithubStats()` for a few repos. But ideally, let it run to verify the complete pipeline.

**Step 3: Verify stats were updated**

```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  SELECT github_repo, stars, description, last_commit_at
  FROM repos
  WHERE github_repo IN ('obra/superpowers', 'anthropics/claude-code', 'heyform/heyform');"
```

Expected: `stars` values should be current (matching what GitHub shows today). `last_commit_at` should be recent.

**Step 4: If any errors occur (rate limiting, API key issues, DB errors), check logs and fix.**

**Step 5: Commit any fixes**

---

## Task 5: Test Star Snapshots (GraphQL Batch)

Verify that `takeStarSnapshots()` creates new star snapshot records using the GitHub GraphQL API.

**Step 1: Check today's snapshots before the sync**

```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  SELECT count(*) as today_snapshots
  FROM star_snapshots
  WHERE snapshot_date = CURRENT_DATE;"
```

Expected: 0 (if the sync hasn't run today) or N (if Task 4's sync already created them).

**Step 2: If Task 4's sync already ran, verify the snapshots**

```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  SELECT ss.snapshot_date, r.github_repo, ss.stars
  FROM star_snapshots ss
  JOIN repos r ON r.id = ss.repo_id
  WHERE ss.snapshot_date = CURRENT_DATE
  ORDER BY ss.stars DESC
  LIMIT 10;"
```

Expected: Snapshot records for today with current star counts.

**Step 3: Verify the GraphQL batch is working by checking log output**

In the API logs from the sync run, look for messages like:
- `Batch fetching stars for N repos`
- `Snapshotted: N, Skipped: N`

If you see "skipped" for all repos, the GraphQL query may be failing — check for authentication errors or query syntax issues.

**Step 4: Commit any fixes**

---

## Task 6: Test Trending Computation

Verify that `computeTrending()` correctly calculates 7d/30d/90d deltas from star snapshots.

**Step 1: Check a repo with known snapshot history**

```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  SELECT ss.snapshot_date, ss.stars
  FROM star_snapshots ss
  JOIN repos r ON r.id = ss.repo_id
  WHERE r.github_repo = 'obra/superpowers'
  ORDER BY ss.snapshot_date DESC
  LIMIT 10;"
```

**Step 2: Manually calculate expected trending**

From the snapshot output:
- `stars_7d` = today's stars - stars from ~7 days ago (±3 day tolerance)
- `stars_30d` = today's stars - stars from ~30 days ago
- `stars_90d` = today's stars - stars from ~90 days ago

**Step 3: Verify the computed trending matches**

```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  SELECT github_repo, stars, stars_7d, stars_30d, stars_90d
  FROM repos
  WHERE github_repo = 'obra/superpowers';"
```

Expected: `stars_7d`, `stars_30d`, `stars_90d` match the manual calculation from Step 2 (within tolerance of snapshot date selection).

**Step 4: Verify trending API endpoint returns these values**

```bash
curl -s 'http://localhost:4000/api/trending?period=7d&limit=5' | python3 -m json.tool
```

Expected: Repos with non-zero trending values, sorted by the period field descending.

**Step 5: Commit any fixes**

---

## Task 7: Test Markdown Generation

Verify that `generateMarkdown()` produces correct markdown files in `static/awesomer/`.

**Step 1: Record current state of existing markdown files**

```bash
ls -la static/awesomer/*.md | wc -l
# And check a specific file timestamp
ls -la static/awesomer/awesome-claude-code.md 2>/dev/null
```

**Step 2: If the full sync from Task 4 already ran, check the output**

If not, trigger just markdown generation. Since there's no standalone endpoint for this, we can either:
- Trigger the full sync again (`POST /sync/run`), or
- Create a quick one-off script to call `generateMarkdown()`

**Step 3: Verify generated markdown quality**

```bash
head -50 static/awesomer/awesome-claude-code.md
```

Expected markdown should contain:
- Title and description
- Table of Contents
- "Top 10: Stars" section with a table
- "Top 10: 30-Day Trending" section (if trending data exists)
- Category sections with repo tables (Name | Description | Stars | 7d | 30d | 90d | Last Commit)

**Step 4: Compare with the Rails-generated version**

If the Rails app previously generated markdown, diff the outputs:
```bash
# Check if there's a pre-existing Rails version for comparison
diff <(head -100 static/awesomer/awesome-claude-code.md) <(git show HEAD:static/awesomer/awesome-claude-code.md | head -100) 2>/dev/null
```

**Step 5: Verify markdown for multiple lists**

```bash
# Check that markdown was generated for active lists
for f in static/awesomer/awesome-selfhosted.md static/awesomer/awesome-docker.md; do
  echo "=== $f ==="
  wc -l "$f" 2>/dev/null || echo "MISSING"
done
```

Expected: Files exist with substantial content (hundreds of lines for large lists).

**Step 6: Commit any fixes**

---

## Task 8: Test Newsletter Subscribe/Unsubscribe

Verify the newsletter subscription flow works end-to-end.

**Step 1: Get an awesome list ID**

```bash
LIST_ID=$(curl -s http://localhost:4000/api/awesome-lists/awesome-claude-code | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['id'])")
echo "List ID: $LIST_ID"
```

**Step 2: Subscribe**

```bash
curl -s -X POST http://localhost:4000/api/newsletter/subscribe \
  -H "Content-Type: application/json" \
  -d "{\"email\": \"test@example.com\", \"awesome_list_id\": $LIST_ID}" | python3 -m json.tool
```

Expected: Success response with subscriber record.

**Step 3: Verify subscription in DB**

```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  SELECT email, awesome_list_id, confirmed, unsubscribed_at
  FROM newsletter_subscribers
  WHERE email = 'test@example.com';"
```

Expected: Record exists, `unsubscribed_at` is NULL.

**Step 4: Try duplicate subscription**

```bash
curl -s -X POST http://localhost:4000/api/newsletter/subscribe \
  -H "Content-Type: application/json" \
  -d "{\"email\": \"test@example.com\", \"awesome_list_id\": $LIST_ID}"
```

Expected: 409 Conflict (already subscribed).

**Step 5: Unsubscribe**

```bash
curl -s -X POST http://localhost:4000/api/newsletter/unsubscribe \
  -H "Content-Type: application/json" \
  -d "{\"email\": \"test@example.com\", \"awesome_list_id\": $LIST_ID}" | python3 -m json.tool
```

Expected: Success. Verify in DB that `unsubscribed_at` is now set.

**Step 6: Clean up test data**

```bash
psql "postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" -c "
  DELETE FROM newsletter_subscribers WHERE email = 'test@example.com';"
```

**Step 7: Test from the frontend**

Visit `http://localhost:3000/awesome-claude-code/newsletter` in a browser. Enter an email and submit. Verify success message appears.

**Step 8: Commit any fixes**

---

## Task 9: End-to-End Smoke Test

Final verification that the full user journey works.

**Step 1: Walk through the user flow**

Open `http://localhost:3000` in a browser and verify:

1. **Home page**: Grid of verticals loads, each shows name + category count
2. **Click a vertical** (e.g., awesome-selfhosted): Trending tables show, categories listed with counts
3. **Click "Browse all repos"**: Table with stars, sorting works (click 7d/30d/90d headers)
4. **Search for "docker"**: Results appear with debounce, pagination works
5. **Click a repo**: Detail page shows stats grid, star history chart renders, "Found in" categories listed
6. **Global trending page** (`/trending`): Period selector works, repos sorted by trending
7. **Swagger docs** (`http://localhost:4000/api/docs`): All endpoints documented

**Step 2: Check for console errors**

In the browser devtools Console tab, verify no JavaScript errors on any page.
In the Network tab, verify all API calls return 200 (no 500s or unexpected 404s).

**Step 3: Document any issues found**

Create a summary of:
- Features that work correctly
- Features that have bugs (with details)
- Features that need further work

**Step 4: Commit all remaining fixes**

**Step 5: Final commit with test results**

```bash
git add -A
git commit -m "test: live verification of NestJS migration

All core features verified:
- API endpoints (awesome-lists, repos, trending, search, categories, featured, newsletter)
- Frontend pages (home, vertical, repos, detail, trending, search, newsletter)
- Sync pipeline (import, GitHub stats, star snapshots, trending computation, markdown generation)
- Newsletter subscribe/unsubscribe flow"
```
