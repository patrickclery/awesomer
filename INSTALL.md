# Awesomer

Multi-vertical platform for discovering trending open-source tools from curated GitHub Awesome Lists.

**Live site:** [patrickclery.com/awesomer](https://patrickclery.com/awesomer/)

## What It Does

Awesomer tracks GitHub stars across repositories listed in curated Awesome Lists (like [awesome-go](https://github.com/avelino/awesome-go), [awesome-python](https://github.com/vinta/awesome-python), etc.) and computes 7-day, 30-day, and 90-day trending data from daily star snapshots. It generates both a static website and GitHub-native markdown files.

## Architecture

| Component | Stack | Location |
|-----------|-------|----------|
| API | NestJS 11, TypeScript, Prisma 7, PostgreSQL | `api/` |
| Frontend | Next.js 16, React 19, Tailwind CSS 4 | `web/` |
| Static Site | GitHub Pages (deployed to `gh-pages` branch) | Built from `web/out/` |
| Markdown | Generated `.md` files for GitHub browsing | `l/`, `r/` dirs on `gh-pages` |

## Quick Start

### Prerequisites

- Node.js 22+
- PostgreSQL 14+

### Setup

```bash
# API
cd api
cp .env.example .env        # Configure DATABASE_URL, GITHUB_API_KEY
npm install
npx prisma generate
npx prisma migrate dev
npm run start:dev            # Runs on port 4000

# Frontend
cd web
npm install
npm run dev                  # Runs on port 3000
```

### Build Static Site

```bash
cd web
BASE_PATH=/awesomer npm run build    # Outputs to web/out/
```

The API must be running on port 4000 during build -- Next.js fetches data at build time.

## Daily Sync Pipeline

Runs automatically at 2 AM UTC (or manually via `POST /api/sync/run`):

1. **Import** -- Fetch Awesome List READMEs from GitHub, parse markdown, upsert categories/items
2. **Stats** -- REST API calls for each repo (stars, description, last commit)
3. **Snapshots** -- GraphQL batch queries (100 repos/request) for daily star counts
4. **Trending** -- Compute 7d/30d/90d deltas from snapshots
5. **Markdown** -- Generate `.md` files for GitHub browsing
6. **Rebuild** -- Build Next.js static site
7. **Deploy** -- Force-push to `gh-pages` branch

## Environment Variables

See `api/.env.example` for all options. Key variables:

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | PostgreSQL connection string |
| `GITHUB_API_KEY` | Yes | GitHub personal access token (for sync) |
| `ADMIN_API_KEY` | Yes | Bearer token for admin sync endpoints |
| `PORT` | No | API port (default: 4000) |
| `BASE_PATH` | No | Static site base path (default: `/awesomer`) |

## License

MIT
