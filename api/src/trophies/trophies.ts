import {
  MIN_STARS,
  TROPHY_FAST_GROWTH_MIN_STARS,
  TROPHY_FAST_GROWTH_RATIO,
  TROPHY_SURGE_HIGH,
  TROPHY_SURGE_LOW,
} from '../common/constants.js';
import type { PrismaService } from '../prisma/prisma.service.js';

export type TrophyId =
  | 'surge-10k'
  | 'hottest-in-list'
  | 'fast-growing'
  | 'surge-1k';

export interface ListRef {
  listSlug: string;
  listName: string;
}

export interface Trophy {
  id: TrophyId;
  listSlug?: string;
  listName?: string;
}

/**
 * Trophies a repo has earned, sorted by priority: surge-10k, hottest-in-list, fast-growing,
 * surge-1k (D-01). The two surge tiers are exclusive (D-02). Only the 7d delta is read (D-04).
 *
 * Missing data never earns a trophy (D-08): a NULL, zero or negative stars7d returns an empty
 * array even when `hottestInLists` is non-empty, a NULL stars earns no fast-growing, and a
 * non-positive base (stars - stars7d) never divides.
 *
 * `hottestInLists` entries are emitted in the order given; callers must only pass lists where
 * the repo is #1 by the same filter and tiebreak as the list page.
 */
export function computeTrophies(
  repo: { stars: number | null; stars7d: number | null },
  opts: { hottestInLists?: ListRef[] } = {},
): Trophy[] {
  const out: Trophy[] = [];
  const d7 = repo.stars7d;
  if (d7 == null || d7 <= 0) return out;

  if (d7 >= TROPHY_SURGE_HIGH) out.push({ id: 'surge-10k' });

  for (const l of opts.hottestInLists ?? []) {
    out.push({
      id: 'hottest-in-list',
      listSlug: l.listSlug,
      listName: l.listName,
    });
  }

  if (repo.stars != null && repo.stars >= TROPHY_FAST_GROWTH_MIN_STARS) {
    const base = repo.stars - d7;
    if (base > 0 && d7 / base >= TROPHY_FAST_GROWTH_RATIO)
      out.push({ id: 'fast-growing' });
  }

  if (d7 >= TROPHY_SURGE_LOW && d7 < TROPHY_SURGE_HIGH)
    out.push({ id: 'surge-1k' });

  return out;
}

/**
 * repoId -> the active lists where that repo is #1 by stars7d, each array sorted by listName.
 *
 * Mirrors getTrendingByAwesomeList's filter (stars >= MIN_STARS, stars7d > 0) and tiebreak
 * (stars7d desc, then id asc) so the list-page hero starburst and the detail page's
 * "Hottest in" chip always name the same repo (D-07). Archived lists are excluded because
 * they have no page. One query for every list, never one per repo.
 */
export async function findHottestRepoPerList(
  prisma: PrismaService,
): Promise<Map<number, ListRef[]>> {
  const rows = await prisma.$queryRaw<
    Array<{ repo_id: number; list_slug: string; list_name: string }>
  >`
    SELECT DISTINCT ON (al.id) al.slug AS list_slug, al.name AS list_name, r.id AS repo_id
    FROM awesome_lists al
    JOIN categories c      ON c.awesome_list_id = al.id
    JOIN category_items ci ON ci.category_id = c.id
    JOIN repos r           ON r.id = ci.repo_id
    WHERE al.archived = false AND r.stars >= ${MIN_STARS} AND r.stars_7d > 0
    ORDER BY al.id, r.stars_7d DESC, r.id ASC`;

  const map = new Map<number, ListRef[]>();
  for (const row of rows) {
    const id = Number(row.repo_id); // pg may return ids as strings; keys must be numbers
    const refs = map.get(id) ?? [];
    refs.push({ listSlug: row.list_slug, listName: row.list_name });
    map.set(id, refs);
  }
  for (const refs of map.values())
    refs.sort((a, b) => a.listName.localeCompare(b.listName));
  return map;
}
