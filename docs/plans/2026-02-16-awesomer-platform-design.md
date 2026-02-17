# Awesomer Platform Design

## Vision

A multi-vertical authority platform for discovering trending open-source tools, starting with agentic coding and Claude Code. GitHub stars are the ranking signal — no voting, no hype, just data. The platform positions its curator as an authoritative voice in each vertical.

Think ProductHunt's discovery, powered by real GitHub trending data, across a network of curated verticals.

## Architecture

### System Overview

Two independent repos, one self-hosted workstation, all in Docker.

```
┌─────────────────────────────────────────────────────┐
│           RTX 3090 / AMD 5900X / 64GB RAM           │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐      │
│  │ Next.js  │→ │ NestJS   │→ │ PostgreSQL   │      │
│  │ :3000    │  │ :4000    │  │ :5432        │      │
│  └──────────┘  └──────────┘  └──────────────┘      │
│       ↑             │         ┌──────────────┐      │
│       │             │→────────│ Redis/Valkey │      │
│       │             │         │ :6379        │      │
│  ┌──────────┐       │         └──────────────┘      │
│  │ Caddy    │       │                               │
│  │ :80/:443 │  ┌────┴────┐    ┌──────────────┐      │
│  └──────────┘  │Cron Jobs│    │ Listmonk     │      │
│                │• sync   │    │ :9000        │      │
│                │• snap   │    └──────────────┘      │
│                │• trend  │                          │
│                │• md gen │                          │
│                │• digest │                          │
│                └────────┘                           │
└─────────────────────────────────────────────────────┘
```

### Tech Stack

**Frontend (separate repo):**
- Next.js (React) with server-side rendering for SEO
- Tailwind CSS for styling (dark theme, desktop-first)
- TanStack React Table for sortable/filterable data tables
- Recharts or Lightweight Charts for star history sparklines
- next-seo for per-vertical meta tags

**Backend (separate repo):**
- NestJS with TypeScript
- Prisma ORM for PostgreSQL
- Octokit + @octokit/plugin-throttling for GitHub API with built-in rate limiting
- @nestjs/schedule for cron jobs
- BullMQ + Redis for job queue persistence and retries
- AdminJS (@adminjs/nestjs + @adminjs/prisma) for admin panel
- marked or remark for markdown parsing
- Handlebars for markdown generation templates

**Infrastructure (Docker Compose):**
- PostgreSQL 16
- Redis/Valkey
- Caddy (reverse proxy, auto SSL)
- Listmonk (newsletter management)

### Repos

- `awesomer-web` — Next.js frontend
- `awesomer-api` — NestJS backend

OpenAPI spec generated from NestJS, consumed by the frontend for type safety across the boundary.

## Data Model

### Migrated from Rails

**repos**
- `id`, `github_repo` (unique), `description`, `stars`, `previous_stars`
- `stars_7d`, `stars_30d`, `stars_90d` (computed trending deltas)
- `last_commit_at`, `star_history_fetched_at`
- `import_source_id` (nullable FK to awesome_lists — shows provenance)

**star_snapshots**
- `id`, `repo_id`, `snapshot_date`, `stars`
- Unique constraint on (repo_id, snapshot_date)

**awesome_lists**
- `id`, `name`, `slug`, `description`, `github_repo`
- `last_synced_at`, `last_imported_at`
- Serves as both a grouping mechanism and a bootstrap/import source
- Repos can be added manually without an awesome list

**categories**
- `id`, `name`, `slug`, `awesome_list_id`, `parent_id`
- Your taxonomy, not inherited from READMEs

**category_items**
- `id`, `name`, `description`, `github_description`
- `primary_url`, `github_repo`, `demo_url`
- `stars`, `stars_7d`, `stars_30d`, `stars_90d`
- `last_commit_at`, `category_id`, `repo_id`

### New Tables

**featured_profiles**
- `id`, `name`, `avatar_url`, `bio`, `github_handle`, `twitter_handle`, `website`
- `profile_type` (creator | power_user | contributor)
- `awesome_list_id` (scoped per vertical)
- `featured_date`, `is_active`

**newsletter_subscribers**
- `id`, `email`, `awesome_list_id` (scoped per vertical)
- `subscribed_at`, `unsubscribed_at`, `confirmed`

**newsletter_issues**
- `id`, `awesome_list_id`, `subject`, `html_content`
- `sent_at`, `issue_number`
- `trending_data_snapshot` (JSON — that week's movers)

**tags** + **repo_tags** (join table)
- Flexible labeling beyond categories
- Examples: "mcp", "claude", "cursor", "agent-framework", "code-review"

**sync_runs**
- `id`, `awesome_list_id`, `started_at`, `completed_at`
- `status`, `items_synced`, `error_message`
- Replaces Rails sync_logs and github_api_requests

### Dropped from Rails

- `github_api_requests` — replaced with structured logging
- `sync_logs` — replaced by sync_runs

## URL Structure

```
/                                — Homepage: all verticals, global highlights
/:slug                           — Vertical homepage (trending for that list)
/:slug/repos                     — Browse all repos in that vertical
/:slug/repos/:repo-slug          — Repo detail with star history chart
/:slug/featured                  — Featured profiles for that vertical
/:slug/newsletter                — Newsletter signup + archive for that vertical

/trending                        — Global trending across all verticals
/search?q=ollama                 — Global search across everything

/admin/*                         — AdminJS panel (auth required)
```

## Pages

### Homepage (`/`)

Directory of verticals. Cards for each awesome list showing name, description, repo count, and a "hottest repo this week" teaser. Global search bar. Entry point into the network.

### Vertical Homepage (`/:slug`)

Three trending tables: 7-day, 30-day, 90-day movers. Each shows rank, repo name, description, stars, and delta. Featured profile spotlight below. Newsletter signup CTA.

### Browse Repos (`/:slug/repos`)

All repos in a vertical, grouped by category. Sortable columns: stars, 7d, 30d, 90d, last commit. Filterable by category via sidebar. Search within the vertical.

### Repo Detail (`/:slug/repos/:repo-slug`)

Star count, trending deltas, description, GitHub links. Star history chart from snapshot data. Categories and tags. Related repos in the same category.

### Featured (`/:slug/featured`)

Current spotlight at top, archive of past features below. Cards: name, avatar, bio, type, links.

### Newsletter (`/:slug/newsletter`)

Email signup form scoped to that vertical. Archive of past issues.

### Global elements

- Persistent search bar in header
- Dark theme by default
- Responsive, desktop-first
- Minimal nav: Home, Trending, search

## API Design

### Public Endpoints

```
GET /api/awesome-lists                      — All verticals
GET /api/awesome-lists/:slug                — Single vertical with categories
GET /api/awesome-lists/:slug/repos          — Repos in a vertical (paginated)
    ?sort=stars|trending_7d|trending_30d|trending_90d
    ?category=mcp-servers
    ?search=ollama
    ?min_stars=100

GET /api/repos/:id                          — Single repo detail
GET /api/repos/:id/star-history             — Snapshot time-series

GET /api/trending                           — Global trending
    ?period=7d|30d|90d
    ?limit=10|25|50

GET /api/categories                         — All categories
GET /api/categories/:slug/repos             — Repos in a category

GET /api/featured                           — Current featured profiles
POST /api/newsletter/subscribe              — Email signup
```

### Admin Endpoints (auth required)

```
POST   /api/admin/repos                     — Add repo manually
PUT    /api/admin/repos/:id                 — Edit repo metadata
DELETE /api/admin/repos/:id                 — Remove repo
POST   /api/admin/featured                  — Add featured profile
PUT    /api/admin/categories/:id            — Rename/reorganize
POST   /api/admin/import                    — Trigger awesome list import
POST   /api/admin/sync                      — Trigger GitHub sync
```

Response envelope: `{ data, meta: { total, page, per_page } }`

## Sync Pipeline

Five scheduled jobs in NestJS, replacing the Rails pipeline.

### 1. Import from Awesome List
- Fetches README from GitHub via Octokit
- Parses markdown to extract repos and categories
- Creates/updates repos and category_items
- Triggered on-demand via admin API
- Replaces: FetchReadmeOperation + ParseMarkdownOperation

### 2. GitHub Stats Sync
- Iterates repos, fetches current stars and last commit
- Uses @octokit/plugin-throttling for automatic rate limiting
- Runs daily via @nestjs/schedule
- Replaces: SyncGitStatsOperation

### 3. Star Snapshots
- Records one star_snapshot per repo per day
- Uses GitHub GraphQL API for batch fetching (100 repos/request)
- Runs daily after stats sync
- Replaces: SnapshotStarsOperation

### 4. Trending Computation
- Diffs today's snapshot against 7/30/90 days ago
- 3-day tolerance window for missing snapshots
- Updates repos.stars_7d/30d/90d
- Runs daily after snapshots
- Replaces: ComputeTrendingOperation

### 5. Markdown Generation
- Reads from database, generates markdown files
- Pushes to GitHub static repo
- Preserves backward compatibility with existing output format
- Runs after trending computation
- Replaces: ProcessCategoryServiceEnhanced

### Rate Limiting

@octokit/plugin-throttling handles GitHub rate limiting at the HTTP client level:
- Reads x-ratelimit-remaining headers automatically
- Pauses requests when approaching the limit
- Handles 429 responses with retry-after
- Manages secondary (abuse) rate limits
- Queues concurrent requests

No custom Redis sliding window needed. BullMQ handles job persistence and crash recovery.

### Job Orchestration

Pipeline runs sequentially via @nestjs/schedule cron triggers:
sync → snapshot → trending → markdown

Each step logs to sync_runs table. Failed steps don't block subsequent runs.

## Newsletter System

**Listmonk** runs in Docker alongside everything else. Self-hosted newsletter management with its own PostgreSQL database.

### Automated Weekly Digest

A scheduled job runs every Monday:
1. Queries top movers per vertical for the past 7 days
2. Generates email content from a template
3. Pushes to Listmonk via its API for delivery

### Email Structure

```
Subject: "Awesomer Weekly: Claude Code — Feb 16, 2026"

Top 5 Trending This Week
  1. repo-name (+342 stars) — one-line description
  2. ...

New Entries
  Repos added to the directory this week

By the Numbers
  Total repos tracked: 234
  Most active category: MCP Servers
  Biggest mover: repo-name (+342)
```

Subscribers who follow multiple verticals get one email per vertical. Unsubscribe link in every email.

SMTP relay needed for actual delivery (Mailgun, SES, or similar as a dumb pipe). Listmonk manages subscribers, templates, and sending logic.

## Admin Interface

AdminJS bundled into the NestJS app. Auto-generates CRUD screens from Prisma models. Covers:

- Add/edit/remove repos
- Manage categories and tags
- Create featured profiles
- Trigger imports and syncs
- View sync_runs history
- Manage newsletter subscribers (alongside Listmonk)

Accessible at `/admin`, protected by authentication (just you). Replace with custom UI later if needed.

## Migration & Launch Plan

### Phase 1: Scaffold
- Set up both repos, Docker Compose, Prisma schema
- NestJS booting and connecting to Postgres
- Next.js rendering behind Caddy

### Phase 2: Data Migration
- Export from Rails Postgres (pg_dump or migration script)
- Import into Prisma-managed database
- Verify row counts for repos, star_snapshots, categories, category_items

### Phase 3: Sync Pipeline
- Rewrite five pipeline jobs in NestJS
- Test each against real GitHub data
- Verify markdown output matches Rails output
- Most work lives here — this is the core engine

### Phase 4: API
- Build REST endpoints with pagination, filtering, sorting, search
- Admin endpoints with auth
- Test with curl/Postman before touching frontend

### Phase 5: Frontend
- Homepage with vertical cards
- Vertical pages with trending tables
- Repo detail with star history charts
- Search
- Dark theme with Tailwind

### Phase 6: Extras
- Featured profiles
- Listmonk integration for newsletters
- AdminJS panel
- Markdown push to GitHub

### Phase 7: Go Live
- Point domain at workstation
- Caddy handles SSL
- Share it

### Rails Retirement
Keep Rails running in parallel during phases 3-4 so markdown output continues. Cut over once NestJS produces identical output.
