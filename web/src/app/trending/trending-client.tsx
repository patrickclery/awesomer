'use client';

import { useState } from 'react';
import { RepoHeroCard } from '@/components/repo-hero-card';
import { TrendingTable } from '@/components/trending-table';
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
  const repos = data[period];
  const heroRepo = repos[0];

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
                    <RepoHeroCard repo={heroRepo} period={period} showStarburst />
                  </div>
                )}
              </div>
            </div>
          </div>
          {repos.length > 1 && (
            <div className="mt-8">
              <TrendingTable
                title={`#2–${repos.length} — ${period} trending`}
                repos={repos.slice(1)}
                period={period}
                startRank={2}
              />
            </div>
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
