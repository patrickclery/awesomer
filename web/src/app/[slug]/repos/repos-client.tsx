'use client';

import { useState, useEffect } from 'react';
import { useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { getReposByList, type CategoryItem } from '@/lib/api';

type SortOption = 'stars' | 'trending_7d' | 'trending_30d' | 'trending_90d';

export default function ReposClient({ slug }: { slug: string }) {
  const searchParams = useSearchParams();

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
        <h1 className="text-xl font-bold">$ ls repos/</h1>
        <div className="flex gap-1">
          {(
            [
              ['stars', 'stars'],
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
              className={`px-3 py-1 text-xs transition-colors ${
                sort === value
                  ? 'border border-accent text-accent'
                  : 'border border-border text-muted hover:text-foreground hover:border-muted'
              }`}
            >
              {label}
            </button>
          ))}
        </div>
      </div>

      <div className="mb-6">
        <div className="flex items-center border border-border max-w-md">
          <span className="pl-3 text-muted text-sm">&gt;</span>
          <input
            type="text"
            placeholder="filter..."
            value={search}
            onChange={(e) => {
              setSearch(e.target.value);
              setPage(1);
            }}
            className="w-full px-2 py-1.5 bg-transparent text-foreground text-sm placeholder-muted focus:outline-none"
          />
        </div>
      </div>

      {loading ? (
        <div className="py-8 text-muted text-sm">loading...</div>
      ) : (
        <>
          <p className="text-muted text-xs mb-3">
            {total} results
          </p>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border text-muted text-xs uppercase tracking-wider">
                  <th className="text-left py-2 px-2">name</th>
                  <th className="text-left py-2 px-2">category</th>
                  <th className="text-right py-2 px-2">stars</th>
                  <th className="text-right py-2 px-2">7d</th>
                  <th className="text-right py-2 px-2">30d</th>
                  <th className="text-right py-2 px-2">90d</th>
                </tr>
              </thead>
              <tbody>
                {repos.map((item) => (
                  <tr
                    key={item.id}
                    className="border-b border-border/50 hover:bg-surface transition-colors"
                  >
                    <td className="py-2 px-2">
                      <Link
                        href={item.primaryUrl || '#'}
                        className="hover:text-accent transition-colors"
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        {item.name || item.githubRepo}
                      </Link>
                      {(item.githubDescription || item.description) && (
                        <p className="text-muted text-xs mt-0.5 truncate max-w-sm">
                          {item.githubDescription || item.description}
                        </p>
                      )}
                    </td>
                    <td className="py-2 px-2 text-muted text-xs">
                      {item.category.name}
                    </td>
                    <td className="py-2 px-2 text-right text-muted">
                      {item.stars?.toLocaleString() ?? '-'}
                    </td>
                    <td
                      className={`py-2 px-2 text-right ${
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
                      className={`py-2 px-2 text-right ${
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
                      className={`py-2 px-2 text-right ${
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
            <div className="flex items-center gap-2 mt-4 text-sm">
              <button
                onClick={() => setPage((p) => Math.max(1, p - 1))}
                disabled={page === 1}
                className="px-3 py-1 border border-border text-muted hover:text-foreground disabled:opacity-30 transition-colors"
              >
                prev
              </button>
              <span className="text-muted text-xs">
                [{page}/{Math.ceil(total / 50)}]
              </span>
              <button
                onClick={() => setPage((p) => p + 1)}
                disabled={page >= Math.ceil(total / 50)}
                className="px-3 py-1 border border-border text-muted hover:text-foreground disabled:opacity-30 transition-colors"
              >
                next
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}
