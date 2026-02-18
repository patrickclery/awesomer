'use client';

import { useState } from 'react';
import { TrendingTable } from '@/components/trending-table';
import type { Repo } from '@/lib/api';

type Period = '7d' | '30d' | '90d';

interface Props {
  data7d: Repo[];
  data30d: Repo[];
  data90d: Repo[];
}

export default function TrendingClient({ data7d, data30d, data90d }: Props) {
  const [period, setPeriod] = useState<Period>('7d');

  const data: Record<Period, Repo[]> = { '7d': data7d, '30d': data30d, '90d': data90d };
  const repos = data[period];

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-2xl font-bold">Global Trending</h1>
        <div className="flex gap-2">
          {(['7d', '30d', '90d'] as Period[]).map((p) => (
            <button
              key={p}
              onClick={() => setPeriod(p)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                period === p
                  ? 'bg-accent text-white'
                  : 'bg-surface border border-border text-muted hover:text-foreground'
              }`}
            >
              {p}
            </button>
          ))}
        </div>
      </div>

      {repos.length > 0 ? (
        <TrendingTable
          title={`Top ${repos.length} — ${period} Trending`}
          repos={repos}
          period={period}
        />
      ) : (
        <div className="text-center py-12 text-muted">
          No trending data available.
        </div>
      )}
    </div>
  );
}
