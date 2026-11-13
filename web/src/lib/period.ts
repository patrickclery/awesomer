/** A trending window: the last 7, 30 or 90 days. */
export type Period = '7d' | '30d' | '90d';

/** The trending windows in toggle order. */
export const PERIODS: Period[] = ['7d', '30d', '90d'];

/** Starburst sub-label for each trending window. */
export const PERIOD_SUB_LABEL: Record<Period, string> = {
  '7d': 'this week',
  '30d': 'this month',
  '90d': 'this quarter',
};

/** The star-delta fields a repo may carry; only the 7d field is always present. */
export interface PeriodDeltas {
  stars7d: number | null;
  stars30d?: number | null;
  stars90d?: number | null;
}

/** Returns the repo's star delta for the given trending window, or null when it is unknown. */
export function periodDelta(repo: PeriodDeltas, period: Period): number | null {
  switch (period) {
    case '7d':
      return repo.stars7d;
    case '30d':
      return repo.stars30d ?? null;
    case '90d':
      return repo.stars90d ?? null;
  }
}
