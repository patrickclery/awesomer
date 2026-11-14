/**
 * Client-side global search over the static search-index.json.
 * Twin: api/src/sync/static-data.service.ts (StaticSearchIndex) — change both together.
 *
 * Erasable TypeScript only and no imports: web/src/lib/search.test.mjs imports this file
 * directly under node's type stripping.
 */

/** Root-relative path of the index; pass through siteAsset() for the deployed URL. */
export const SEARCH_INDEX_PATH = '/search-index.json';

export type SearchIndexRepo = [
  githubRepo: string,
  name: string | null,
  description: string | null,
  stars: number | null,
  stars7d: number | null,
  stars30d: number | null,
  cats: number[],
];

export interface SearchIndex {
  v: 1;
  lists: Array<[slug: string, name: string]>;
  cats: Array<[listIdx: number, name: string, slug: string]>;
  repos: SearchIndexRepo[];
}

export interface SearchMembership {
  listSlug: string;
  listName: string;
  categoryName: string;
  categorySlug: string;
}

export interface SearchHit {
  githubRepo: string;
  name: string | null;
  stars: number | null;
  stars7d: number | null;
  stars30d: number | null;
  memberships: SearchMembership[];
}

interface Prepared {
  haystack: string;
  repo: string;
  seg: string;
  name: string;
}

const prepared = new WeakMap<SearchIndex, Prepared[]>();

function prepare(index: SearchIndex): Prepared[] {
  let rows = prepared.get(index);
  if (!rows) {
    rows = index.repos.map(([githubRepo, name, description]) => {
      const repo = githubRepo.toLowerCase();
      const lname = (name ?? '').toLowerCase();
      return {
        haystack: [repo, lname, (description ?? '').toLowerCase()].join(' '),
        repo,
        seg: repo.slice(repo.indexOf('/') + 1),
        name: lname,
      };
    });
    prepared.set(index, rows);
  }
  return rows;
}

function tier(row: Prepared, q: string): number {
  if (row.seg === q || row.name === q) return 0;
  if (row.seg.startsWith(q) || (row.name !== '' && row.name.startsWith(q))) return 1;
  if (row.repo.includes(q) || row.name.includes(q)) return 2;
  return 3;
}

function descNullLast(a: number | null, b: number | null): number {
  if (a === b) return 0;
  if (a === null) return 1;
  if (b === null) return -1;
  return b - a;
}

/** Filters the index to repos containing every query token, ranked by match tier then stars. */
export function searchRepos(index: SearchIndex, query: string): SearchHit[] {
  const q = query.trim().toLowerCase().replace(/\s+/g, ' ');
  if (!q) return [];
  const tokens = q.split(' ');
  const rows = prepare(index);

  const matches: Array<{ i: number; tier: number }> = [];
  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    if (tokens.every((t) => row.haystack.includes(t))) matches.push({ i, tier: tier(row, q) });
  }

  matches.sort((a, b) => {
    if (a.tier !== b.tier) return a.tier - b.tier;
    const ra = index.repos[a.i];
    const rb = index.repos[b.i];
    return descNullLast(ra[3], rb[3]) || descNullLast(ra[4], rb[4]) || (ra[0] < rb[0] ? -1 : ra[0] > rb[0] ? 1 : 0);
  });

  return matches.map(({ i }) => {
    const [githubRepo, name, , stars, stars7d, stars30d, cats] = index.repos[i];
    const memberships: SearchMembership[] = [];
    for (const ci of cats) {
      const cat = index.cats[ci];
      const list = cat ? index.lists[cat[0]] : undefined;
      if (!cat || !list) continue;
      memberships.push({ listSlug: list[0], listName: list[1], categoryName: cat[1], categorySlug: cat[2] });
    }
    return { githubRepo, name, stars, stars7d, stars30d, memberships };
  });
}
