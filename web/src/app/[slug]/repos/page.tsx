'use client';

import { useState, useEffect } from 'react';
import { useParams, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { getReposByList, type CategoryItem } from '@/lib/api';

type SortOption = 'stars' | 'trending_7d' | 'trending_30d' | 'trending_90d';

export default function ReposPage() {
  const params = useParams();
  const searchParams = useSearchParams();
  const slug = params.slug as string;

  const [repos, setRepos] = useState<CategoryItem[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [sort, setSort] = useState<SortOption>(
    (searchParams.get('sort') as SortOption) || 'stars',
  );
  const [search, setSearch] = useState(searchParams.get('search') || '');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    getReposByList(slug, {
      sort,
      search: search || undefined,
      category: searchParams.get('category') || undefined,
      page,
      per_page: 50,
    })
      .then((res) => {
        setRepos(res.data);
        setTotal(res.meta.total);
      })
      .catch(() => {
        setRepos([]);
        setTotal(0);
      })
      .finally(() => setLoading(false));
  }, [slug, sort, search, page, searchParams]);

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">Repos</h1>
        <div className="flex gap-2">
          {(
            [
              ['stars', 'Stars'],
              ['trending_7d', '7d'],
              ['trending_30d', '30d'],
              ['trending_90d', '90d'],
            ] as const
          ).map(([value, label]) => (
            <button
              key={value}
              onClick={() => {
                setSort(value);
                setPage(1);
              }}
              className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-colors ${
                sort === value
                  ? 'bg-accent text-white'
                  : 'bg-surface border border-border text-muted hover:text-foreground'
              }`}
            >
              {label}
            </button>
          ))}
        </div>
      </div>

      <div className="mb-6">
        <input
          type="text"
          placeholder="Filter repos..."
          value={search}
          onChange={(e) => {
            setSearch(e.target.value);
            setPage(1);
          }}
          className="w-full max-w-md px-4 py-2 bg-background border border-border rounded-lg text-foreground placeholder-muted focus:outline-none focus:border-accent"
        />
      </div>

      {loading ? (
        <div className="text-center py-12 text-muted">Loading...</div>
      ) : (
        <>
          <p className="text-muted text-sm mb-4">
            {total} repos found
          </p>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border text-muted">
                  <th className="text-left py-3 px-2">Name</th>
                  <th className="text-left py-3 px-2">Category</th>
                  <th className="text-right py-3 px-2">Stars</th>
                  <th className="text-right py-3 px-2">7d</th>
                  <th className="text-right py-3 px-2">30d</th>
                  <th className="text-right py-3 px-2">90d</th>
                </tr>
              </thead>
              <tbody>
                {repos.map((item) => (
                  <tr
                    key={item.id}
                    className="border-b border-border hover:bg-surface-hover transition-colors"
                  >
                    <td className="py-3 px-2">
                      <Link
                        href={item.primaryUrl || '#'}
                        className="font-medium hover:text-accent"
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        {item.name || item.githubRepo}
                      </Link>
                      {(item.githubDescription || item.description) && (
                        <p className="text-muted text-xs mt-1 truncate max-w-sm">
                          {item.githubDescription || item.description}
                        </p>
                      )}
                    </td>
                    <td className="py-3 px-2 text-muted text-xs">
                      {item.category.name}
                    </td>
                    <td className="py-3 px-2 text-right font-mono">
                      {item.stars?.toLocaleString() ?? '-'}
                    </td>
                    <td
                      className={`py-3 px-2 text-right font-mono ${
                        item.repo?.stars7d && item.repo.stars7d > 0
                          ? 'text-success'
                          : item.repo?.stars7d && item.repo.stars7d < 0
                            ? 'text-danger'
                            : 'text-muted'
                      }`}
                    >
                      {item.repo?.stars7d
                        ? (item.repo.stars7d > 0 ? '+' : '') +
                          item.repo.stars7d
                        : ''}
                    </td>
                    <td
                      className={`py-3 px-2 text-right font-mono ${
                        item.repo?.stars30d && item.repo.stars30d > 0
                          ? 'text-success'
                          : item.repo?.stars30d && item.repo.stars30d < 0
                            ? 'text-danger'
                            : 'text-muted'
                      }`}
                    >
                      {item.repo?.stars30d
                        ? (item.repo.stars30d > 0 ? '+' : '') +
                          item.repo.stars30d
                        : ''}
                    </td>
                    <td
                      className={`py-3 px-2 text-right font-mono ${
                        item.repo?.stars90d && item.repo.stars90d > 0
                          ? 'text-success'
                          : item.repo?.stars90d && item.repo.stars90d < 0
                            ? 'text-danger'
                            : 'text-muted'
                      }`}
                    >
                      {item.repo?.stars90d
                        ? (item.repo.stars90d > 0 ? '+' : '') +
                          item.repo.stars90d
                        : ''}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {total > 50 && (
            <div className="flex justify-center gap-2 mt-6">
              <button
                onClick={() => setPage((p) => Math.max(1, p - 1))}
                disabled={page === 1}
                className="px-4 py-2 bg-surface border border-border rounded-lg text-sm disabled:opacity-50"
              >
                Previous
              </button>
              <span className="px-4 py-2 text-sm text-muted">
                Page {page} of {Math.ceil(total / 50)}
              </span>
              <button
                onClick={() => setPage((p) => p + 1)}
                disabled={page >= Math.ceil(total / 50)}
                className="px-4 py-2 bg-surface border border-border rounded-lg text-sm disabled:opacity-50"
              >
                Next
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}
