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
| Markdown | Generated `l/` and `r/` markdown pages on `gh-pages`, plus a `README.md` committed to `main` | `l/`, `r/` on `gh-pages`; `README.md` on `main` |

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

The nightly pipeline is scheduled by the `@Cron('0 11 * * *')` decorator on `runDailyPipeline()`: `0 11 * * *`, evaluated in the API process's time zone (11:00 UTC on a UTC host). It fires only while the API process is running. See [Deployment](#deployment) for what the nightly run does.

`POST /api/sync/run` and `npm run sync:pipeline -- <step...>` run the steps below, in this order. The names match `ALL_STEPS` in `api/src/sync/sync.service.ts`, and they are the values accepted in the request body's `steps` array and as script arguments.

1. `diff` -- Diff-sync each non-archived awesome list: fetch its README, or the data file its parser declares, add new items, and remove items that are no longer listed. A list whose parser returns zero items while the database still has items is skipped.
2. `stats` -- One REST call per repo for stars, description and last commit.
3. `snapshots` -- GraphQL batch queries (100 repos per request) that upsert today's StarSnapshot and refresh stars, description and last commit.
4. `trending` -- Compute 7d/30d/90d deltas from snapshots, using a 3-day tolerance window.
5. `markdown` -- Generate the markdown pages (`README.md`, `l/`, `r/`).
6. `rebuild` -- Export the `web/data/` JSON, clear `web/.next`, and run the web build with `BASE_PATH` defaulting to `/awesomer` and `NEXT_PUBLIC_API_URL` pointed at this API. Then sanity-check `web/out/` before reporting success.
7. `deploy` -- Copy `web/out/`, minus the Next.js payload files, into a temporary staging directory, generate the markdown pages into it, add `.nojekyll`, and force-push the result to `gh-pages`.

### Pipeline scripts

| Script | What it runs |
|--------|--------------|
| `npm run sync:pipeline` | With no arguments, the full nightly pipeline (see [Deployment](#deployment)). With step names after `--`, only those steps. |
| `npm run sync:snapshots` | The `snapshots` step |
| `npm run sync:trending` | The `trending` step |
| `npm run sync:markdown` | The `markdown` step |
| `npm run sync:rebuild` | The `rebuild` step |
| `npm run sync:stats` | The `stats` step |
| `npm run sync:backfill-stars` | `snapshots`, then `trending` |
| `npm run sync:backfill-list-repos` | Links each awesome list that has no repo record to a Repo row, then hydrates stats, snapshots, star backfill and trending. It runs TypeScript source through `npx tsx`, which does not load `.env`, so pass `DATABASE_URL` on the command line. |
| `npm run export:static` | Writes `web/data/lists.json` and `web/data/repo-slugs.json` for a manual build |

Run every script from `api/`: the `rebuild` and `deploy` steps resolve `web/` relative to the working directory. Run `npm run build` in `api/` first, because every script except `sync:backfill-list-repos` imports the compiled `dist/` output.

## Deployment

The nightly pipeline is `runDailyPipeline()`. Three entry points run it:

- `npm run sync:pipeline` with no arguments, which runs `scripts/run-daily-pipeline.js` (after `npm run build` in `api/`). The script starts its own HTTP listener on `PORT` (default 4000), because the static build fetches from the API. If an API is already listening on that port, it uses that one instead. It closes its own listener when the run finishes.
- The in-process cron (`0 11 * * *`), while the API is running.
- `POST /api/sync/daily`.

It runs `diff`, `snapshots`, `trending`, `rebuild`, `deploy`, then the README commit. It skips `stats`, because snapshots already refresh stats, and it generates the markdown inside `deploy`.

The result: `web/out/`, minus the Next.js payload files and plus the generated `l/` and `r/` markdown, is force-pushed to the `gh-pages` branch from a fresh git repository in a temporary directory. Then only the generated `README.md` is committed and pushed to `main`; that commit is skipped when the README is unchanged. Never check out `gh-pages` locally.

Requirements: an `origin` remote with push access, `rsync`, and a git identity (the deploy commits inherit the global git config).

### Manual trigger

```bash
# All seven steps
curl -X POST http://localhost:4000/api/sync/run -H "Authorization: Bearer $ADMIN_API_KEY"

# Selected steps only
curl -X POST http://localhost:4000/api/sync/run -H "Authorization: Bearer $ADMIN_API_KEY" \
  -H 'Content-Type: application/json' -d '{"steps":["snapshots","trending","rebuild","deploy"]}'
```

`/api/sync/run` runs the seven steps above and does not commit `README.md` to `main`. For the exact nightly sequence, use:

```bash
curl -X POST http://localhost:4000/api/sync/daily -H "Authorization: Bearer $ADMIN_API_KEY"
```

Both calls return immediately and run in the background, so follow progress in the API logs.

## Environment Variables

See `api/.env.example` for all options. Key variables:

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | PostgreSQL connection string. Scripts run through `npx tsx` need it passed explicitly. |
| `GITHUB_API_KEY` | Yes | GitHub personal access token for the sync steps |
| `ADMIN_API_KEY` | Yes | Bearer token for the `POST /api/sync/*` admin endpoints |
| `PORT` | No | API port (default: 4000). The `rebuild` step points the web build at this port. |
| `BASE_PATH` | No | Leave unset for local builds, which then use root-relative URLs (`web/next.config.ts` defaults to an empty base path). Use `/awesomer` for the GitHub Pages build. The `rebuild` step applies `/awesomer` when unset. |
| `NEXT_PUBLIC_API_URL` | No | API base URL the web build fetches from (default: `http://localhost:4000/api`). The `rebuild` step sets it from `PORT`. |
| `NEXT_PUBLIC_UMAMI_SCRIPT_URL` | No | Umami analytics script URL, read at build time by `web/src/app/layout.tsx`. The analytics tag is emitted only when both Umami variables are set. For the nightly rebuild, set both in `api/.env`: the `rebuild` step passes its environment through to the web build and logs a warning when either is missing. |
| `NEXT_PUBLIC_UMAMI_WEBSITE_ID` | No | Umami website ID. Same rules as `NEXT_PUBLIC_UMAMI_SCRIPT_URL`. |

## License

MIT
