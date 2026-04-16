# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

Awesomer is a multi-vertical platform for discovering trending open-source tools from curated GitHub Awesome Lists. It consists of a **NestJS API** (`api/`) and a **Next.js frontend** (`web/`), backed by PostgreSQL via Prisma ORM.

## Repository Structure

This repo is `patrickclery/awesomer` (**PUBLIC**). It contains all source code.

```
api/              → NestJS 11 backend (TypeScript, ESM, Prisma 7)
web/              → Next.js 16 frontend (React 19, Tailwind CSS 4)
```

This repo deploys the static site to GitHub Pages via the `gh-pages` branch.

Sensitive directories (`.planning/`, `.claude/`, `docs/plans/`) are excluded via `.gitignore` and never committed.

## Common Commands

### API (`api/`)
```bash
cd api

# Install dependencies
npm install

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
npm run dev                       # Next.js dev server on port 3000 (for development)
BASE_PATH=/awesomer npm run build # Static export → out/ directory (MUST include BASE_PATH)
python3 -m http.server 3000 --directory out  # Serve static site on port 3000
```

The frontend uses `output: 'export'` for fully static generation. All pages are pre-rendered at build time. The API must be running on port 4000 during `npm run build` since `generateStaticParams()` and server components fetch data from it. The daily sync pipeline automatically rebuilds the static site after completing.

**CRITICAL: Always set `BASE_PATH=/awesomer` when building manually.** Without it, all asset paths (`/_next/...`) are missing the `/awesomer` prefix and the site renders with no CSS/JS. The sync service sets this automatically via `rebuildStaticSite()`, but manual CLI builds do not.

### Database
```bash
cd api

# Run migrations
npx prisma migrate dev

# Reset database
npx prisma migrate reset

# Open Prisma Studio (GUI)
npx prisma studio
```

### Admin Sync Endpoints

All sync endpoints require `Authorization: Bearer ${ADMIN_API_KEY}`:

```bash
# Full daily pipeline (runs async)
curl -X POST http://localhost:4000/api/sync/run -H "Authorization: Bearer $KEY"

# Re-import a specific awesome list
curl -X POST http://localhost:4000/api/sync/import/223 -H "Authorization: Bearer $KEY"

# Markdown-only regeneration
curl -X POST http://localhost:4000/api/sync/markdown -H "Authorization: Bearer $KEY"
```

## Architecture

### API Modules (`api/src/`)

| Module | Purpose | Key Endpoints |
|--------|---------|---------------|
| `prisma/` | PrismaService — wraps PrismaClient with `@prisma/adapter-pg` for Prisma 7 | — |
| `awesome-lists/` | CRUD for awesome list verticals | `GET /api/awesome-lists`, `GET /api/awesome-lists/:slug` |
| `repos/` | Repo queries, global search, star history | `GET /api/awesome-lists/:slug/repos`, `GET /api/search`, `GET /api/repos/:id/star-history` |
| `categories/` | Category browsing within a vertical | `GET /api/categories`, `GET /api/categories/:slug` |
| `trending/` | Trending repos (7d/30d/90d) from star snapshot diffs | `GET /api/trending`, `GET /api/trending/:slug` |
| `featured/` | Featured developer profiles | `GET /api/featured` |
| `sync/` | Sync pipeline + static data export for SSG build | `POST /api/sync/run`, `POST /api/sync/import/:id`, `POST /api/sync/markdown` |

### Sync Pipeline (5 Steps)

The daily sync (`POST /api/sync/run`, also runs at 2 AM UTC via cron):

1. **Import**: Fetch README from GitHub → parse markdown → upsert categories/items
2. **Stats**: REST API calls for each repo (stars, description, lastCommitAt)
3. **Snapshots**: GraphQL batch queries (100 repos/request) → upsert StarSnapshot records
4. **Trending**: Compute 7d/30d/90d deltas from snapshots (±3-day tolerance window)
5. **Markdown**: Generate markdown files (written to deploy staging directory during deployment) with Top 10 tables and per-category sections

Standalone markdown generation: `POST /api/sync/markdown` (no GitHub API needed)

### Key Technical Decisions

- **ESM throughout**: `"type": "module"` in `api/package.json`, `"module": "nodenext"` in tsconfig. All relative imports use `.js` extensions. tsc outputs ESM to `dist/src/`. Required because Prisma 7 generates ESM-only TypeScript — without `"type": "module"`, tsc outputs CJS which breaks with `exports is not defined in ES module scope`.
- **Prisma 7 client engine**: Requires `@prisma/adapter-pg` — no native engine. Uses the `prisma-client` generator (not the old `prisma-client-js`). PrismaService uses a cast pattern to extend PrismaClient (see code pattern below).
- **Generated files in `src/`**: Prisma output goes to `api/src/generated/prisma/` so tsc compiles it alongside the app. This directory is gitignored. Placing output outside `src/` causes ESM/CJS mismatch.
- **GitHub API**: Uses `octokit` with `@octokit/plugin-throttling` for automatic rate limiting. Key methods: `fetchRepoStats(owner, repo)` (REST), `batchFetchStars(repos)` (GraphQL, 100/request), `fetchReadme(owner, repo)`.
- **Trending computation**: Compares star snapshots with 3-day tolerance windows at 7d/30d/90d intervals.

### Critical Code Patterns

**PrismaService cast pattern** — required because Prisma 7's constructor types are stricter:

```typescript
import { PrismaClient } from '../generated/prisma/client.js';
import { PrismaPg } from '@prisma/adapter-pg';
import pg from 'pg';

const BasePrismaClient = PrismaClient as unknown as new (
  opts: Record<string, unknown>,
) => PrismaClient;

@Injectable()
export class PrismaService extends BasePrismaClient
  implements OnModuleInit, OnModuleDestroy {
  private pool: pg.Pool;

  constructor() {
    const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new PrismaPg(pool);
    super({ adapter });
    this.pool = pool;
  }
}
```

**`pg` module ID coercion** — PKs come as strings, FKs as numbers, causing `Map` lookup failures:

```typescript
// WRONG — Map keys are strings, lookups use numbers
const idMap = new Map<number, number>();
idMap.set(row.id, newId);           // row.id is "123" (string)
idMap.get(otherRow.foreign_id);     // foreign_id is 123 (number) → undefined!

// CORRECT — always coerce with Number()
idMap.set(Number(row.id), newId);
idMap.get(Number(otherRow.foreign_id));
```

### Data Model (Prisma schema at `api/prisma/schema.prisma`)

Core tables: `AwesomeList`, `Category`, `CategoryItem`, `Repo`, `StarSnapshot`
Supporting: `FeaturedProfile`, `Tag`, `RepoTag`, `SyncRun`

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
- The `pg` module returns primary key columns as strings — use `Number()` when mapping IDs (see code pattern above)
- Use `.js` extensions in all relative imports — required for ESM
- Set `DATABASE_URL` explicitly when running scripts — `.env` isn't auto-loaded by `npx tsx`
- Restart the API after `nest build` — `dist/` output isn't hot-reloaded in production mode
- Never commit API keys, `.env` files, or generated Prisma client to the repository

### Anti-patterns

- **Don't use `prisma-client-js` generator** — Prisma 7 requires the new `prisma-client` generator for the adapter pattern
- **Don't put Prisma output outside `src/`** — causes ESM/CJS mismatch because tsc can't compile it
- **Don't use `new PrismaClient()` without an adapter** — Prisma 7 client engine requires `adapter` or `accelerateUrl`
- **Don't extend PrismaClient directly** — constructor types are stricter in Prisma 7; use the cast pattern

---

## Static Site Deployment

**Description:** The full workflow for building and deploying the Next.js static export to GitHub Pages via the `gh-pages` branch.

### Key Patterns

The deployment chain is: `web/out/` -> rsync -> `/tmp/gh-pages-deploy/` -> markdown generation -> git init + commit -> force-push to `gh-pages` branch.

**Deploy runs as the final step of the daily sync pipeline:**
```bash
# Trigger via admin endpoint
curl -X POST http://localhost:4000/api/sync/run -H "Authorization: Bearer $KEY"
```

**Next.js cache must be cleared before rebuilds when DB data changes:**
```bash
rm -rf web/.next
BASE_PATH=/awesomer npm run build
```
Without clearing `.next/`, Next.js reuses cached page data from a previous build even if the API now returns different content.

**Verify deployment by checking the build hash:**
```bash
curl -s "https://patrickclery.com/awesomer/" | head -c 200
```
GitHub Pages CDN uses `max-age=600` (10 min). After pushing, wait ~2 min before verifying.

### Best Practices

- **Always use `BASE_PATH=/awesomer npm run build`** for manual builds. The sync service sets this automatically; CLI builds do not.
- **Always clear `.next/` before rebuilding** after any DB changes. Stale cache causes the build to silently serve old data.
- **Never checkout `gh-pages` locally** -- the deploy process uses a temp directory (`/tmp/gh-pages-deploy`), not the working tree.
- **Confirm the deployed hash matches** by checking the live HTML before declaring success.

### Anti-patterns

- **Running `npm run build` without `BASE_PATH=/awesomer`** -> CSS and JS 404, site renders unstyled
- **Not clearing `.next/` after DB cleanup** -> built HTML still contains deleted items
- **Checking out the `gh-pages` branch locally** -> confusing mix of built assets and source code in working tree

### Related Files

- `web/next.config.ts` -- `basePath: process.env.BASE_PATH || ''` and `output: 'export'`
- `api/src/sync/sync.service.ts` -- `deployStaticSite()` method (temp-dir git init + force-push to gh-pages)
- `api/src/sync/sync.service.ts` -- `rebuildStaticSite()` method (sets `BASE_PATH` automatically)

---

## Awesome List Parser Rules

**Description:** Rules for what the sync pipeline imports from GitHub Awesome List READMEs. Only valid GitHub root repo URLs are stored.

### Key Patterns

The parser (via `getParser()` factory in `sync.service.ts`) applies two filters:

1. **`SKIP_URL` regex** — skips file references inside repos:
   ```typescript
   const SKIP_URL = /github\.com\/[^/]+\/[^/]+\/(?:blob|tree|raw)\//i;
   if (SKIP_URL.test(url)) continue;
   ```

2. **`parseGithubRepo` gate** — skips anything that isn't a valid GitHub root repo:
   ```typescript
   const parsed = GithubService.parseGithubRepo(url);
   if (!parsed) continue;  // skip anchor links, blog posts, YouTube, etc.
   ```

`parseGithubRepo` (in `github.service.ts`) only matches `https://github.com/owner/repo` root URLs. It rejects:
- Deep paths: `/blob/`, `/tree/`, `/raw/`, `/releases/`, `/issues/`, etc.
- Anchor-only URLs: `#section-name` (parsed as TOC entries from README headers)
- Non-GitHub URLs: blog posts, YouTube, VS Marketplace, docs sites

### DB Cleanup

To find and remove items that slipped through (e.g. after rule changes):
```sql
-- Non-GitHub items
DELETE FROM category_items WHERE github_repo IS NULL;

-- Blob/tree/raw file references
DELETE FROM category_items
WHERE primary_url ~ 'github\.com/[^/]+/[^/]+/(blob|tree|raw)/';
```

### Anti-patterns

- **Storing items with `github_repo IS NULL`** → they will never get star data and show `—` forever
- **Importing TOC anchor links** (`#agent-skills-`, `#ci--deployment`) — these appear in READMEs as navigation items, not real entries
- **Importing non-root GitHub URLs** (`/blob/main/.claude/commands/run-ci.md`) — these are file paths inside a repo, not the repo itself

### Related Files

- `api/src/sync/sync.service.ts` — parser invocation via `getParser()` factory; contains the `SKIP_URL` filter and `parseGithubRepo` gate
- `api/src/sync/github.service.ts` — `parseGithubRepo()` static method

<!-- GSD:project-start source:PROJECT.md -->
## Project

**Star Snapshot Backfill**

A NestJS service and npm script that backfills missing daily star snapshot data for repos in the Awesomer platform. It uses the OSSInsight API (free, no auth, GH Archive data) to fetch historical daily star counts and fills gaps in the StarSnapshot table for the last 90 days. This ensures trending calculations (7d/30d/90d) have complete data instead of sparse snapshots from the daily sync pipeline.

**Core Value:** Every repo with enough stars has complete 90-day snapshot coverage, so trending deltas are accurate — not inflated or missing because of sparse data.

### Constraints

- **Rate Limit**: OSSInsight allows 600 req/hr — must throttle accordingly
- **Tech Stack**: NestJS 11, TypeScript ESM, Prisma 7 with adapter pattern
- **Data Model**: StarSnapshot has unique constraint on (repoId, snapshotDate) — use upsert
- **Auth**: API endpoint requires `Authorization: Bearer ${ADMIN_API_KEY}` like other sync endpoints
<!-- GSD:project-end -->

<!-- GSD:stack-start source:codebase/STACK.md -->
## Technology Stack

## Languages
- **TypeScript** 5.7.3 - Used for all backend and shared code (ESM strict mode)
- **JavaScript/JSX** - Frontend React components with TypeScript
- **Markdown** - Documentation and README files
- **YAML** - Configuration files
## Runtime
- **Node.js** 22 (Alpine) - Both development and production
- ESM-first architecture with `"type": "module"` in `api/package.json`
- Target ES2023, strict module resolution (`moduleResolution: "nodenext"`)
- **npm**
- Lockfiles: `api/package-lock.json`, `web/package-lock.json`
## Frameworks
- **NestJS** 11.0.1 - Server framework at `api/src/`
- **Prisma** 7.4.0 - ORM with `@prisma/adapter-pg` (Prisma 7 client engine)
- Generated Prisma client outputs to `api/src/generated/prisma/`
- **Next.js** 16.1.6 - App Router with static export (`output: 'export'`)
- **React** 19.2.3 - UI components
- **React DOM** 19.2.3 - DOM rendering
- **Jest** 30.0.0 - Test runner
- **ts-jest** 29.2.5 - TypeScript support for Jest
- **Supertest** 7.0.0 - HTTP assertion library (e2e tests)
- **SWC** (@swc/cli 0.8.0, @swc/core 1.15.11) - Fast TypeScript compiler
- **ts-loader** 9.5.2 - TypeScript loader for webpack
- **ts-node** 10.9.2 - TypeScript execution for scripts
- **tsx** 4.21.0 - Fast TypeScript execution (used in Prisma migrations)
## Key Dependencies
- **@nestjs/core** 11.0.1 - NestJS core
- **@nestjs/common** 11.0.1 - Decorators and pipes
- **@nestjs/config** 4.0.3 - Environment configuration
- **@nestjs/platform-express** 11.0.1 - Express adapter
- **@nestjs/schedule** 6.1.1 - Cron task scheduling (daily sync at 2 AM UTC)
- **@nestjs/swagger** 11.2.6 - OpenAPI documentation at `/api/docs`
- **@prisma/client** 7.4.0 - ORM client
- **@prisma/adapter-pg** 7.4.0 - PostgreSQL adapter for Prisma 7
- **pg** 8.18.0 - Native PostgreSQL driver
- **prisma** 7.4.0 - CLI for migrations and code generation
- **octokit** 5.0.5 - GitHub API client
- **@octokit/plugin-throttling** 11.0.3 - Automatic rate limiting (configurable: 2 retries on primary limit, 1 on secondary)
- **class-validator** 0.14.3 - DTO validation decorators
- **class-transformer** 0.5.1 - DTO transformation
- **reflect-metadata** 0.2.2 - Required for NestJS decorators
- **rxjs** 7.8.1 - Reactive programming (NestJS observable support)
- **dotenv** 17.3.1 - Environment variable loading from `.env` (dev only)
- **gemoji** 8.1.0 - Emoji support
- **recharts** 3.7.0 - Chart library (star history visualization)
- **@tanstack/react-table** 8.21.3 - Headless table component (repo/trending tables)
- **next-seo** 7.2.0 - SEO head tag management
- **figlet** 1.10.0 - ASCII art banner generation
- **tailwindcss** 4 - Utility-first CSS framework
- **@tailwindcss/postcss** 4 - PostCSS plugin for Tailwind
## Configuration
- `DATABASE_URL` - PostgreSQL connection string (e.g., `postgresql://user:pass@host/db`)
- `GITHUB_API_KEY` - GitHub Personal Access Token for API rate limiting and repo fetching
- `ADMIN_API_KEY` - Bearer token for sync endpoint authentication
- `PORT` - API server port (default: 4000)
- `NODE_ENV` - `development` or `production`
- `BASE_PATH` - Static site base path (default: `/awesomer` for GitHub Pages)
- `NEXT_PUBLIC_API_URL` - Frontend API endpoint (default: `http://localhost:4000/api`)
- Module: `nodenext` with `resolvePackageJsonExports: true`
- Target: `ES2023`
- Strict null checks, strict bind/call/apply, no implicit any
- Output: `dist/` (built via `nest build`)
- `output: 'export'` - Static site generation (all pages pre-rendered)
- `basePath: process.env.BASE_PATH || ''` - Prefix for asset paths
- `trailingSlash: true` - URLs end with `/`
- `images.unoptimized: true` - No image optimization (static export)
- 2-space indentation
- 120-char line width
- Single quotes
- No trailing commas
- Special overrides for YAML (100-char width) and Markdown
- typescript-eslint recommended + type-checked rules
- Prettier integration
- Disabled: `@typescript-eslint/no-explicit-any`
- Warnings: floating promises, unsafe arguments
- Next.js core web vitals + TypeScript config
- Ignores: `.next/`, `out/`, `build/`
## Platform Requirements
- Node.js 22+
- npm 10+
- PostgreSQL 14+
- Git
## Deployment Target
- GitHub Pages via `patrickclery/awesomer` public repository
- Served from `gh-pages` branch
- Built with `BASE_PATH=/awesomer npm run build`
- Deployed via force-push to `gh-pages` branch from `/tmp/gh-pages-deploy/` staging directory
- Cron jobs: Daily sync at 2 AM UTC (via `@nestjs/schedule`)
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

## Naming Patterns
- Service files: `{feature}.service.ts` (e.g., `repos.service.ts`, `github.service.ts`)
- Controller files: `{feature}.controller.ts` (e.g., `repos.controller.ts`)
- Module files: `{feature}.module.ts` (e.g., `awesome-lists.module.ts`)
- DTO files: `{name}.dto.ts` (e.g., `pagination.dto.ts`)
- Component files: kebab-case (e.g., `featured-repo.tsx`, `category-section.tsx`)
- Utility files: kebab-case (e.g., `pagination.dto.ts`, `emoji.ts`)
- camelCase for all functions
- Service methods: action-noun pattern (`findBySlug()`, `findById()`, `createUser()`)
- Async functions: no special prefix, async/await usage is standard
- Private helpers: prefix with underscore if needed (rare — most helpers are public)
- camelCase for local variables and parameters
- UPPER_SNAKE_CASE for constants (e.g., `GRAPHQL_BATCH_SIZE`, `TOLERANCE_DAYS`, `MIN_STARS`)
- Single letter names acceptable only in loops (`i`, `j`)
- PascalCase for interfaces (e.g., `RepoStats`, `GraphQLRepoResult`, `PaginatedResponse<T>`)
- PascalCase for DTOs (e.g., `SubscribeDto`, `PaginationDto`)
- Exported types use PascalCase (e.g., `SyncStep`, `TrendingList`)
- Union types defined inline or as type aliases (e.g., `type SyncStep = 'diff' | 'stats' | 'snapshots' | 'trending' | 'markdown' | 'rebuild'`)
## Code Style
- Tool: Prettier 3.4.2
- Line width: 120 characters (root config), 100 for YAML and Markdown
- Indentation: 2 spaces
- Quotes: Single quotes for TypeScript/JavaScript
- Trailing commas: None in root config, all in api `.prettierrc`
- Tool: ESLint 9.18.0 with TypeScript support
- Config: Flat config format (ESLint v9+)
- Presets: `@eslint/js`, `typescript-eslint/recommended-type-checked`, `eslint-plugin-prettier/recommended`
- Key rules:
- API (`api/tsconfig.json`): `target: ES2023`, `module: nodenext`, `strict: true`, `strictNullChecks: true`
- Web (`web/tsconfig.json`): `target: ES2017`, `module: esnext`, `strict: true`
- ESM throughout: `"type": "module"` in API, relative imports use `.js` extensions
- Decorators and metadata: API enables `experimentalDecorators` and `emitDecoratorMetadata`
## Import Organization
- API: None (uses relative paths with `.js` extensions)
- Web: `@/*` maps to `./src/*` in `tsconfig.json`
## Error Handling
- NestJS HttpException hierarchy for API responses: `NotFoundException`, `ConflictException`, `BadRequestException`
- Service methods throw native JavaScript `Error` or NestJS exceptions
- Controllers catch exceptions implicitly (NestJS global error filter handles conversion)
- Frontend API client throws `Error` with formatted message: `throw new Error(\`API error: ${res.status} ${res.statusText}\`)`
## Logging
- Each service instantiates logger: `private readonly logger = new Logger(ClassName.name)`
- Log levels: `log()` for info, `debug()` for detailed traces, `warn()` for warnings, `error()` for errors
- Always include context in error logs: `this.logger.error('Failed to fetch', error)`
- GitHub API rate limit warnings logged with retry info
## Comments
- JSDoc/TSDoc for public interfaces and service methods
- Inline comments for non-obvious logic (e.g., why a coercion is necessary)
- Section separators for large functions (see sync.service.ts examples)
- Service method documentation: `/** Description of what this does */`
- Parameter documentation: Rare (parameter names are typically self-documenting)
## Function Design
- Typical service methods: 20-100 lines
- Larger methods (100+ lines) use section separators and comments to delineate phases
- Explicit named parameters preferred over options objects
- DTOs used for route/query parameters (with `class-validator` decorators)
- Interface types for internal method parameters
- Explicit return type annotations always present
- Nullable returns: `Type | null`
- Generic wrappers for API responses: `PaginatedResponse<T>`, `SingleResponse<T>`
## Module Design
- NestJS modules export providers via `@Module({ providers: [...], exports: [...] })`
- Services exported to make them available to other modules
- Controllers are not exported
- None used (each service/controller imported directly)
- Single item: `{ data: T }` (using `SingleResponse<T>`)
- Paginated: `{ data: T[], meta: { total, page, per_page, total_pages } }` (using `PaginatedResponse<T>`)
- Swagger decorators: `@ApiOperation()`, `@ApiTags()`, `@ApiQuery()`, `@ApiProperty()`
- Functional components with TypeScript interfaces for props
- Props interface names: `{ComponentName}Props`
- Helper functions defined in same file or in `lib/` utilities
- Data fetching via async functions in `lib/api.ts`
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

## Pattern Overview
- **Vertical separation:** API (`api/`) and Frontend (`web/`) are independent applications with distinct build/deploy cycles
- **Data-driven trending computation:** Daily sync pipeline derives trending periods from historical star snapshots with 3-day tolerance windows
- **Markdown-first content generation:** Static markdown output serves as a distribution format and archived data source
- **Static site generation (SSG):** Next.js pre-renders all pages at build time using API data; no runtime API calls after deployment
## Layers
- Purpose: Persistent storage for awesome lists, repositories, categories, and star history
- Location: Managed via Prisma ORM at `api/prisma/schema.prisma`
- Contains: Core tables (`AwesomeList`, `Category`, `CategoryItem`, `Repo`, `StarSnapshot`, `FeaturedProfile`, `Tag`, `RepoTag`, `SyncRun`)
- Depends on: None
- Used by: PrismaService → all API services → controllers
- Purpose: REST endpoints for frontend consumption + internal sync operations
- Location: `api/src/`
- Contains: Modular controllers, services, dependency injection via NestJS
- Depends on: PostgreSQL, GitHub API (Octokit), file system (markdown export)
- Used by: Web frontend (calls `/api/...` endpoints)
- Purpose: Encapsulate domain logic for specific concerns
- Location: `api/src/[module]/[module].service.ts`
- Contains: Data queries, GitHub API interactions, sync pipeline, trending calculations
- Patterns: Injected services call PrismaService for queries, GithubService for GitHub data, ConfigService for environment variables
- Purpose: Handle incoming HTTP requests, validate inputs, return responses
- Location: `api/src/[module]/[module].controller.ts`
- Contains: Route handlers decorated with `@Get()`, `@Post()`, etc.
- Patterns: Controllers delegate to services, format responses as `{ data: T }` or `{ data: T[] }` payloads
- Purpose: Static-rendered user interface
- Location: `web/src/`
- Contains: App Router pages, React components, API client
- Depends on: API at build time only (via `getAwesomeLists()`, `getTrendingByList()`, etc. in `generateStaticParams()`)
- Used by: User browsers (fetches static HTML/CSS/JS from GitHub Pages CDN)
## Data Flow
- **Backend state:** PostgreSQL (source of truth for all data)
- **Frontend state:** None (fully static) + optional client-side React state for UI interactions (filters, sorting, pagination) in pages like `[slug]/page.tsx`
- **Sync state:** Tracked in `SyncRun` table (one record per pipeline execution with status + error message)
## Key Abstractions
- Purpose: Represents a single curated awesome list (e.g., awesome-go, awesome-python)
- Examples: `api/src/awesome-lists/`, `web/src/app/[slug]/`
- Pattern: Each list has its own slug, categories, and items. Frontend generates one static page per list via dynamic route `[slug]`.
- Purpose: Represents a single repository entry within a category of an awesome list
- Examples: Linked to both a `Category` (logical grouping) and optionally a `Repo` (for star data)
- Pattern: Stores GitHub URL, item name, description. If `repoId` is set, inherits star counts from `Repo` table. If `repoId` is NULL, displays as "no GitHub data available".
- Purpose: Historical record of star count for a repository on a specific date
- Examples: One record per repo per day (unique constraint `[repoId, snapshotDate]`)
- Pattern: Upserted daily; used to compute trending deltas. Tolerance window allows 3-day drift in snapshot dates.
- Purpose: Derived metric (not stored) computed from snapshot deltas
- Periods: 7d, 30d, 90d
- Pattern: Query snapshots at date-N and date, divide (stars_now - stars_N), populate `Repo.stars7d/stars30d/stars90d` columns for fast querying
- Purpose: Centralize GitHub API interactions with rate limiting and error handling
- Examples: `fetchRepoStats(owner, repo)` (REST), `batchFetchStars(repos)` (GraphQL batch)
- Pattern: Uses Octokit with throttling plugin; returns typed results (e.g., `RepoStats`, `GraphQLRepoResult`)
## Entry Points
- Location: `api/src/main.ts`
- Triggers: `npm run start:prod` or `npm run start:dev` → NestFactory.create(AppModule) → listen on port 4000
- Responsibilities: Initialize NestJS app, enable CORS, set global validation pipes, serve Swagger docs at `/api/docs`
- Location: `web/src/app/layout.tsx` + `web/src/app/page.tsx` (homepage)
- Triggers: `BASE_PATH=/awesomer npm run build` → Next.js static export to `web/out/` → deployed to GitHub Pages
- Responsibilities: Render root layout (Header, Footer, main content), fetch trending lists + homepage cards
- Location: `api/src/sync/sync.service.ts` → `runDailySync()` decorated with `@Cron(CronExpression.EVERY_DAY_AT_2AM)`
- Triggers: Automatic at 2 AM UTC daily
- Responsibilities: Execute full 5-step pipeline, log progress, email alerts on failure (future enhancement)
- Location: `api/src/sync/sync.controller.ts` → `POST /api/sync/run` (admin only)
- Triggers: `curl -X POST http://localhost:4000/api/sync/run -H "Authorization: Bearer $ADMIN_API_KEY"`
- Responsibilities: Run pipeline with optional step selection, support for one-off syncs or step-by-step debugging
## Error Handling
- **Validation Errors:** `ValidationPipe` in `main.ts` catches DTO validation failures → returns 400 with field errors
- **Not Found:** Services throw `NotFoundException` (NestJS) for missing resources → controller returns 404
- **GitHub API failures:** `GithubService` returns `null` on 404 (deleted repos), logs warnings on timeouts, retries on rate limits (max 2 attempts)
- **Sync failures:** Caught in `runDailySync()` try-catch, error logged, pipeline continues to next step (fault-tolerant)
## Cross-Cutting Concerns
- Tool: `Logger` from `@nestjs/common`
- Pattern: Each service instantiates `private readonly logger = new Logger(ServiceName.name)` → calls `logger.log()`, `logger.warn()`, `logger.error()`
- Examples: Sync progress logged every 100 repos, GitHub API errors logged with HTTP status
- Tool: `class-validator` + `class-transformer` via NestJS `ValidationPipe`
- Pattern: DTOs decorated with `@IsString()`, `@IsNumber()`, `@Min()`, etc. → applied globally in `main.ts`
- Endpoints: Query params parsed and validated; invalid input rejected before reaching controller
- Strategy: Bearer token (admin API key) for sync endpoints
- Implementation: `SyncController.checkAdminKey()` validates `Authorization: Bearer ${ADMIN_API_KEY}` header
- Scope: Only sync operations require auth; read endpoints (lists, repos, trending) are public
- Pattern: Prisma's implicit transactions for single operations; explicit `prisma.$transaction([...])` for multi-step atomic operations (not yet implemented; see CONCERNS.md)
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd:quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd:debug` for investigation and bug fixing
- `/gsd:execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->

<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd:profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
