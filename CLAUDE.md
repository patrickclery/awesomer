# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

Awesomer is a multi-vertical platform for discovering trending open-source tools from curated GitHub Awesome Lists. It consists of a **NestJS API** (`api/`) and a **Next.js frontend** (`web/`), backed by PostgreSQL via Prisma ORM.

## Monorepo Structure

```
api/           → NestJS 11 backend (TypeScript, ESM, Prisma 7)
web/           → Next.js 16 frontend (React 19, Tailwind CSS 4)
docs/plans/    → Architecture decision records
```

## Common Commands

### API (`api/`)
```bash
cd api

# Install dependencies
npm install --legacy-peer-deps    # needed due to AdminJS peer dep conflicts

# Generate Prisma client (after schema changes)
npx prisma generate

# Create/apply migrations
npx prisma migrate dev --name description_here

# Build
npm run build                     # nest build → dist/src/

# Start (development)
npm run start:dev                 # nest start --watch

# Start (production)
npm run start:prod                # node dist/src/main.js

# Note: DATABASE_URL must be set (see .env.example)
```

### Frontend (`web/`)
```bash
cd web

npm install
npm run dev                       # Next.js dev server on port 3000
npm run build                     # Production build
```

### Database
```bash
cd api

# Run migrations
npx prisma migrate dev

# Reset database
npx prisma migrate reset

# Open Prisma Studio (GUI)
npx prisma studio

# Migrate data from Rails database
DATABASE_URL="..." npx tsx scripts/migrate-from-rails.ts
```

### Docker (development)
```bash
# Start PostgreSQL + Redis
docker compose -f docker-compose.platform.yml up -d postgres redis
```

## Architecture

### API Modules (`api/src/`)

| Module | Purpose |
|--------|---------|
| `prisma/` | PrismaService — wraps PrismaClient with `@prisma/adapter-pg` for Prisma 7 |
| `awesome-lists/` | CRUD for awesome list verticals |
| `repos/` | Repo queries, global search, star history |
| `categories/` | Category browsing within a vertical |
| `trending/` | Trending repos (7d/30d/90d) from star snapshot diffs |
| `featured/` | Featured developer profiles |
| `newsletter/` | Subscribe/unsubscribe, Listmonk integration |
| `sync/` | Sync pipeline: fetch README → parse → upsert categories/items → fetch stars |
| `admin/` | AdminJS panel (currently disabled — ESM incompatibility with tiptap) |

### Key Technical Decisions

- **ESM throughout**: `"type": "module"` in `api/package.json`. All imports use `.js` extensions.
- **Prisma 7 client engine**: Requires `@prisma/adapter-pg` — no native engine. PrismaService uses a cast pattern to extend PrismaClient while passing adapter options.
- **Generated files in `src/`**: Prisma output goes to `api/src/generated/prisma/` so tsc compiles it alongside the app. This directory is gitignored.
- **GitHub API**: Uses `octokit` with `@octokit/plugin-throttling` for automatic rate limiting.
- **Trending computation**: Compares star snapshots with 3-day tolerance windows at 7d/30d/90d intervals.

### Data Model (Prisma schema at `api/prisma/schema.prisma`)

Core tables: `AwesomeList`, `Category`, `CategoryItem`, `Repo`, `StarSnapshot`
Supporting: `FeaturedProfile`, `NewsletterSubscriber`, `NewsletterIssue`, `Tag`, `RepoTag`, `SyncRun`

CategoryItem links to both a Category (which vertical/section) and optionally a Repo (which has star snapshots and trending data).

### Frontend (`web/src/`)

- App Router with dynamic `[slug]` routes per vertical
- `lib/api.ts` — centralized API client pointing to `localhost:4000/api`
- Dark theme via Tailwind CSS 4
- recharts for star history visualization

## Environment Variables

See `api/.env.example` for all options. Key ones:
- `DATABASE_URL` — PostgreSQL connection string (required)
- `GITHUB_API_KEY` — GitHub personal access token for sync operations
- `PORT` — API port (default: 4000)

## Development Guidelines

- Always run `npm run build` in `api/` after changes to verify compilation before committing
- The `pg` module returns primary key columns as strings — use `Number()` when mapping IDs
- AdminJS is temporarily disabled due to ESM compatibility issues with `@tiptap/core`
- Never commit API keys, `.env` files, or generated Prisma client to the repository

### Plan Documents

After completing a feature via `superpowers:executing-plans`, commit the plan document from `docs/plans/` along with the implementation.
