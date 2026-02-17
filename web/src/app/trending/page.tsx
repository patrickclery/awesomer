'use client';

import { useState, useEffect } from 'react';
import { getTrending, type Repo } from '@/lib/api';
import { TrendingTable } from '@/components/trending-table';

type Period = '7d' | '30d' | '90d';

export default function TrendingPage() {
  const [period, setPeriod] = useState<Period>('7d');
  const [repos, setRepos] = useState<Repo[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    getTrending({ period, limit: 25 })
      .then((res) => setRepos(res.data))
      .catch(() => setRepos([]))
      .finally(() => setLoading(false));
  }, [period]);

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

      {loading ? (
        <div className="text-center py-12 text-muted">Loading...</div>
      ) : repos.length > 0 ? (
        <TrendingTable
          title={`Top ${repos.length} — ${period} Trending`}
          repos={repos}
          period={period}
        />
      ) : (
        <div className="text-center py-12 text-muted">
          No trending data available. Connect the API to get started.
        </div>
      )}
    </div>
  );
}
