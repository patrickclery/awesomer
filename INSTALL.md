# Awesomer

What if every Awesome List had a trending page? Now they do.

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
- npm
- PostgreSQL 14+, running locally
- [`just`](https://github.com/casey/just) (only needed for `just dev`)

### Setup

Run from the repo root:

```bash
# API
cd api
cp .env.example .env        # Fill in DATABASE_URL, GITHUB_API_KEY and ADMIN_API_KEY
npm install
npx prisma generate
npx prisma migrate dev

# Frontend
cd ../web
npm install
```

### Run

With PostgreSQL already running, start both dev servers from the repo root:

```bash
just dev
```

This starts the API (`npm run start:dev` in `api/`) on port 4000, with routes under `/api`. About 10 seconds later it starts the frontend (`npm run dev` in `web/`) on port 3000. Ctrl+C stops both.

Without `just`, use two terminals:

```bash
cd api && npm run start:dev   # http://localhost:4000/api
cd web && npm run dev         # http://localhost:3000
```

### Build Static Site

The static build has two prerequisites:

1. **The API must be running on port 4000.** Pages fetch data at build time from `NEXT_PUBLIC_API_URL`, which defaults to `http://localhost:4000/api`.
2. **`web/data/lists.json` and `web/data/repo-slugs.json` must exist.** The list and repo pages read these files, and the build throws without them. Generate them in `api/` with `npm run build` followed by `npm run export:static` (the export script imports the compiled `dist/` code).

After any database change, delete `web/.next` before rebuilding. Otherwise Next.js reuses cached page data and the output silently keeps old content. The pipeline's `rebuild` step does this on its own.

#### Local build

Run from `web/`:

```bash
rm -rf .next
npm run build
python3 -m http.server 3000 --directory out
```

Local builds leave `BASE_PATH` unset, so every URL is root-relative (`web/next.config.ts` falls back to an empty base path). Do not set it for local serving. Output goes to `web/out/`.

#### Production build (GitHub Pages)

Run from `web/`:

```bash
rm -rf .next
BASE_PATH=/awesomer npm run build
```

Without the `BASE_PATH` prefix, every `/_next/` asset URL lacks `/awesomer` and the deployed site renders without CSS or JS. The pipeline's `rebuild` step sets it automatically, defaulting to `/awesomer`.

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
