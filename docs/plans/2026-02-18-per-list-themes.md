# Per-List Themes Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Let each awesome list have its own color theme, with a "claude" terminal theme as the default, applied via CSS custom properties at the `[slug]` route level.

**Architecture:** Store a `theme` string column on `AwesomeList` (e.g. `"claude"`, `"pirate"`, `"ruby"`). The frontend defines a static registry of named themes (CSS variable maps). The `[slug]/layout.tsx` fetches the list's theme name and injects the corresponding CSS variables onto a wrapper `<div>`, overriding `:root` defaults. No database migration needed for theme definitions — themes are purely frontend code; the DB only stores which theme name a list uses.

**Tech Stack:** Prisma migration (add column), NestJS API (expose field), Next.js (CSS variables, `[slug]/layout.tsx`, theme registry)

---

### Task 1: Add `theme` column to AwesomeList (API)

**Files:**
- Modify: `api/prisma/schema.prisma` (AwesomeList model)
- Create: migration via `prisma migrate dev`

**Step 1: Add the column to the schema**

In `api/prisma/schema.prisma`, add this field to the `AwesomeList` model, after the `sortPreference` line:

```prisma
  theme             String    @default("claude")
```

**Step 2: Generate and apply the migration**

Run:
```bash
cd api && npx prisma migrate dev --name add_theme_to_awesome_lists
```

Expected: Migration created and applied. All existing rows get `theme = 'claude'`.

**Step 3: Regenerate Prisma client**

Run:
```bash
cd api && npx prisma generate
```

Expected: Client regenerated with the new `theme` field.

**Step 4: Verify API build**

Run:
```bash
cd api && npm run build
```

Expected: Clean compilation. The `theme` field is now available on all AwesomeList queries since the service uses `findMany`/`findUnique` without explicit `select` — so it's automatically included.

**Step 5: Commit**

```bash
git add api/prisma/schema.prisma api/prisma/migrations/
git commit -m "feat: add theme column to awesome_lists table"
```

---

### Task 2: Create the frontend theme registry

**Files:**
- Create: `web/src/lib/themes.ts`

**Step 1: Create the theme type and registry**

Create `web/src/lib/themes.ts` with all theme definitions. Each theme is a map of CSS custom property names to values. The `claude` theme matches the current globals.css `:root` values exactly.

```typescript
export interface Theme {
  '--background': string;
  '--foreground': string;
  '--accent': string;
  '--accent-hover': string;
  '--surface': string;
  '--surface-hover': string;
  '--border': string;
  '--muted': string;
  '--success': string;
  '--danger': string;
  '--warning': string;
  '--cyan': string;
  // Glow color for the .glow class (rgba string)
  '--glow-color': string;
  // Selection highlight (rgba string)
  '--selection-bg': string;
}

export const themes: Record<string, Theme> = {
  claude: {
    '--background': '#000000',
    '--foreground': '#b3b1ad',
    '--accent': '#00ff41',
    '--accent-hover': '#33ff66',
    '--surface': '#0a0a0a',
    '--surface-hover': '#111111',
    '--border': '#1a1a1a',
    '--muted': '#555555',
    '--success': '#00ff41',
    '--danger': '#ff3333',
    '--warning': '#ffb800',
    '--cyan': '#00d4ff',
    '--glow-color': 'rgba(0, 255, 65, 0.4)',
    '--selection-bg': 'rgba(0, 255, 65, 0.15)',
  },

  pirate: {
    '--background': '#0a0806',
    '--foreground': '#c9b99a',
    '--accent': '#d4a024',
    '--accent-hover': '#e8b84a',
    '--surface': '#12100a',
    '--surface-hover': '#1a1610',
    '--border': '#2a2418',
    '--muted': '#6b5d4a',
    '--success': '#5cb85c',
    '--danger': '#cc3333',
    '--warning': '#d4a024',
    '--cyan': '#5b9bd5',
    '--glow-color': 'rgba(212, 160, 36, 0.4)',
    '--selection-bg': 'rgba(212, 160, 36, 0.15)',
  },

  ruby: {
    '--background': '#0a0008',
    '--foreground': '#c4b5c9',
    '--accent': '#cc342d',
    '--accent-hover': '#e04840',
    '--surface': '#0f000a',
    '--surface-hover': '#180012',
    '--border': '#2a1025',
    '--muted': '#6b5066',
    '--success': '#5cb85c',
    '--danger': '#cc342d',
    '--warning': '#e8a02e',
    '--cyan': '#6bbfc0',
    '--glow-color': 'rgba(204, 52, 45, 0.4)',
    '--selection-bg': 'rgba(204, 52, 45, 0.15)',
  },

  docker: {
    '--background': '#030a12',
    '--foreground': '#b0c4de',
    '--accent': '#0db7ed',
    '--accent-hover': '#3dc9f6',
    '--surface': '#061018',
    '--surface-hover': '#0c1a28',
    '--border': '#142a3e',
    '--muted': '#4a6a8a',
    '--success': '#2ecc71',
    '--danger': '#e74c3c',
    '--warning': '#f1c40f',
    '--cyan': '#0db7ed',
    '--glow-color': 'rgba(13, 183, 237, 0.4)',
    '--selection-bg': 'rgba(13, 183, 237, 0.15)',
  },

  postgres: {
    '--background': '#03080e',
    '--foreground': '#aeb8c4',
    '--accent': '#336791',
    '--accent-hover': '#4a82ab',
    '--surface': '#060e18',
    '--surface-hover': '#0c1825',
    '--border': '#1a2a3d',
    '--muted': '#4a5a6a',
    '--success': '#2ecc71',
    '--danger': '#e74c3c',
    '--warning': '#f1c40f',
    '--cyan': '#5b9bd5',
    '--glow-color': 'rgba(51, 103, 145, 0.4)',
    '--selection-bg': 'rgba(51, 103, 145, 0.15)',
  },

  node: {
    '--background': '#020a02',
    '--foreground': '#a8c4a0',
    '--accent': '#68a063',
    '--accent-hover': '#8cc484',
    '--surface': '#061006',
    '--surface-hover': '#0c180c',
    '--border': '#1a2a1a',
    '--muted': '#4a6a48',
    '--success': '#68a063',
    '--danger': '#cc3333',
    '--warning': '#e8a02e',
    '--cyan': '#5bbfc0',
    '--glow-color': 'rgba(104, 160, 99, 0.4)',
    '--selection-bg': 'rgba(104, 160, 99, 0.15)',
  },

  mac: {
    '--background': '#08080a',
    '--foreground': '#b8b8c0',
    '--accent': '#007aff',
    '--accent-hover': '#3395ff',
    '--surface': '#0e0e12',
    '--surface-hover': '#16161c',
    '--border': '#222230',
    '--muted': '#555566',
    '--success': '#30d158',
    '--danger': '#ff453a',
    '--warning': '#ffd60a',
    '--cyan': '#64d2ff',
    '--glow-color': 'rgba(0, 122, 255, 0.4)',
    '--selection-bg': 'rgba(0, 122, 255, 0.15)',
  },

  zsh: {
    '--background': '#000000',
    '--foreground': '#a0d0a0',
    '--accent': '#98c379',
    '--accent-hover': '#b5d8a0',
    '--surface': '#080c08',
    '--surface-hover': '#101810',
    '--border': '#1a261a',
    '--muted': '#506850',
    '--success': '#98c379',
    '--danger': '#e06c75',
    '--warning': '#e5c07b',
    '--cyan': '#56b6c2',
    '--glow-color': 'rgba(152, 195, 121, 0.4)',
    '--selection-bg': 'rgba(152, 195, 121, 0.15)',
  },
};

/** Resolve a theme name to a Theme object. Falls back to 'claude'. */
export function getTheme(name: string | null | undefined): Theme {
  return themes[name ?? 'claude'] ?? themes.claude;
}

/** Convert a Theme to a CSSProperties-compatible inline style object. */
export function themeToStyle(theme: Theme): Record<string, string> {
  return { ...theme };
}
```

**Step 2: Verify no TypeScript errors**

Run:
```bash
cd web && npx tsc --noEmit
```

Expected: Clean — no errors.

**Step 3: Commit**

```bash
git add web/src/lib/themes.ts
git commit -m "feat: add frontend theme registry with 8 named themes"
```

---

### Task 3: Update globals.css to use CSS variables for glow and selection

**Files:**
- Modify: `web/src/app/globals.css`

**Step 1: Replace hardcoded rgba values with CSS variables**

The `.glow` class and `::selection` currently hardcode the green glow color. Change them to use CSS variables so per-list themes can override them.

In `web/src/app/globals.css`, add `--glow-color` and `--selection-bg` to the `:root` block:

```css
:root {
  --background: #000000;
  --foreground: #b3b1ad;
  --accent: #00ff41;
  --accent-hover: #33ff66;
  --surface: #0a0a0a;
  --surface-hover: #111111;
  --border: #1a1a1a;
  --muted: #555555;
  --success: #00ff41;
  --danger: #ff3333;
  --warning: #ffb800;
  --cyan: #00d4ff;
  --glow-color: rgba(0, 255, 65, 0.4);
  --selection-bg: rgba(0, 255, 65, 0.15);
}
```

Then update the `.glow` rule:

```css
.glow {
  text-shadow: 0 0 8px var(--glow-color);
}
```

And the `::selection` rule:

```css
::selection {
  background: var(--selection-bg);
  color: var(--accent);
}
```

**Step 2: Verify dev server renders correctly**

Run:
```bash
cd web && npm run dev
```

Open http://localhost:3000 — should look identical to before (since `:root` values haven't changed).

**Step 3: Commit**

```bash
git add web/src/app/globals.css
git commit -m "refactor: use CSS variables for glow and selection colors"
```

---

### Task 4: Update the AwesomeList TypeScript type in the frontend

**Files:**
- Modify: `web/src/lib/api.ts`

**Step 1: Add `theme` to the `AwesomeList` interface**

In `web/src/lib/api.ts`, add the `theme` field to `AwesomeList`:

```typescript
export interface AwesomeList {
  id: number;
  name: string;
  slug: string;
  description: string | null;
  githubRepo: string;
  state: string;
  lastSyncedAt: string | null;
  theme: string;              // <-- add this line
  _count?: {
    categories: number;
  };
}
```

**Step 2: Commit**

```bash
git add web/src/lib/api.ts
git commit -m "feat: add theme field to AwesomeList frontend type"
```

---

### Task 5: Create the `[slug]/layout.tsx` with theme injection

This is the core of the feature. The `[slug]/layout.tsx` wraps all pages under a vertical and applies that list's theme via inline CSS variables on a `<div>`.

**Files:**
- Create: `web/src/app/[slug]/layout.tsx`

**Step 1: Create the layout**

```typescript
import { getAwesomeLists, getAwesomeList } from '@/lib/api';
import { getTheme, themeToStyle } from '@/lib/themes';

export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
  return lists.map((list) => ({ slug: list.slug }));
}

export default async function SlugLayout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;

  let themeName = 'claude';
  try {
    const { data: list } = await getAwesomeList(slug);
    themeName = list.theme ?? 'claude';
  } catch {
    // List not found — default theme will be used
  }

  const theme = getTheme(themeName);

  return (
    <div style={themeToStyle(theme)}>
      {children}
    </div>
  );
}
```

**How it works:** CSS custom properties cascade. When a `<div style="--accent: #d4a024">` wraps child elements, all `var(--accent)` references inside resolve to the new value. The `:root` values act as the fallback for pages outside `[slug]/` (home, global trending, search).

**Step 2: Verify it builds**

Run:
```bash
cd web && npm run build
```

Expected: All static pages generate. Pages under `[slug]/` now wrap in a themed div.

**Step 3: Commit**

```bash
git add "web/src/app/[slug]/layout.tsx"
git commit -m "feat: add [slug] layout that injects per-list theme via CSS variables"
```

---

### Task 6: Set initial theme values in the database

**Files:**
- None (database update via SQL)

**Step 1: Set theme values for lists that have custom themes**

```bash
cd api && DATABASE_URL="postgresql://awesomer:awesomer@localhost:5433/awesomer_platform" node -e "
import pg from 'pg';
const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });

const themes = [
  ['awesome-piracy', 'pirate'],
  ['awesome-ruby', 'ruby'],
  ['awesome-docker', 'docker'],
  ['awesome-postgres', 'postgres'],
  ['awesome-nodejs', 'node'],
  ['awesome-mac', 'mac'],
  ['awesome-zsh-plugins', 'zsh'],
];

for (const [slug, theme] of themes) {
  const res = await pool.query(
    'UPDATE awesome_lists SET theme = \$1 WHERE slug = \$2 RETURNING slug, theme',
    [theme, slug]
  );
  if (res.rowCount > 0) console.log('Set', res.rows[0].slug, '->', res.rows[0].theme);
  else console.log('Not found:', slug);
}

await pool.end();
"
```

Expected: 7 lists updated with custom themes. All others remain `claude` (the column default).

**Step 2: Verify via API**

```bash
curl -s http://localhost:4000/api/awesome-lists | python3 -c "
import json, sys
for l in json.load(sys.stdin)['data']:
    print(f\"{l['slug']:30s} theme={l.get('theme', 'N/A')}\")"
```

Expected: Each list shows its theme name.

**Step 3: Rebuild the static site**

```bash
cd web && npm run build
```

Expected: All pages regenerate with per-list themes baked in.

**Step 4: No commit needed** — this is runtime data, not code.

---

### Task 7: Update star-chart.tsx to use CSS variables instead of hardcoded colors

The recharts `<Line stroke="#00ff41">` and tooltip styles are hardcoded. They need to read from CSS variables so they respect per-list themes.

**Files:**
- Modify: `web/src/app/[slug]/repos/[repoSlug]/star-chart.tsx`

**Step 1: Create a wrapper that reads CSS variables at render time**

Recharts doesn't support `var()` in props directly (they need actual hex values). Use a client-side hook to read the computed CSS variables.

```typescript
'use client';

import { useRef, useEffect, useState } from 'react';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';

interface StarChartProps {
  data: Array<{ snapshotDate: string; stars: number }>;
}

function useThemeColors() {
  const ref = useRef<HTMLDivElement>(null);
  const [colors, setColors] = useState({
    accent: '#00ff41',
    border: '#1a1a1a',
    muted: '#555555',
    surface: '#0a0a0a',
    foreground: '#b3b1ad',
  });

  useEffect(() => {
    if (!ref.current) return;
    const styles = getComputedStyle(ref.current);
    setColors({
      accent: styles.getPropertyValue('--accent').trim() || '#00ff41',
      border: styles.getPropertyValue('--border').trim() || '#1a1a1a',
      muted: styles.getPropertyValue('--muted').trim() || '#555555',
      surface: styles.getPropertyValue('--surface').trim() || '#0a0a0a',
      foreground: styles.getPropertyValue('--foreground').trim() || '#b3b1ad',
    });
  }, []);

  return { ref, colors };
}

export default function StarChart({ data }: StarChartProps) {
  const { ref, colors } = useThemeColors();

  if (data.length < 2) return null;

  return (
    <div className="mb-8" ref={ref}>
      <div className="text-muted text-sm mb-3">## star history</div>
      <div className="p-4 border border-border">
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke={colors.border} />
            <XAxis
              dataKey="snapshotDate"
              tick={{ fill: colors.muted, fontSize: 11 }}
              tickFormatter={(value: string) =>
                new Date(value).toLocaleDateString('en-US', {
                  month: 'short',
                  day: 'numeric',
                })
              }
            />
            <YAxis
              tick={{ fill: colors.muted, fontSize: 11 }}
              tickFormatter={(value: number) =>
                value >= 1000 ? `${(value / 1000).toFixed(1)}k` : String(value)
              }
            />
            <Tooltip
              contentStyle={{
                backgroundColor: colors.surface,
                border: `1px solid ${colors.border}`,
                borderRadius: '0',
                color: colors.foreground,
                fontFamily: 'monospace',
                fontSize: '12px',
              }}
              labelFormatter={(label) =>
                new Date(String(label)).toLocaleDateString()
              }
              formatter={(value) => [
                Number(value).toLocaleString(),
                'stars',
              ]}
            />
            <Line
              type="monotone"
              dataKey="stars"
              stroke={colors.accent}
              strokeWidth={2}
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
```

**Step 2: Verify chart renders correctly**

Open any repo detail page (e.g. http://localhost:3000/awesome-ruby/repos/rails-rails). The chart line should use the ruby red accent color.

**Step 3: Commit**

```bash
git add "web/src/app/[slug]/repos/[repoSlug]/star-chart.tsx"
git commit -m "feat: star chart reads theme colors from CSS variables"
```

---

### Task 8: Final verification and build

**Step 1: Restart the API** (to pick up the Prisma schema change)

```bash
# Kill existing API process, then:
cd api && npm run start:dev
```

**Step 2: Full static build**

```bash
cd web && npm run build
```

Expected: All 12,000+ pages build without errors.

**Step 3: Spot-check themes**

Serve the static site and verify in browser:

```bash
cd web && python3 -m http.server 3000 --directory out
```

- http://localhost:3000/ — Green claude theme (home, no slug layout)
- http://localhost:3000/awesome-claude-code/ — Green claude theme
- http://localhost:3000/awesome-piracy/ — Gold/amber pirate theme
- http://localhost:3000/awesome-ruby/ — Red ruby theme
- http://localhost:3000/awesome-docker/ — Blue docker theme
- http://localhost:3000/awesome-postgres/ — Steel blue postgres theme
- http://localhost:3000/awesome-nodejs/ — Green node theme
- http://localhost:3000/awesome-mac/ — Apple blue mac theme
- http://localhost:3000/awesome-zsh-plugins/ — Muted green zsh theme
- http://localhost:3000/trending/ — Green claude theme (global, no slug)

**Step 4: Final commit**

```bash
git add -A
git commit -m "feat: per-list theme system — each vertical gets its own color scheme"
```

---

## Summary

| Task | What | Files |
|------|------|-------|
| 1 | Add `theme` column to DB | `schema.prisma`, migration |
| 2 | Create theme registry | `web/src/lib/themes.ts` |
| 3 | CSS variables for glow/selection | `web/src/app/globals.css` |
| 4 | Add `theme` to TS type | `web/src/lib/api.ts` |
| 5 | `[slug]/layout.tsx` with theme injection | `web/src/app/[slug]/layout.tsx` |
| 6 | Set theme values in DB | SQL update (no code) |
| 7 | Theme-aware star chart | `star-chart.tsx` |
| 8 | Final build + verify | N/A |

**Adding a new theme later:** Add an entry to `themes` in `web/src/lib/themes.ts`, then `UPDATE awesome_lists SET theme = 'newtheme' WHERE slug = 'awesome-whatever'`.
