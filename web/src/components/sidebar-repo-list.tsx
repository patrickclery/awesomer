import Link from '@/components/site-link';
import { Star } from 'lucide-react';
import { repoPath } from '@/lib/routes';
import { ExternalGitHubLink } from '@/components/external-github-link';
import { OwnerAvatar } from '@/components/owner-avatar';
import { cleanDescription } from '@/lib/text';
import type { Trophy } from '@/lib/api';
import { TrophyIcon } from '@/components/trophy-chips';
import { TROPHY_META } from '@/lib/trophies';
import { periodDelta, type Period } from '@/lib/period';

interface SidebarRepo {
  id: number;
  githubRepo: string;
  description?: string | null;
  stars?: number | null;
  stars7d: number | null;
  stars30d?: number | null;
  stars90d?: number | null;
  trophies?: Trophy[];
}

interface SidebarRepoListProps {
  repos: SidebarRepo[];
  /** Trending window that picks the delta; defaults to 7d. */
  period?: Period;
  /** Watermark rank of the first row; defaults to 6. */
  startRank?: number;
  /** Opt-in: names the rank for screen readers and hides the watermark from them; off keeps /l/ output unchanged. */
  labelRank?: boolean;
}

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

/** First trophy this build knows, so an id newer than the web never hides a known one after it. */
function FirstTrophyIcon({ trophies }: { trophies?: Trophy[] }) {
  const first = trophies?.find((t) => TROPHY_META[t.id] !== undefined);
  return first ? <TrophyIcon trophy={first} /> : null;
}

export function SidebarRepoList({ repos, period = '7d', startRank = 6, labelRank }: SidebarRepoListProps) {
  const rows = repos.map((repo) => ({ repo, delta: periodDelta(repo, period) }));
  return (
    <div>
      <div className="flex flex-col gap-0.5">
        {rows.map(({ repo, delta }, i) => (
          <div
            key={repo.id}
            className="card-tiny px-2.5 py-2 group relative overflow-hidden"
          >
            {labelRank && <span className="sr-only">{`Rank ${i + startRank}`}</span>}
            {/* Rank watermark */}
            <span aria-hidden={labelRank || undefined} className="absolute -right-1 -bottom-2 text-4xl font-black font-mono text-accent/[0.07] select-none pointer-events-none leading-none">
              {i + startRank}
            </span>
            {/* Line 1: avatar + (title + description) */}
            <div className="flex items-center gap-2 min-w-0 relative">
              <OwnerAvatar owner={repo.githubRepo.split('/')[0]} size={20} />
              <div className="flex items-baseline gap-1.5 min-w-0 flex-1">
                <Link
                  href={repoPath(repo.githubRepo)}
                  className="truncate shrink-0 cursor-pointer rounded focus-visible:outline-2 focus-visible:outline-accent"
                >
                  <span className="text-xs font-bold group-hover:text-accent transition-colors">
                    {repo.githubRepo.split('/')[1]}
                  </span>
                </Link>
                {cleanDescription(repo.description) && (
                  <span className="description text-[11px] text-muted truncate min-w-0">
                    {cleanDescription(repo.description)}
                  </span>
                )}
              </div>
            </div>
            {/* Line 2: metrics + github icon + trophy icon */}
            <div className="flex items-center gap-3 mt-1 text-[11px] relative">
              {delta != null && delta > 0 && (
                <span className="font-bold text-success">
                  +{delta.toLocaleString()}
                </span>
              )}
              {repo.stars != null && (
                <span className="inline-flex items-center gap-1 text-muted">
                  <Star className="w-3 h-3 text-accent" aria-hidden="true" />
                  <span className="font-bold text-foreground">{formatStars(repo.stars)}</span>
                </span>
              )}
              <ExternalGitHubLink
                githubRepo={repo.githubRepo}
                size={11}
                label={`${repo.githubRepo.split('/')[1]} on GitHub`}
              />
              <FirstTrophyIcon trophies={repo.trophies} />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
