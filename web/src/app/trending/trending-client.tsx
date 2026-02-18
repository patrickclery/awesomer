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
        <h1 className="text-xl font-bold">$ trending --global</h1>
        <div className="flex gap-1">
          {(['7d', '30d', '90d'] as Period[]).map((p) => (
            <button
              key={p}
              onClick={() => setPeriod(p)}
              className={`px-3 py-1 text-xs transition-colors ${
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
        <TrendingTable
          title={`top ${repos.length} — ${period} trending`}
          repos={repos}
          period={period}
        />
      ) : (
        <div className="py-8 text-muted text-sm">
          no trending data available.
        </div>
      )}
    </div>
  );
}
