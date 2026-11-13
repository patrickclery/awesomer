import Link from '@/components/site-link';
import { repoPath } from '@/lib/routes';
import { Star } from 'lucide-react';
import { ExternalGitHubLink } from '@/components/external-github-link';
import { OwnerAvatar } from '@/components/owner-avatar';
import { cleanDescription } from '@/lib/text';
import type { Trophy } from '@/lib/api';
import { TrophyChips } from '@/components/trophy-chips';
import { PERIOD_SUB_LABEL, periodDelta, type Period } from '@/lib/period';

interface RepoHeroCardProps {
  repo: {
    id: number;
    githubRepo: string;
    description: string | null;
    stars: number | null;
    stars7d: number | null;
    stars30d?: number | null;
    stars90d?: number | null;
    trophies?: Trophy[];
  };
  /** Trending window that picks the delta and the starburst label; defaults to 7d. */
  period?: Period;
  /** Forces the starburst when the payload has no list context (/trending). */
  showStarburst?: boolean;
  /** Opt-in: names the rank for screen readers and hides the watermark from them; off keeps /l/ output unchanged. */
  labelRank?: boolean;
}

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

export function RepoHeroCard({ repo, period = '7d', showStarburst, labelRank }: RepoHeroCardProps) {
  const description = cleanDescription(repo.description);
  const delta = periodDelta(repo, period);
  // The single starburst gate (D-09). /trending ORs in showStarburst (Phase 21).
  const hasHottestTrophy = showStarburst || (repo.trophies?.some((t) => t.id === 'hottest-in-list') ?? false);
  return (
    <div className="card-featured card-pulse p-4 sm:p-5 h-full group relative flex flex-col">
      {labelRank && <span className="sr-only">Rank 1</span>}
      {/* Watermark rank */}
      <div aria-hidden={labelRank || undefined} className="absolute inset-0 overflow-hidden pointer-events-none">
        <span className="absolute -right-2 -bottom-6 text-[10rem] font-black font-mono text-accent/[0.07] select-none leading-none">
          1
        </span>
      </div>
      {/* Hottest repo starburst badge */}
      {hasHottestTrophy && (
        <div className="starburst">
          <span className="starburst-text">
            HOTTEST
            <span className="starburst-sub">{PERIOD_SUB_LABEL[period]}</span>
          </span>
        </div>
      )}
      <div className="flex items-center gap-3 mb-2">
        <OwnerAvatar owner={repo.githubRepo.split('/')[0]} size={40} />
        <Link
          href={repoPath(repo.githubRepo)}
          className="cursor-pointer rounded focus-visible:outline-2 focus-visible:outline-accent"
        >
          <h2 className="inline text-2xl sm:text-3xl font-bold gradient-text transition-opacity group-hover:opacity-90">
            {repo.githubRepo.split('/')[1]}
          </h2>
        </Link>
      </div>
      {description && (
        <p className="description text-muted text-sm mb-3 max-w-2xl">
          {description}
        </p>
      )}
      {/* Metric row: delta · stars · github · trophies */}
      <div className="flex flex-wrap items-center gap-x-4 gap-y-2 pr-24 text-sm">
        {delta != null && delta > 0 && (
          <span className="font-bold text-success">
            +{delta.toLocaleString()}
          </span>
        )}
        <span className="inline-flex items-center gap-1.5 text-muted">
          <Star className="w-4 h-4 text-accent" aria-hidden="true" />
          <span className="font-bold text-foreground">
            {repo.stars != null ? formatStars(repo.stars) : '—'}
          </span>
        </span>
        <ExternalGitHubLink
          githubRepo={repo.githubRepo}
          size={16}
          label={`${repo.githubRepo.split('/')[1]} on GitHub`}
        />
        <TrophyChips trophies={repo.trophies} size="md" max={2} exclude={['hottest-in-list']} />
      </div>
    </div>
  );
}
