'use client';

import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';
import { getRepoByGithub, getStarHistory, type StarHistoryPoint } from '@/lib/api';

interface RepoData {
  id: number;
  githubRepo: string;
  description: string | null;
  stars: number | null;
  stars7d: number | null;
  stars30d: number | null;
  stars90d: number | null;
  lastCommitAt: string | null;
  categoryItems: Array<{
    category: {
      id: number;
      name: string;
      slug: string;
      awesomeList: { id: number; name: string; slug: string };
    };
  }>;
}

function formatDelta(value: number | null) {
  if (value === null || value === 0) return null;
  return value > 0 ? `+${value.toLocaleString()}` : value.toLocaleString();
}

export default function RepoDetailPage() {
  const params = useParams();
  const slug = params.slug as string;
  const repoSlug = params.repoSlug as string;

  const [repo, setRepo] = useState<RepoData | null>(null);
  const [starHistory, setStarHistory] = useState<StarHistoryPoint[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    const githubRepo = repoSlug.replace('-', '/');
    const [owner, name] = githubRepo.split('/');
    if (!owner || !name) {
      setError(true);
      setLoading(false);
      return;
    }

    Promise.all([
      getRepoByGithub(owner, name).catch(() => null),
    ])
      .then(async ([repoRes]) => {
        if (!repoRes) {
          setError(true);
          return;
        }
        setRepo(repoRes.data);

        // Fetch star history separately
        try {
          const historyRes = await getStarHistory(repoRes.data.id);
          setStarHistory(historyRes.data);
        } catch {
          // Star history not available
        }
      })
      .finally(() => setLoading(false));
  }, [repoSlug]);

  if (loading) {
    return <div className="text-center py-12 text-muted">Loading...</div>;
  }

  if (error || !repo) {
    return (
      <div className="text-center py-12">
        <h1 className="text-2xl font-bold mb-4">Repository not found</h1>
        <Link
          href={`/${slug}/repos`}
          className="text-accent hover:text-accent-hover"
        >
          Back to repos
        </Link>
      </div>
    );
  }

  const d7 = formatDelta(repo.stars7d);
  const d30 = formatDelta(repo.stars30d);
  const d90 = formatDelta(repo.stars90d);

  return (
    <div>
      {/* Breadcrumb */}
      <nav className="text-sm text-muted mb-6">
        <Link href={`/${slug}`} className="hover:text-accent">
          {slug}
        </Link>
        <span className="mx-2">/</span>
        <Link href={`/${slug}/repos`} className="hover:text-accent">
          repos
        </Link>
        <span className="mx-2">/</span>
        <span className="text-foreground">{repo.githubRepo}</span>
      </nav>

      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold mb-2">{repo.githubRepo}</h1>
        {repo.description && (
          <p className="text-muted text-lg mb-4">{repo.description}</p>
        )}

        <div className="flex flex-wrap gap-4 items-center">
          <a
            href={`https://github.com/${repo.githubRepo}`}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-4 py-2 bg-surface border border-border rounded-lg hover:border-accent transition-colors"
          >
            View on GitHub
          </a>
          {repo.lastCommitAt && (
            <span className="text-sm text-muted">
              Last commit: {new Date(repo.lastCommitAt).toLocaleDateString()}
            </span>
          )}
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div className="p-4 bg-surface border border-border rounded-lg">
          <div className="text-sm text-muted mb-1">Stars</div>
          <div className="text-2xl font-bold font-mono">
            {repo.stars?.toLocaleString() ?? '-'}
          </div>
        </div>
        <div className="p-4 bg-surface border border-border rounded-lg">
          <div className="text-sm text-muted mb-1">7-day change</div>
          <div
            className={`text-2xl font-bold font-mono ${
              repo.stars7d && repo.stars7d > 0
                ? 'text-success'
                : repo.stars7d && repo.stars7d < 0
                  ? 'text-danger'
                  : ''
            }`}
          >
            {d7 || '-'}
          </div>
        </div>
        <div className="p-4 bg-surface border border-border rounded-lg">
          <div className="text-sm text-muted mb-1">30-day change</div>
          <div
            className={`text-2xl font-bold font-mono ${
              repo.stars30d && repo.stars30d > 0
                ? 'text-success'
                : repo.stars30d && repo.stars30d < 0
                  ? 'text-danger'
                  : ''
            }`}
          >
            {d30 || '-'}
          </div>
        </div>
        <div className="p-4 bg-surface border border-border rounded-lg">
          <div className="text-sm text-muted mb-1">90-day change</div>
          <div
            className={`text-2xl font-bold font-mono ${
              repo.stars90d && repo.stars90d > 0
                ? 'text-success'
                : repo.stars90d && repo.stars90d < 0
                  ? 'text-danger'
                  : ''
            }`}
          >
            {d90 || '-'}
          </div>
        </div>
      </div>

      {/* Star History Chart */}
      {starHistory.length > 1 && (
        <div className="mb-8">
          <h2 className="text-lg font-semibold mb-4">Star History</h2>
          <div className="p-4 bg-surface border border-border rounded-lg">
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={starHistory}>
                <CartesianGrid strokeDasharray="3 3" stroke="#262626" />
                <XAxis
                  dataKey="snapshotDate"
                  tick={{ fill: '#737373', fontSize: 12 }}
                  tickFormatter={(value: string) =>
                    new Date(value).toLocaleDateString('en-US', {
                      month: 'short',
                      day: 'numeric',
                    })
                  }
                />
                <YAxis
                  tick={{ fill: '#737373', fontSize: 12 }}
                  tickFormatter={(value: number) =>
                    value >= 1000 ? `${(value / 1000).toFixed(1)}k` : String(value)
                  }
                />
                <Tooltip
                  contentStyle={{
                    backgroundColor: '#141414',
                    border: '1px solid #262626',
                    borderRadius: '8px',
                    color: '#ededed',
                  }}
                  labelFormatter={(label) =>
                    new Date(String(label)).toLocaleDateString()
                  }
                  formatter={(value) => [
                    Number(value).toLocaleString(),
                    'Stars',
                  ]}
                />
                <Line
                  type="monotone"
                  dataKey="stars"
                  stroke="#3b82f6"
                  strokeWidth={2}
                  dot={false}
                />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>
      )}

      {/* Categories */}
      {repo.categoryItems.length > 0 && (
        <div>
          <h2 className="text-lg font-semibold mb-4">Found in</h2>
          <div className="flex flex-wrap gap-2">
            {repo.categoryItems.map((ci) => (
              <Link
                key={ci.category.id}
                href={`/${ci.category.awesomeList.slug}/repos?category=${ci.category.slug}`}
                className="px-3 py-1 bg-surface border border-border rounded-full text-sm text-muted hover:text-foreground hover:border-accent transition-colors"
              >
                {ci.category.awesomeList.name} / {ci.category.name}
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
