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

#### Containerized build (Docker)

This builds the API and the `/awesomer` static export inside one image, with no API process on the host. The container joins the `awesomer_default` network and reads the live database as host `awesomer-postgres`, then copies the result into the staging directory `.awesomer-build/staging/`. Only after the container exits 0 does `docker/build.sh` swap staging into `web/out/` with two renames, so a failed or interrupted build never leaves `web/out/` empty or partial. It never deploys: the nightly timer remains the deploy path.

Run from the repo root:

```bash
bash docker/build.sh

# Equivalent, if just is installed
just docker-build

# Raw command, without the preflight guards. It only fills
# .awesomer-build/staging/; web/out/ is not updated.
mkdir -p .awesomer-build/staging
docker compose -f docker-compose.build.yml run --rm --build builder
```

Prerequisites:

- Docker with Compose v2.
- `awesomer-postgres` running and healthy (`sudo systemctl start awesomer-postgres`).
- `api/.env` present, with `DATABASE_URL` pointing at `localhost`. The container rewrites only the host.
- Run it as your normal user, never with sudo.

`docker/build.sh` exit codes:

| Code | Meaning |
|------|---------|
| 0 | Success; `web/out/` replaced |
| 1 | Build failed; `web/out/` left as it was |
| 64 | The `DATABASE_URL` host is not `localhost` or `127.0.0.1` |
| 69 | Network `awesomer_default` missing or `awesomer-postgres` not healthy |
| 73 | `.awesomer-build/staging/` not writable by the container |
| 74 | Build succeeded but the swap into `web/out/` failed; `web/out/` left as it was |
| 75 | Refused: another build is running, the nightly unit is running (checked before the build and again before the swap), it is 10:30-11:45 UTC, or a previous build container remains |
| 77 | Run as root |

Cautions:

- Do not start it near 11:00 UTC. The image's API carries the same in-process cron, and the build script stops it, but the nightly and the build would still both write `web/out/`. `docker/build.sh` refuses inside 10:30-11:45 UTC.
- `docker compose -f docker-compose.build.yml config` prints the env file's secrets unless you pass `--no-env-resolution`.
- The top-level `name: awesomer-build` keeps compose away from the live Postgres project, which is also named `awesomer`. Never remove it, and never add a root `docker-compose.yml` or `compose.yaml`.

Verify:

```bash
bash docker/verify-build.sh all       # static shape, image contents, live infra untouched
bash docker/verify-build.sh output    # web/out looks like a good /awesomer export
bash docker/verify-build.sh failure   # a failed build exits non-zero and leaves web/out alone
```

Preview the output under `/awesomer`, then open `http://localhost:3001/awesomer/`:

```bash
mkdir -p /tmp/srv && ln -sfn "$PWD/web/out" /tmp/srv/awesomer && python3 -m http.server 3001 --directory /tmp/srv
```

Remove the image when done: `docker image rm awesomer-build:local`.

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

The nightly pipeline is `runDailyPipeline()`. Four entry points run it:

- `npm run sync:pipeline` with no arguments, which runs `scripts/run-daily-pipeline.js` (after `npm run build` in `api/`). The script starts its own HTTP listener on `PORT` (default 4000), because the static build fetches from the API. If an API is already listening on that port, it uses that one instead. It closes its own listener when the run finishes.
- The in-process cron (`0 11 * * *`), while the API is running.
- `POST /api/sync/daily`.
- The `awesomer-sync-snapshots.timer` systemd timer, which runs `scripts/run-daily-pipeline.js` daily at 11:00 UTC. See [Running on a host (systemd)](#running-on-a-host-systemd).

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

### Running on a host (systemd)

In production the nightly run is the systemd timer `awesomer-sync-snapshots.timer`, which starts the oneshot `awesomer-sync-snapshots.service` daily at 11:00 UTC. Because of `Persistent=true`, a run missed while the host was off fires at the next boot. The service runs `node scripts/run-daily-pipeline.js` from `api/`, the same runner as `npm run sync:pipeline`, against Postgres in the `awesomer-postgres` container. The files in `deploy/` are copies of what a running host uses.

#### Files

| File | Installed to | Purpose |
|------|--------------|---------|
| `deploy/host/awesomer-sync-snapshots.service` | `/etc/systemd/system/` | Oneshot with `User=`, `WorkingDirectory=` at `api/`, and `EnvironmentFile=` loading `api/.env`. It pins `PATH` to system directories, has a 1-hour timeout, and logs to the journal. |
| `deploy/host/awesomer-sync-snapshots.timer` | `/etc/systemd/system/` | Runs the service at 11:00 UTC with `Persistent=true`. |
| `deploy/host/awesomer-postgres.service` | `/etc/systemd/system/` | Runs `docker compose up -d` in `/opt/awesomer` after Docker is up. It refuses to start unless the data directory holds an initialized cluster (it checks for `PG_VERSION`). |
| `deploy/docker-compose.yml` | `/opt/awesomer/` | Runs `postgres:18-alpine` on `127.0.0.1:5432` with data in `/var/lib/docker-data/awesomer/data`, and passes `POSTGRES_PASSWORD` from `/opt/awesomer/.env` to the image, which uses it only to seed the superuser password when it initializes an empty data directory. A restored `pg_dumpall` sets the real password, so later edits to `.env` change nothing. The app does not use that password: it connects with `DATABASE_URL` from `api/.env`. |
| `deploy/.env.example` | Template for `/opt/awesomer/.env` | Holds only a placeholder `POSTGRES_PASSWORD`. |
| `deploy/deploy.sh` | Not installed | Run from the checkout. Installs the other files and runs `daemon-reload`. |

#### Install

Prerequisites:

- The service unit hardcodes the checkout path and the user. For a different user or path, edit `User=`, `WorkingDirectory=` and `EnvironmentFile=` in `deploy/host/awesomer-sync-snapshots.service` before installing.
- `api/.env` is filled in per [Environment Variables](#environment-variables), with `DATABASE_URL` pointing at `127.0.0.1:5432`.
- Run `npm run build` in `api/` first. The runner imports the compiled `dist/` output, so rerun the build after pulling API changes, or the timer keeps running the old build.
- `node` and `npm` are installed in `/usr/bin`. The unit pins `PATH` to `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin` so that version-manager shims are not used (the mise Node 22.22.1 ships a broken npm).
- Docker with the compose plugin is installed.
- The pipeline pushes as `User=` with no terminal. That user needs a git identity and push access to `origin` without a prompt, for example an HTTPS remote with a stored credential (`git config --global credential.helper store`).

Create the secret file from the template, then set `POSTGRES_PASSWORD` in it to the superuser password:

```bash
sudo mkdir -p /opt/awesomer
sudo install -m 0600 deploy/.env.example /opt/awesomer/.env
```

Then, from the repository root, run the helper and enable the units:

```bash
deploy/deploy.sh
sudo systemctl enable --now awesomer-postgres.service awesomer-sync-snapshots.timer
```

The helper runs the same `install` commands as the manual steps below: it installs `docker-compose.yml` and the three units owned by `root:root` with mode `0644`, and makes `/opt/awesomer` `root:root` `0755`. It copies nothing else, deletes nothing, never touches `/opt/awesomer/.env`, and warns when that file is missing. The manual equivalent:

```bash
sudo install -m 0644 deploy/host/awesomer-postgres.service deploy/host/awesomer-sync-snapshots.service deploy/host/awesomer-sync-snapshots.timer /etc/systemd/system/
sudo install -D -m 0644 deploy/docker-compose.yml /opt/awesomer/docker-compose.yml
sudo systemctl daemon-reload
sudo systemctl enable --now awesomer-postgres.service awesomer-sync-snapshots.timer
```

Optional first run: `sudo systemctl start --no-block awesomer-sync-snapshots.service`. Without `--no-block`, `start` waits for the whole run, about 26 minutes.

New host with no database: `awesomer-postgres.service` will not start on an empty data directory, because there is no `PG_VERSION`. Create `/var/lib/docker-data/awesomer/data` owned by UID 1000, since the compose file runs Postgres as `1000:1000`. Run `sudo docker compose up -d` once in `/opt/awesomer` so the image initializes the cluster. Restore a `pg_dumpall` of the database by piping it into `psql -U postgres` inside the `awesomer-postgres` container: the dump creates the `awesomer` role and the `awesomer_platform` database, which is why the compose file does not let the image pre-create them. Then enable the units as above.

#### Check runs

- `systemctl status awesomer-sync-snapshots.timer` and `systemctl list-timers awesomer-sync-snapshots.timer` show the last and next trigger. `systemctl status awesomer-sync-snapshots.service` shows the last run's result: inactive with `status=0/SUCCESS` after a good run.
- Logs: `journalctl -u awesomer-sync-snapshots`, with `-f` to follow or `--since today`. Reading the system journal needs sudo or membership in the `systemd-journal` group.
- The success signal is the push. A good run force-pushes one `deploy: daily sync YYYY-MM-DD` commit (UTC date) to `gh-pages`. Check it without checking out the branch: `git fetch origin gh-pages && git log -1 --format='%ci %s' FETCH_HEAD`. `main` also gets `chore: auto-update markdown (daily sync YYYY-MM-DD, N files)`, but only when the generated README changed, so only the `gh-pages` commit proves a run happened. If that day's `gh-pages` commit is missing after the run window, read the journal.

The API's in-process cron (`@Cron('0 11 * * *')` on `runDailyPipeline()`, with no time zone set, so it uses the process's local time) is armed in every process that boots `AppModule`. That includes the runner itself. Two cases start a second pipeline alongside the timer's:

- A long-lived API process on the same host. Do not keep one running on a host that uses the timer.
- A runner still in progress at 11:00 in its own time zone. The service sets no `TZ`, so this is the host's local time, not the timer's 11:00 UTC. The scheduled 11:00 UTC run does not reach that time, but a `Persistent=true` catch-up after boot or a manual `systemctl start` can. The second pipeline runs in the same process and races the first on snapshots, the `web/` build and the `gh-pages` push. Avoid manual starts in the hour before 11:00 local time.

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
