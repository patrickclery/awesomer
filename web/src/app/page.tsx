import Link from 'next/link';
import { getTrendingLists } from '@/lib/api';
import type { TrendingList } from '@/lib/api';
import { listPath } from '@/lib/routes';
import { Star } from 'lucide-react';
import { ExternalGitHubLink } from '@/components/external-github-link';
import { HomeInfoCard } from '@/components/home-info-card';
import { OwnerAvatar } from '@/components/owner-avatar';
import { cleanDescription } from '@/lib/text';

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

function formatDelta(value: number): string {
  if (value === 0) return '0';
  return value >= 0 ? `+${value.toLocaleString()}` : value.toLocaleString();
}

function stripAwesomePrefix(name: string): string {
  return name
    .replace(/^awesome[-\s]+/i, '')
    .replace(/-/g, ' ')
    .replace(/\b\w/g, (c) => c.toUpperCase());
}

function HeroCard({ list }: { list: TrendingList }) {
  const displayName = stripAwesomePrefix(list.name);
  const description = cleanDescription(list.description);

  return (
    <div className="card-featured card-pulse p-4 sm:p-5 h-full group relative flex flex-col">
      {/* Watermark rank */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <span className="absolute -right-2 -bottom-6 text-[10rem] font-black font-mono text-accent/[0.07] select-none leading-none">1</span>
      </div>
      {/* Hottest list starburst badge */}
      <div className="starburst">
        <span className="starburst-text">
          HOTTEST
          <span className="starburst-sub">this week</span>
        </span>
      </div>
      <div className="flex items-center gap-3 mb-2">
        <OwnerAvatar owner={list.githubRepo.split('/')[0]} size={40} />
        <Link
          href={listPath(list.slug)}
          className="cursor-pointer rounded focus-visible:outline-2 focus-visible:outline-accent"
        >
          <h2 className="inline text-2xl sm:text-3xl font-bold gradient-text transition-opacity group-hover:opacity-90">
            {displayName}
          </h2>
        </Link>
      </div>
      {description && (
        <p className="description text-muted text-sm mb-3 max-w-2xl">{description}</p>
      )}
      {/* Metric row: delta · stars · github */}
      <div className="flex items-center gap-4 text-sm">
        {list.stars7d > 0 && (
          <span className="font-bold text-success">
            +{list.stars7d.toLocaleString()}
          </span>
        )}
        <span className="inline-flex items-center gap-1.5 text-muted">
          <Star className="w-4 h-4 text-accent" aria-hidden="true" />
          <span className="font-bold text-foreground">
            {list.totalStars > 0 ? formatStars(list.totalStars) : '—'}
          </span>
        </span>
        <ExternalGitHubLink
          githubRepo={list.githubRepo}
          size={16}
          label={`${list.name} on GitHub`}
        />
      </div>
    </div>
  );
}

function MiniCard({ list, rank }: { list: TrendingList; rank: number }) {
  const displayName = stripAwesomePrefix(list.name);
  const description = cleanDescription(list.description);

  return (
    <div className="card-mini p-3 sm:p-4 h-full group relative overflow-hidden flex-1">
      {/* Watermark rank number */}
      <span className="absolute -right-1 -bottom-3 text-7xl font-black font-mono text-accent/[0.07] select-none pointer-events-none leading-none">
        {rank}
      </span>
      <div className="relative">
        <div className="flex items-center gap-2 min-w-0">
          <OwnerAvatar owner={list.githubRepo.split('/')[0]} size={24} />
          <div className="flex-1 min-w-0">
            <Link
              href={listPath(list.slug)}
              className="cursor-pointer rounded focus-visible:outline-2 focus-visible:outline-accent"
            >
              <h3 className="inline text-sm font-bold group-hover:text-accent transition-colors">
                {displayName}
              </h3>
            </Link>
            {description && (
              <p className="description text-muted text-xs mt-0.5">{description}</p>
            )}
          </div>
        </div>
        {/* Bottom metric row: delta · stars · github */}
        <div className="flex items-center gap-3 mt-2 text-xs">
          {list.stars7d > 0 && (
            <span className="font-bold text-success">
              +{list.stars7d.toLocaleString()}
            </span>
          )}
          <span className="inline-flex items-center gap-1 text-muted">
            <Star className="w-3 h-3 text-accent" aria-hidden="true" />
            <span className="font-bold text-foreground">
              {list.totalStars > 0 ? formatStars(list.totalStars) : '—'}
            </span>
          </span>
          <ExternalGitHubLink
            githubRepo={list.githubRepo}
            size={12}
            label={`${list.name} on GitHub`}
          />
        </div>
      </div>
    </div>
  );
}

export default async function HomePage() {
  let lists: TrendingList[] = [];

  try {
    const response = await getTrendingLists();
    lists = response.data;
  } catch {
    // API not available yet
  }

  // Fetch stats for the awesomer repo itself (not aggregates) — stars + last push
  // from GitHub's public REST API. Runs at build time (SSG); unauthenticated 60/hr
  // is plenty for a single call per build. Non-fatal on failure.
  let awesomerStars: number | null = null;
  let awesomerLastCommitAt: string | null = null;
  let awesomerDescription: string | null = null;
  try {
    const res = await fetch('https://api.github.com/repos/patrickclery/awesomer', {
      headers: { Accept: 'application/vnd.github+json' },
      signal: AbortSignal.timeout(10000)
    });
    if (res.ok) {
      const repo = (await res.json()) as { stargazers_count?: number; pushed_at?: string; description?: string };
      awesomerStars = typeof repo.stargazers_count === 'number' ? repo.stargazers_count : null;
      awesomerLastCommitAt = typeof repo.pushed_at === 'string' ? repo.pushed_at : null;
      awesomerDescription = typeof repo.description === 'string' ? repo.description : null;
    }
  } catch {
    // GitHub API unavailable — render stats as —
  }

  const heroList = lists[0];
  const gridLists = lists.slice(1, 5);
  const sidebarLists = lists.slice(5);
  const hasMore = false;

  const totalRepos = lists.reduce((sum, l) => sum + (l.repoCount || 0), 0);
  const homeDescription =
    awesomerDescription ?? 'What if every Awesome List had a trending page? Now they do.';

  return (
    <div>
      <HomeInfoCard
        githubRepo="patrickclery/awesomer"
        description={homeDescription}
        stars={awesomerStars}
        listCount={lists.length}
        repoCount={totalRepos}
        lastCommitAt={awesomerLastCommitAt}
      />

      {lists.length > 0 ? (
        <div className="stagger">
          {/* Main content: 2/3 left (hero + #2-5) | 1/3 right (#6-20 sidebar) */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Left 2/3: Hero + mini cards */}
            <div className="lg:col-span-2">
              {/* Hero #1 -- full width of left column */}
              {heroList && (
                <div className="mb-4">
                  <HeroCard list={heroList} />
                </div>
              )}

              {/* #2-5 mini cards stacked */}
              {gridLists.length > 0 && (
                <div className="flex flex-col gap-2 stagger">
                  {gridLists.map((list, i) => (
                    <MiniCard
                      key={list.id}
                      list={list}
                      rank={i + 2}
                    />
                  ))}
                </div>
              )}
            </div>

            {/* Right 1/3: Sidebar list #6-20 */}
            {sidebarLists.length > 0 && (
              <div className="lg:col-span-1">
                <div className="flex flex-col gap-0.5">
                  {sidebarLists.map((list, i) => (
                    <div
                      key={list.id}
                      className="card-tiny px-2.5 py-2 group relative overflow-hidden"
                    >
                      {/* Rank watermark */}
                      <span className="absolute -right-1 -bottom-2 text-4xl font-black font-mono text-accent/[0.07] select-none pointer-events-none leading-none">
                        {i + 6}
                      </span>
                      {/* Line 1: avatar + title + description */}
                      <div className="flex items-center gap-2 min-w-0 relative">
                        <OwnerAvatar owner={list.githubRepo.split('/')[0]} size={20} />
                        <div className="flex items-baseline gap-1.5 min-w-0 flex-1">
                          <Link
                            href={listPath(list.slug)}
                            className="truncate shrink-0 cursor-pointer rounded focus-visible:outline-2 focus-visible:outline-accent"
                          >
                            <span className="text-xs font-bold group-hover:text-accent transition-colors">
                              {stripAwesomePrefix(list.name)}
                            </span>
                          </Link>
                          {cleanDescription(list.description) && (
                            <span className="description text-[11px] text-muted truncate min-w-0">
                              {cleanDescription(list.description)}
                            </span>
                          )}
                        </div>
                      </div>
                      {/* Line 2: metrics + github icon */}
                      <div className="flex items-center gap-3 mt-1 text-[11px] relative">
                        {list.stars7d > 0 && (
                          <span className="font-bold text-success">
                            +{list.stars7d.toLocaleString()}
                          </span>
                        )}
                        {list.totalStars > 0 && (
                          <span className="inline-flex items-center gap-1 text-muted">
                            <Star className="w-3 h-3 text-accent" aria-hidden="true" />
                            <span className="font-bold text-foreground">{formatStars(list.totalStars)}</span>
                          </span>
                        )}
                        <ExternalGitHubLink
                          githubRepo={list.githubRepo}
                          size={11}
                          label={`${list.name} on GitHub`}
                        />
                      </div>
                    </div>
                  ))}
                  {hasMore && (
                    <Link
                      href="/trending"
                      className="text-xs text-muted hover:text-accent transition-colors text-center py-2 mt-1"
                    >
                      view all &rarr;
                    </Link>
                  )}
                </div>
              </div>
            )}
          </div>
        </div>
      ) : (
        <div className="py-8 text-muted text-sm">
          <span className="text-danger">[ERR]</span> no data available. connect
          the API to get started.
        </div>
      )}
    </div>
  );
}
