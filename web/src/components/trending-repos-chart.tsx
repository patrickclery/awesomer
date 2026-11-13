import Link from '@/components/site-link';
import type { ReactElement } from 'react';
import { Star } from 'lucide-react';
import { ExternalGitHubLink } from '@/components/external-github-link';
import { OwnerAvatar } from '@/components/owner-avatar';
import type { Repo } from '@/lib/api';
import { repoPath } from '@/lib/routes';
import { formatStars } from '@/lib/text';

interface TrendingReposChartProps {
  repos: Repo[];
}

/**
 * Ranked 7-day star-gain bar chart for the homepage right column (Phase 10).
 * Server component: bars are plain HTML with inline widths, no charting library.
 */
export function TrendingReposChart({ repos }: TrendingReposChartProps): ReactElement | null {
  if (repos.length === 0) return null;

  // Never divide by 0; API order is the ranking contract, so no re-sort here.
  const maxStars7d = Math.max(1, ...repos.map((r) => r.stars7d ?? 0));
  const heading = repos.length === 1 ? 'top repo · 7d' : `top ${repos.length} repos · 7d`;

  return (
    <section aria-labelledby="top-repos-heading" className="mb-6">
      <h2
        id="top-repos-heading"
        className="inline-block px-3 py-1 text-xs font-mono font-bold text-accent rounded-t-md"
        style={{ background: 'var(--surface)' }}
      >
        <span aria-hidden="true">{'// '}</span>
        {heading}
      </h2>
      <div
        className="rounded-lg rounded-tl-none p-2"
        style={{ background: 'color-mix(in srgb, var(--surface) 40%, transparent)' }}
      >
        {/* role="list" restores list semantics that WebKit drops under list-style: none. */}
        <ol role="list" className="flex flex-col gap-1 list-none">
          {repos.map((repo, i) => {
            const [owner, repoName] = repo.githubRepo.split('/');
            const delta = repo.stars7d ?? 0;
            const pct = Math.max(2, Math.round((delta / maxStars7d) * 100));
            return (
              <li key={repo.id} className="group rounded px-2 py-1 transition-colors hover:bg-surface/50">
                {/* Line 1: rank + avatar + name + total stars + GitHub icon */}
                <div className="flex items-center gap-2 min-w-0">
                  <span
                    aria-hidden="true"
                    className="w-6 shrink-0 text-right text-[11px] font-bold text-muted tabular-nums"
                  >
                    {i + 1}
                  </span>
                  <OwnerAvatar owner={owner} size={16} />
                  <Link
                    href={repoPath(repo.githubRepo)}
                    title={repo.githubRepo}
                    className="flex-1 min-w-0 truncate cursor-pointer rounded focus-visible:outline-2 focus-visible:outline-accent"
                  >
                    <span className="text-xs font-bold group-hover:text-accent transition-colors">{repoName}</span>
                  </Link>
                  {repo.stars != null && (
                    <span className="inline-flex items-center gap-1 shrink-0 text-[11px] text-muted">
                      <Star className="w-3 h-3 text-accent" aria-hidden="true" />
                      <span className="font-bold text-foreground">{formatStars(repo.stars)}</span>
                      <span className="sr-only">total stars</span>
                    </span>
                  )}
                  <ExternalGitHubLink githubRepo={repo.githubRepo} size={11} label={`${repoName} on GitHub`} />
                </div>
                {/* Line 2: bar + delta */}
                <div className="flex items-center gap-2 mt-1 pl-8">
                  <div
                    aria-hidden="true"
                    className="flex-1 h-2 rounded-sm overflow-hidden"
                    style={{ background: 'color-mix(in srgb, var(--surface) 70%, transparent)' }}
                  >
                    <div
                      className="trend-bar h-full rounded-sm"
                      style={{ width: `${pct}%`, animationDelay: `${i * 40}ms` }}
                    />
                  </div>
                  <span className="shrink-0 text-[11px] font-bold text-success tabular-nums">
                    +{delta.toLocaleString()}
                    <span className="sr-only"> stars this week</span>
                  </span>
                </div>
              </li>
            );
          })}
        </ol>
        <div className="flex justify-end mt-2 pt-2 border-t border-border/50">
          <Link
            href="/trending"
            className="text-[11px] text-muted hover:text-accent transition-colors rounded focus-visible:outline-2 focus-visible:outline-accent"
          >
            view all trending <span aria-hidden="true">&rarr;</span>
          </Link>
        </div>
      </div>
    </section>
  );
}
