# Static Site Generation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Convert the Next.js frontend from a live SSR app that queries the NestJS API on every request to a fully static site that's rebuilt after each daily sync.

**Architecture:** Switch Next.js from `output: 'standalone'` to `output: 'export'`. Pre-render all pages at build time by adding `generateStaticParams()` to dynamic routes. Replace client-side API calls with server-side data fetching in async Server Components. For interactive features (search, newsletter), keep client-side API calls directly to the NestJS API. After daily sync, NestJS triggers `next build` to regenerate the static site. Caddy/nginx serves the `out/` directory.

**Tech Stack:** Next.js 16 static export, existing NestJS API (headless backend), Fuse.js for client-side search (replaces API search)

**Key constraints:**
- 17 non-archived awesome lists (17 vertical pages + 17 repos pages + 17 featured + 17 newsletter)
- ~12,800 unique repo slugs (repo detail pages)
- `output: 'export'` does NOT support: `next/image` optimization, rewrites/redirects in next.config, Server Actions, middleware
- Client Components with `useEffect` still work — they just fetch data client-side after hydration
- The NestJS API stays running for: newsletter POST, sync admin endpoints, and as the data source during `next build`

---

## Task 1: Add a Static Data Export Endpoint to NestJS

The static build needs all data available at build time. Rather than calling many individual API endpoints during build, add a single bulk-export endpoint that returns everything the frontend needs in one shot. This avoids N+1 API calls during `next build` and makes the build fast.

**Files:**
- Create: `api/src/sync/static-data.service.ts`
- Modify: `api/src/sync/sync.module.ts`
- Modify: `api/src/sync/sync.controller.ts`

**Step 1: Create the static data service**

```typescript
// api/src/sync/static-data.service.ts
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

export interface StaticListData {
  slug: string;
  name: string;
  description: string | null;
  githubRepo: string;
  categoryCount: number;
  categories: Array<{
    id: number;
    name: string;
    slug: string;
    itemCount: number;
  }>;
  trending7d: StaticTrendingRepo[];
  trending30d: StaticTrendingRepo[];
  trending90d: StaticTrendingRepo[];
}

export interface StaticTrendingRepo {
  githubRepo: string;
  description: string | null;
  stars: number | null;
  stars7d: number | null;
  stars30d: number | null;
  stars90d: number | null;
  lastCommitAt: string | null;
  categoryName: string | null;
  listSlug: string | null;
}

export interface StaticRepoPage {
  githubRepo: string;
  description: string | null;
  stars: number | null;
  stars7d: number | null;
  stars30d: number | null;
  stars90d: number | null;
  lastCommitAt: string | null;
  starHistory: Array<{ snapshotDate: string; stars: number }>;
  foundIn: Array<{
    categoryName: string;
    categorySlug: string;
    listName: string;
    listSlug: string;
  }>;
}

@Injectable()
export class StaticDataService {
  constructor(private readonly prisma: PrismaService) {}

  async exportAllLists(): Promise<StaticListData[]> {
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      orderBy: { name: 'asc' },
      include: {
        categories: {
          orderBy: { name: 'asc' },
          include: { _count: { select: { categoryItems: true } } },
        },
      },
    });

    const result: StaticListData[] = [];

    for (const list of lists) {
      const [t7, t30, t90] = await Promise.all([
        this.getTrendingForList(list.id, 'stars7d', 10),
        this.getTrendingForList(list.id, 'stars30d', 10),
        this.getTrendingForList(list.id, 'stars90d', 10),
      ]);

      result.push({
        slug: list.slug!,
        name: list.name,
        description: list.description,
        githubRepo: list.githubRepo,
        categoryCount: list.categories.length,
        categories: list.categories.map((c) => ({
          id: c.id,
          name: c.name,
          slug: c.slug!,
          itemCount: c._count.categoryItems,
        })),
        trending7d: t7,
        trending30d: t30,
        trending90d: t90,
      });
    }

    return result;
  }

  async exportReposForList(
    listSlug: string,
    params: { sort?: string; category?: string; page?: number; perPage?: number },
  ) {
    // Reuse the existing repos service logic — this endpoint is kept
    // for client-side pagination/filtering on the repos page
  }

  async exportGlobalTrending(): Promise<{
    '7d': StaticTrendingRepo[];
    '30d': StaticTrendingRepo[];
    '90d': StaticTrendingRepo[];
  }> {
    const [t7, t30, t90] = await Promise.all([
      this.getGlobalTrending('stars7d', 25),
      this.getGlobalTrending('stars30d', 25),
      this.getGlobalTrending('stars90d', 25),
    ]);
    return { '7d': t7, '30d': t30, '90d': t90 };
  }

  async exportRepoSlugs(): Promise<Array<{ listSlug: string; repoSlug: string }>> {
    const items = await this.prisma.categoryItem.findMany({
      where: { githubRepo: { not: null } },
      select: {
        githubRepo: true,
        category: {
          select: {
            awesomeList: { select: { slug: true } },
          },
        },
      },
      distinct: ['githubRepo'],
    });

    return items
      .filter((i) => i.category.awesomeList.slug)
      .map((i) => ({
        listSlug: i.category.awesomeList.slug!,
        repoSlug: i.githubRepo!.replace('/', '-'),
      }));
  }

  async exportRepoDetail(owner: string, name: string): Promise<StaticRepoPage | null> {
    const githubRepo = `${owner}/${name}`;
    const repo = await this.prisma.repo.findUnique({
      where: { githubRepo },
      include: {
        starSnapshots: {
          orderBy: { snapshotDate: 'asc' },
          select: { snapshotDate: true, stars: true },
        },
        categoryItems: {
          include: {
            category: {
              include: {
                awesomeList: { select: { name: true, slug: true } },
              },
            },
          },
        },
      },
    });

    if (!repo) return null;

    return {
      githubRepo: repo.githubRepo,
      description: repo.description,
      stars: repo.stars,
      stars7d: repo.stars7d,
      stars30d: repo.stars30d,
      stars90d: repo.stars90d,
      lastCommitAt: repo.lastCommitAt?.toISOString() ?? null,
      starHistory: repo.starSnapshots.map((s) => ({
        snapshotDate: s.snapshotDate.toISOString().split('T')[0],
        stars: s.stars,
      })),
      foundIn: repo.categoryItems.map((ci) => ({
        categoryName: ci.category.name,
        categorySlug: ci.category.slug!,
        listName: ci.category.awesomeList.name,
        listSlug: ci.category.awesomeList.slug!,
      })),
    };
  }

  private async getTrendingForList(
    listId: number,
    column: 'stars7d' | 'stars30d' | 'stars90d',
    limit: number,
  ): Promise<StaticTrendingRepo[]> {
    const repos = await this.prisma.repo.findMany({
      where: {
        [column]: { gt: 0 },
        categoryItems: {
          some: { category: { awesomeListId: listId } },
        },
      },
      orderBy: { [column]: 'desc' },
      take: limit,
      include: {
        categoryItems: {
          take: 1,
          include: {
            category: {
              include: { awesomeList: { select: { slug: true } } },
            },
          },
        },
      },
    });

    return repos.map((r) => ({
      githubRepo: r.githubRepo,
      description: r.description,
      stars: r.stars,
      stars7d: r.stars7d,
      stars30d: r.stars30d,
      stars90d: r.stars90d,
      lastCommitAt: r.lastCommitAt?.toISOString() ?? null,
      categoryName: r.categoryItems[0]?.category.name ?? null,
      listSlug: r.categoryItems[0]?.category.awesomeList.slug ?? null,
    }));
  }

  private async getGlobalTrending(
    column: 'stars7d' | 'stars30d' | 'stars90d',
    limit: number,
  ): Promise<StaticTrendingRepo[]> {
    const repos = await this.prisma.repo.findMany({
      where: { [column]: { gt: 0 } },
      orderBy: { [column]: 'desc' },
      take: limit,
      include: {
        categoryItems: {
          take: 1,
          include: {
            category: {
              include: { awesomeList: { select: { slug: true } } },
            },
          },
        },
      },
    });

    return repos.map((r) => ({
      githubRepo: r.githubRepo,
      description: r.description,
      stars: r.stars,
      stars7d: r.stars7d,
      stars30d: r.stars30d,
      stars90d: r.stars90d,
      lastCommitAt: r.lastCommitAt?.toISOString() ?? null,
      categoryName: r.categoryItems[0]?.category.name ?? null,
      listSlug: r.categoryItems[0]?.category.awesomeList.slug ?? null,
    }));
  }
}
```

**Step 2: Register the service in sync module**

Add `StaticDataService` to `providers` and `exports` in `api/src/sync/sync.module.ts`.

**Step 3: Add the export endpoints to the sync controller**

Add to `api/src/sync/sync.controller.ts`:

```typescript
import { Get, Query } from '@nestjs/common';
import { StaticDataService } from './static-data.service.js';

// In constructor: private readonly staticData: StaticDataService

@Get('static/lists')
@ApiOperation({ summary: 'Export all list data for static build' })
async exportLists() {
  const data = await this.staticData.exportAllLists();
  return { data };
}

@Get('static/trending')
@ApiOperation({ summary: 'Export global trending for static build' })
async exportTrending() {
  const data = await this.staticData.exportGlobalTrending();
  return { data };
}

@Get('static/repo-slugs')
@ApiOperation({ summary: 'Export all repo slugs for generateStaticParams' })
async exportRepoSlugs() {
  const data = await this.staticData.exportRepoSlugs();
  return { data };
}

@Get('static/repo/:owner/:name')
@ApiOperation({ summary: 'Export single repo detail for static build' })
async exportRepoDetail(
  @Param('owner') owner: string,
  @Param('name') name: string,
) {
  const data = await this.staticData.exportRepoDetail(owner, name);
  if (!data) throw new NotFoundException();
  return { data };
}
```

**Step 4: Build and verify**

```bash
cd api && npm run build
# Restart API, then test:
curl -s http://localhost:4000/api/sync/static/lists | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Lists: {len(d[\"data\"])}')"
curl -s http://localhost:4000/api/sync/static/trending | python3 -c "import sys,json; d=json.load(sys.stdin); print(list(d['data'].keys()))"
curl -s http://localhost:4000/api/sync/static/repo-slugs | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Repo slugs: {len(d[\"data\"])}')"
curl -s http://localhost:4000/api/sync/static/repo/obra/superpowers | python3 -c "import sys,json; d=json.load(sys.stdin)['data']; print(f'{d[\"githubRepo\"]}: {d[\"stars\"]} stars, {len(d[\"starHistory\"])} snapshots')"
```

**Step 5: Commit**

```bash
git add api/src/sync/static-data.service.ts api/src/sync/sync.module.ts api/src/sync/sync.controller.ts
git commit -m "feat: add static data export endpoints for SSG build"
```

---

## Task 2: Switch Next.js to Static Export

Change the Next.js config and fix incompatibilities with `output: 'export'`.

**Files:**
- Modify: `web/next.config.ts`
- Modify: `web/package.json`

**Step 1: Update next.config.ts**

```typescript
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  output: 'export',
  images: {
    unoptimized: true, // required for static export — no image optimization server
  },
  trailingSlash: true, // generates /slug/index.html for clean URLs with static hosting
};

export default nextConfig;
```

**Step 2: Add a build:static script to package.json**

In `web/package.json` scripts, add:

```json
"build:static": "next build"
```

The `output: 'export'` setting makes `next build` produce `out/` automatically.

**Step 3: Try building to see what breaks**

```bash
cd web && npm run build 2>&1 | head -50
```

This will fail because some pages use dynamic features. That's expected — we'll fix each page in the following tasks.

**Step 4: Commit the config change**

```bash
git add web/next.config.ts web/package.json
git commit -m "feat: switch Next.js to static export mode"
```

---

## Task 3: Convert Home Page to Static

The home page is already a Server Component that fetches `getAwesomeLists()`. For static export, this fetch happens at build time. No changes needed to the data fetching — just ensure the API is running during build.

**Files:**
- Modify: `web/src/app/page.tsx` (minor — add revalidate or confirm it works as-is)

**Step 1: Verify the home page builds statically**

The home page is `async function Home()` calling `getAwesomeLists()`. With static export, this runs at build time. No changes should be needed.

Run `cd web && npm run build 2>&1 | grep "page.tsx"` and check if the home page compiles.

If it fails because `fetch()` can't reach the API, ensure:
- The API is running on port 4000
- `NEXT_PUBLIC_API_URL` is set (or defaults to `http://localhost:4000/api`)

**Step 2: Commit if changes needed**

---

## Task 4: Convert Vertical Page to Static with generateStaticParams

The vertical page (`/[slug]`) is a Server Component but uses a dynamic route. For static export, it needs `generateStaticParams()` to tell Next.js which slugs to pre-render.

**Files:**
- Modify: `web/src/app/[slug]/page.tsx`
- Modify: `web/src/lib/api.ts` (add helper if needed)

**Step 1: Add generateStaticParams**

Add to the top of `web/src/app/[slug]/page.tsx`:

```typescript
export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
  return lists.map((list) => ({ slug: list.slug }));
}
```

**Step 2: Build and verify**

```bash
cd web && npm run build 2>&1 | grep -E "\[slug\]|error"
```

Expected: The vertical pages build for each slug (17 pages).

**Step 3: Commit**

```bash
git add web/src/app/[slug]/page.tsx
git commit -m "feat: add generateStaticParams to vertical page"
```

---

## Task 5: Convert Repos List Page to Static Shell + Client Fetch

The repos page (`/[slug]/repos`) is a Client Component with sorting, search, category filter, and pagination — all interactive. Strategy: render a static shell that loads data client-side on mount (keep as `'use client'`), but add `generateStaticParams` so the route exists.

**Files:**
- Create: `web/src/app/[slug]/repos/layout.tsx` (or add generateStaticParams to page)

**Step 1: Add generateStaticParams**

Since this page is `'use client'`, we can't add `generateStaticParams` directly to it. Instead, create a wrapper layout or convert to a server component shell:

Create `web/src/app/[slug]/repos/page.tsx` as a thin server wrapper that renders the client component:

Actually — `'use client'` pages CAN have a sibling `generateStaticParams` if exported separately. In Next.js 14+, you export `generateStaticParams` from a `'use client'` page file and it still works. The function runs at build time on the server.

Add to `web/src/app/[slug]/repos/page.tsx` (at the bottom, outside the component):

```typescript
export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
  return lists.map((list) => ({ slug: list.slug }));
}
```

Note: The `getAwesomeLists` import needs to be at the top of the file. Since the page is `'use client'`, the import runs on both client and server — `generateStaticParams` only runs server-side during build.

**However**, `'use client'` files cannot export `generateStaticParams` in static export mode. The fix: split into a Server Component wrapper.

Create a new structure:
- `web/src/app/[slug]/repos/page.tsx` — Server Component (async, has generateStaticParams)
- `web/src/app/[slug]/repos/repos-client.tsx` — Client Component (the current page content)

Rename current `page.tsx` to `repos-client.tsx`, remove `generateStaticParams`. Create new `page.tsx`:

```typescript
// web/src/app/[slug]/repos/page.tsx
import { getAwesomeLists } from '@/lib/api';
import ReposClient from './repos-client';

export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
  return lists.map((list) => ({ slug: list.slug }));
}

export default async function ReposPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  return <ReposClient slug={slug} />;
}
```

Update `repos-client.tsx` to accept `slug` as a prop instead of reading from `useParams()`.

**Step 2: Build and verify**

```bash
cd web && npm run build 2>&1 | grep -E "repos|error"
```

**Step 3: Commit**

```bash
git add web/src/app/[slug]/repos/
git commit -m "feat: static shell for repos page with client-side data loading"
```

---

## Task 6: Convert Repo Detail Page to Static

The repo detail page (`/[slug]/repos/[repoSlug]`) is the biggest challenge — ~12,800 unique repos. Strategy: pre-render the top repos (by stars) at build time, and use a fallback for the rest.

**However**, `output: 'export'` does NOT support fallback/ISR. All pages must be enumerated in `generateStaticParams`. With 12,800 repos this is feasible — it'll just take longer to build.

**Files:**
- Modify: `web/src/app/[slug]/repos/[repoSlug]/page.tsx` — convert from client to server component
- Create: `web/src/app/[slug]/repos/[repoSlug]/star-chart.tsx` — client component for recharts

**Step 1: Extract the recharts chart into a client component**

```typescript
// web/src/app/[slug]/repos/[repoSlug]/star-chart.tsx
'use client';

import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
} from 'recharts';

interface StarChartProps {
  data: Array<{ snapshotDate: string; stars: number }>;
}

export default function StarChart({ data }: StarChartProps) {
  if (data.length < 2) return null;

  return (
    <div className="bg-surface rounded-lg border border-border p-6">
      <h2 className="text-xl font-semibold mb-4">Star History</h2>
      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={data}>
          <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
          <XAxis
            dataKey="snapshotDate"
            stroke="#9CA3AF"
            tick={{ fill: '#9CA3AF', fontSize: 12 }}
            tickFormatter={(v) => new Date(v).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
          />
          <YAxis
            stroke="#9CA3AF"
            tick={{ fill: '#9CA3AF', fontSize: 12 }}
            tickFormatter={(v) => v >= 1000 ? `${(v / 1000).toFixed(1)}k` : String(v)}
          />
          <Tooltip
            contentStyle={{ backgroundColor: '#1F2937', border: '1px solid #374151', borderRadius: '8px' }}
            labelStyle={{ color: '#9CA3AF' }}
            labelFormatter={(label) => String(label)}
            formatter={(value: number) => [value.toLocaleString(), 'Stars']}
          />
          <Line type="monotone" dataKey="stars" stroke="#8B5CF6" strokeWidth={2} dot={false} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
```

**Step 2: Rewrite the page as a Server Component**

Convert `web/src/app/[slug]/repos/[repoSlug]/page.tsx` from `'use client'` to a Server Component that calls the static data export API at build time:

```typescript
// web/src/app/[slug]/repos/[repoSlug]/page.tsx
import Link from 'next/link';
import { notFound } from 'next/navigation';
import StarChart from './star-chart';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000/api';

export async function generateStaticParams() {
  const res = await fetch(`${API_BASE}/sync/static/repo-slugs`);
  const { data } = await res.json();
  return data.map((r: { listSlug: string; repoSlug: string }) => ({
    slug: r.listSlug,
    repoSlug: r.repoSlug,
  }));
}

async function getRepoData(repoSlug: string) {
  const [owner, name] = repoSlug.split('-', 2);
  // Handle repos where owner or name contains dashes — use the first dash as separator
  // Actually, repoSlug is "owner-name" where / was replaced with -
  // Need a more robust approach: try the API with different split points
  const dashIndex = repoSlug.indexOf('-');
  if (dashIndex === -1) return null;
  const ownerPart = repoSlug.substring(0, dashIndex);
  const namePart = repoSlug.substring(dashIndex + 1);

  const res = await fetch(`${API_BASE}/sync/static/repo/${ownerPart}/${namePart}`);
  if (!res.ok) return null;
  const { data } = await res.json();
  return data;
}

export default async function RepoDetailPage({
  params,
}: {
  params: Promise<{ slug: string; repoSlug: string }>;
}) {
  const { slug, repoSlug } = await params;
  const repo = await getRepoData(repoSlug);

  if (!repo) return notFound();

  const formatDelta = (val: number | null) => {
    if (!val) return '—';
    return val > 0 ? `+${val.toLocaleString()}` : val.toLocaleString();
  };

  const formatDate = (d: string | null) => {
    if (!d) return '—';
    return new Date(d).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
  };

  return (
    <div className="max-w-5xl mx-auto">
      {/* Breadcrumb */}
      <nav className="flex items-center gap-2 text-sm text-muted mb-6">
        <Link href={`/${slug}`} className="hover:text-accent">{slug}</Link>
        <span>/</span>
        <Link href={`/${slug}/repos`} className="hover:text-accent">repos</Link>
        <span>/</span>
        <span className="text-foreground">{repo.githubRepo}</span>
      </nav>

      {/* Header */}
      <div className="mb-8">
        <div className="flex items-start justify-between gap-4">
          <div>
            <h1 className="text-3xl font-bold mb-2">{repo.githubRepo.split('/')[1]}</h1>
            <p className="text-muted">{repo.description}</p>
          </div>
          <a
            href={`https://github.com/${repo.githubRepo}`}
            target="_blank"
            rel="noopener noreferrer"
            className="shrink-0 px-4 py-2 bg-surface border border-border rounded-lg hover:border-accent transition-colors"
          >
            View on GitHub
          </a>
        </div>
        {repo.lastCommitAt && (
          <p className="text-sm text-muted mt-2">Last commit: {formatDate(repo.lastCommitAt)}</p>
        )}
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        {[
          { label: 'Stars', value: repo.stars?.toLocaleString() ?? '—' },
          { label: '7-day', value: formatDelta(repo.stars7d), color: repo.stars7d && repo.stars7d > 0 },
          { label: '30-day', value: formatDelta(repo.stars30d), color: repo.stars30d && repo.stars30d > 0 },
          { label: '90-day', value: formatDelta(repo.stars90d), color: repo.stars90d && repo.stars90d > 0 },
        ].map((stat) => (
          <div key={stat.label} className="bg-surface rounded-lg border border-border p-4 text-center">
            <div className="text-sm text-muted mb-1">{stat.label}</div>
            <div className={`text-2xl font-bold ${stat.color ? 'text-success' : ''}`}>{stat.value}</div>
          </div>
        ))}
      </div>

      {/* Star History Chart (client component) */}
      <StarChart data={repo.starHistory} />

      {/* Found In */}
      {repo.foundIn.length > 0 && (
        <div className="mt-8">
          <h2 className="text-xl font-semibold mb-4">Found in</h2>
          <div className="flex flex-wrap gap-2">
            {repo.foundIn.map((f: { listSlug: string; listName: string; categoryName: string }, i: number) => (
              <Link
                key={i}
                href={`/${f.listSlug}`}
                className="px-3 py-1 bg-surface border border-border rounded-full text-sm hover:border-accent transition-colors"
              >
                {f.listName} / {f.categoryName}
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
```

**Step 3: Build and verify**

```bash
cd web && npm run build 2>&1 | tail -20
```

This will pre-render all ~12,800 repo pages. May take a few minutes.

**Step 4: Commit**

```bash
git add web/src/app/[slug]/repos/[repoSlug]/
git commit -m "feat: static generation for repo detail pages with star chart"
```

---

## Task 7: Convert Trending Page to Static

The global trending page (`/trending`) is currently a client component with a period toggle. For static export, pre-render all 3 periods of data into the page and toggle client-side (no API calls needed).

**Files:**
- Modify: `web/src/app/trending/page.tsx` — server wrapper + client component

**Step 1: Split into server + client**

```typescript
// web/src/app/trending/page.tsx
import { getTrending } from '@/lib/api';
import TrendingClient from './trending-client';

export default async function TrendingPage() {
  const [t7, t30, t90] = await Promise.all([
    getTrending({ period: '7d', limit: 25 }).then((r) => r.data).catch(() => []),
    getTrending({ period: '30d', limit: 25 }).then((r) => r.data).catch(() => []),
    getTrending({ period: '90d', limit: 25 }).then((r) => r.data).catch(() => []),
  ]);

  return <TrendingClient data7d={t7} data30d={t30} data90d={t90} />;
}
```

```typescript
// web/src/app/trending/trending-client.tsx
'use client';

import { useState } from 'react';
import TrendingTable from '@/components/trending-table';
import type { Repo } from '@/lib/api';

interface Props {
  data7d: Repo[];
  data30d: Repo[];
  data90d: Repo[];
}

export default function TrendingClient({ data7d, data30d, data90d }: Props) {
  const [period, setPeriod] = useState<'7d' | '30d' | '90d'>('7d');

  const data = { '7d': data7d, '30d': data30d, '90d': data90d };

  return (
    <div className="max-w-5xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Global Trending</h1>
      <div className="flex gap-2 mb-6">
        {(['7d', '30d', '90d'] as const).map((p) => (
          <button
            key={p}
            onClick={() => setPeriod(p)}
            className={`px-4 py-2 rounded-lg border transition-colors ${
              period === p
                ? 'bg-accent text-white border-accent'
                : 'bg-surface border-border hover:border-accent'
            }`}
          >
            {p}
          </button>
        ))}
      </div>
      <TrendingTable title={`Top Trending (${period})`} repos={data[period]} period={period} />
    </div>
  );
}
```

**Step 2: Build and verify**

**Step 3: Commit**

```bash
git add web/src/app/trending/
git commit -m "feat: static trending page with client-side period toggle"
```

---

## Task 8: Convert Featured + Newsletter Pages

**Featured page** (`/[slug]/featured`) — already a Server Component, just needs `generateStaticParams`.

**Newsletter page** (`/[slug]/newsletter`) — client component for the form. Needs server wrapper for `generateStaticParams`. The POST to subscribe still calls the live API.

**Files:**
- Modify: `web/src/app/[slug]/featured/page.tsx`
- Modify: `web/src/app/[slug]/newsletter/page.tsx`
- Create: `web/src/app/[slug]/newsletter/newsletter-client.tsx`

**Step 1: Add generateStaticParams to featured page**

```typescript
export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
  return lists.map((list) => ({ slug: list.slug }));
}
```

**Step 2: Split newsletter into server + client**

Same pattern as Task 5: server component with `generateStaticParams`, client component for the form.

**Step 3: Build and verify**

**Step 4: Commit**

```bash
git add web/src/app/[slug]/featured/ web/src/app/[slug]/newsletter/
git commit -m "feat: static featured and newsletter pages"
```

---

## Task 9: Handle Search Page

The search page is purely interactive — user types a query, results come back. Two options:

**Option A (simpler):** Keep the search page as a client component that calls the live NestJS API. Users who search need the API running. Since the API is already running for sync/newsletter anyway, this is pragmatic.

**Option B (fully static):** Pre-build a search index JSON file, bundle Fuse.js, search client-side. More work but removes API dependency for searching.

**Recommended: Option A for now.** The search page is already `'use client'` and doesn't need `generateStaticParams` since it's at `/search` (no dynamic segments). It should build as-is with static export.

**Files:**
- Verify: `web/src/app/search/page.tsx` builds without changes

**Step 1: Build and verify the search page works**

```bash
cd web && npm run build 2>&1 | grep -i search
```

If it fails, it's likely because of `useSearchParams()` — static export may require a `Suspense` boundary (which already exists in the code).

**Step 2: Commit if changes needed**

---

## Task 10: Add Static Build Trigger to Sync Pipeline

After the daily sync completes, automatically rebuild the static site.

**Files:**
- Modify: `api/src/sync/sync.service.ts`

**Step 1: Add a `rebuildStaticSite()` method**

```typescript
private async rebuildStaticSite() {
  this.logger.log('Step 6: Rebuilding static site...');
  const { execSync } = await import('child_process');
  const path = await import('path');
  const webDir = path.resolve(process.cwd(), '..', 'web');
  try {
    execSync('npm run build', {
      cwd: webDir,
      stdio: 'inherit',
      timeout: 600_000, // 10 min timeout
      env: { ...process.env, NEXT_PUBLIC_API_URL: `http://localhost:${process.env.PORT ?? 4000}/api` },
    });
    this.logger.log('Static site rebuilt successfully');
  } catch (error) {
    this.logger.error('Static site build failed', error);
  }
}
```

**Step 2: Call it at the end of `runDailySync()`**

After the existing step 5 (markdown generation), add:

```typescript
await this.rebuildStaticSite();
```

**Step 3: Also add a standalone endpoint**

In `sync.controller.ts`:

```typescript
@Post('rebuild')
@ApiOperation({ summary: 'Rebuild static site (admin only)' })
async rebuildSite(@Headers('authorization') auth?: string) {
  this.checkAdminKey(auth);
  // Run async
  void this.syncService.rebuildStaticSite();
  return { message: 'Static site rebuild started' };
}
```

Make `rebuildStaticSite()` public in the service.

**Step 4: Build and test**

```bash
curl -X POST http://localhost:4000/api/sync/rebuild -H "Authorization: Bearer $ADMIN_API_KEY"
# Check that web/out/ is generated
ls web/out/
```

**Step 5: Commit**

```bash
git add api/src/sync/sync.service.ts api/src/sync/sync.controller.ts
git commit -m "feat: trigger static site rebuild after daily sync"
```

---

## Task 11: Configure Static File Serving

The `web/out/` directory contains the generated static site. Configure a simple server to serve it.

**Files:**
- Modify: `docker-compose.platform.yml` (add Caddy or nginx for static serving)

**Step 1: Add a static file server to docker-compose**

```yaml
  caddy:
    image: caddy:2-alpine
    ports:
      - "3000:80"
    volumes:
      - ./web/out:/srv:ro
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
    restart: unless-stopped
```

**Step 2: Create Caddyfile**

```
:80 {
    root * /srv
    file_server
    try_files {path} {path}/index.html /404.html

    # Proxy newsletter and search API calls to NestJS
    handle /api/* {
        reverse_proxy api:4000
    }
}
```

**Step 3: Commit**

```bash
git add docker-compose.platform.yml Caddyfile
git commit -m "feat: add Caddy for static site serving"
```

---

## Task 12: Full End-to-End Test

**Step 1: Build the static site**

```bash
# Ensure API is running
cd web && npm run build
ls out/
```

**Step 2: Serve and verify**

```bash
npx serve out/ -l 3001
# Open http://localhost:3001 in browser
# Verify: home page, vertical pages, repo detail pages, trending, search
```

**Step 3: Verify search and newsletter work**

- Search: requires API running on port 4000
- Newsletter subscribe: requires API running on port 4000

**Step 4: Check file sizes**

```bash
du -sh web/out/
find web/out -name "*.html" | wc -l
```

**Step 5: Commit everything and update CLAUDE.md**

Add to CLAUDE.md:

```markdown
### Static Site
```bash
cd web && npm run build    # generates out/ directory
npx serve out/             # serve locally for testing
```

The daily sync pipeline automatically rebuilds the static site after completing.
```

**Step 6: Final commit**

```bash
git add -A
git commit -m "docs: update CLAUDE.md with static site build instructions"
```
