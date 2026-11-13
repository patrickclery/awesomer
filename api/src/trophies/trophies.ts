import {
  TROPHY_FAST_GROWTH_MIN_STARS,
  TROPHY_FAST_GROWTH_RATIO,
  TROPHY_SURGE_HIGH,
  TROPHY_SURGE_LOW,
} from '../common/constants.js';

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
