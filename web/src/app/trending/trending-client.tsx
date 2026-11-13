'use client';

import { useState } from 'react';
import { RepoHeroCard } from '@/components/repo-hero-card';
import { RepoMiniCard } from '@/components/repo-mini-card';
import { SidebarRepoList } from '@/components/sidebar-repo-list';
import { PERIODS, type Period } from '@/lib/period';
import type { Repo } from '@/lib/api';

interface Props {
  data7d: Repo[];
  data30d: Repo[];
  data90d: Repo[];
}

export default function TrendingClient({ data7d, data30d, data90d }: Props) {
  const [period, setPeriod] = useState<Period>('7d');

  const data: Record<Period, Repo[]> = { '7d': data7d, '30d': data30d, '90d': data90d };
  // Every absolute trophy is a 7d signal, so the 30d/90d tabs drop them rather than mix windows (WR-01).
  const repos = period === '7d' ? data[period] : data[period].map((r) => ({ ...r, trophies: [] }));
  const heroRepo = repos[0];
  const gridRepos = repos.slice(1, 5);
  const sidebarRepos = repos.slice(5, 14);
  const tailRepos = repos.slice(14, 25);
  const half = Math.ceil(tailRepos.length / 2);
  const tailLeft = tailRepos.slice(0, half);
  const tailRight = tailRepos.slice(half);

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-xl font-bold">$ trending --global</h1>
        <div className="flex gap-1" role="group" aria-label="trending period">
          {PERIODS.map((p) => (
            <button
              key={p}
              type="button"
              aria-pressed={period === p}
              onClick={() => setPeriod(p)}
              className={`px-3 py-1 text-xs transition-colors focus-visible:outline-2 focus-visible:outline-accent ${
                period === p
                  ? 'border border-accent text-accent'
                  : 'border border-border text-muted hover:text-foreground hover:border-muted'
              }`}
            >
              {p}
            </button>
          ))}
        </div>
      </div>

      {repos.length > 0 ? (
        <>
          <div key={period} className="stagger">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              <div className="lg:col-span-2">
                {heroRepo && (
                  <div className="mb-4">
                    <RepoHeroCard repo={heroRepo} period={period} showStarburst labelRank />
                  </div>
                )}
                {gridRepos.length > 0 && (
                  <div className="flex flex-col gap-2 stagger">
                    {gridRepos.map((repo, i) => (
                      <RepoMiniCard key={repo.id} repo={repo} rank={i + 2} period={period} labelRank />
                    ))}
                  </div>
                )}
              </div>
              {sidebarRepos.length > 0 && (
                <div className="lg:col-span-1">
                  <SidebarRepoList repos={sidebarRepos} period={period} labelRank />
                </div>
              )}
            </div>
          </div>
          {tailRepos.length > 0 && (
            <section aria-labelledby="trending-tail-heading" className="mt-8">
              <div className="flex items-center gap-3 mb-4">
                <h2 id="trending-tail-heading" className="text-accent text-xs font-mono tracking-widest">
                  MORE TRENDING
                </h2>
                <span className="flex-1 h-px bg-border" aria-hidden="true" />
                <span className="text-muted text-xs">{`#15–${14 + tailRepos.length}`}</span>
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-0.5">
                <SidebarRepoList repos={tailLeft} period={period} startRank={15} labelRank />
                {tailRight.length > 0 && (
                  <SidebarRepoList repos={tailRight} period={period} startRank={15 + tailLeft.length} labelRank />
                )}
              </div>
            </section>
          )}
        </>
      ) : (
        <div className="py-8 text-muted text-sm">
          <span className="text-danger">[ERR]</span> no trending data available.
        </div>
      )}
    </div>
  );
}
