import { Flame, Rocket, TrendingUp, Zap, type LucideIcon } from 'lucide-react';
import type { Trophy, TrophyId } from '@/lib/api';

export interface TrophyMeta {
  icon: LucideIcon;
  label: (t: Trophy) => string;
  title: (t: Trophy) => string;
  variant: string;
}

function listNameOf(t: Trophy): string | null {
  return t.listName || t.listSlug || null;
}

/**
 * The only place trophy copy lives (D-06). The web never computes trophies; it maps payload ids here.
 * The numbers mirror the D-03 constants in api/src/common/constants.ts; update both in the same change.
 */
export const TROPHY_META: Record<TrophyId, TrophyMeta> = {
  'surge-10k': {
    icon: Rocket,
    label: () => '10k+ this week',
    title: () => 'Gained 10,000+ stars in the last 7 days',
    variant: 'trophy--surge-10k',
  },
  'hottest-in-list': {
    icon: Flame,
    label: (t) => {
      const name = listNameOf(t);
      return name ? `Hottest in ${name}` : 'Hottest in list';
    },
    title: (t) => {
      const name = listNameOf(t);
      return `#1 by stars gained this week in ${name ?? 'its list'}`;
    },
    variant: 'trophy--hottest-in-list',
  },
  'fast-growing': {
    icon: TrendingUp,
    label: () => 'Fast-growing',
    title: () => 'Stars grew 25%+ in the last 7 days',
    variant: 'trophy--fast-growing',
  },
  'surge-1k': {
    icon: Zap,
    label: () => '1k+ this week',
    title: () => 'Gained 1,000+ stars in the last 7 days',
    variant: 'trophy--surge-1k',
  },
};
