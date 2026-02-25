'use client';

import { useSearchParams } from 'next/navigation';
import { useState, useEffect, Suspense } from 'react';
import Link from 'next/link';
import { searchGlobal } from '@/lib/api';

interface SearchResult {
  id: number;
  name: string | null;
  description: string | null;
  githubDescription: string | null;
  primaryUrl: string | null;
  githubRepo: string | null;
  stars: number | null;
  category: {
    id: number;
    name: string;
    slug: string;
    awesomeList?: { id: number; name: string; slug: string };
  };
  repo: {
    stars7d: number | null;
    stars30d: number | null;
    stars90d: number | null;
  } | null;
}

function SearchResults() {
  const searchParams = useSearchParams();
  const query = searchParams.get('q') || '';
  const [results, setResults] = useState<SearchResult[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [page, setPage] = useState(1);

  useEffect(() => {
    setPage(1);
  }, [query]);

  useEffect(() => {
    if (!query) {
      setResults([]);
      setTotal(0);
      return;
    }

    const debounce = setTimeout(() => {
      setLoading(true);
      searchGlobal(query, { page, per_page: 25 })
        .then((res) => {
          setResults(res.data);
          setTotal(res.meta.total);
        })
        .catch(() => {
          setResults([]);
          setTotal(0);
        })
        .finally(() => setLoading(false));
    }, 300);

    return () => clearTimeout(debounce);
  }, [query, page]);

  if (!query) {
    return (
      <div className="py-8 text-muted text-sm">
        enter a search term to find repos across all verticals.
      </div>
    );
  }

  if (loading) {
    return <div className="py-8 text-muted text-sm">searching...</div>;
  }

  return (
    <div>
      <h1 className="text-xl font-bold mb-1">
        $ search &quot;{query}&quot;
      </h1>
      <p className="text-muted text-xs mb-6">{total} results</p>

      {results.length > 0 ? (
        <div className="space-y-1">
          {results.map((item) => {
            const listSlug = item.category.awesomeList?.slug;
            const repoSlug = item.githubRepo?.replace('/', '~');

            return (
              <div
                key={item.id}
                className="py-2 px-3 border border-transparent hover:border-border hover:bg-surface transition-colors"
              >
                <div className="flex items-start justify-between">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <Link
                        href={
                          listSlug && repoSlug
                            ? `/${listSlug}/repos/${repoSlug}`
                            : item.primaryUrl || '#'
                        }
                        className="hover:text-accent transition-colors truncate"
                      >
                        {item.name || item.githubRepo}
                      </Link>
                      {item.primaryUrl && (
                        <a
                          href={item.primaryUrl}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="text-muted hover:text-accent text-xs flex-shrink-0"
                        >
                          [gh]
                        </a>
                      )}
                    </div>
                    <p className="text-muted text-xs mt-0.5 truncate">
                      {item.githubDescription || item.description}
                    </p>
                    <div className="flex gap-2 mt-1 text-xs text-muted">
                      {listSlug && (
                        <Link
                          href={`/${listSlug}`}
                          className="hover:text-accent"
                        >
                          {item.category.awesomeList?.name}
                        </Link>
                      )}
                      <span className="text-muted/50">/</span>
                      <span>{item.category.name}</span>
                    </div>
                  </div>
                  <div className="text-right text-xs ml-4 flex-shrink-0">
                    {item.stars !== null && (
                      <div className="text-muted">{item.stars.toLocaleString()}</div>
                    )}
                    {item.repo?.stars30d && item.repo.stars30d > 0 && (
                      <div className="text-success">
                        +{item.repo.stars30d}/30d
                      </div>
                    )}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      ) : (
        <div className="py-8 text-muted text-sm">
          no results for &quot;{query}&quot;.
        </div>
      )}

      {total > 25 && (
        <div className="flex items-center gap-2 mt-4 text-sm">
          <button
            onClick={() => setPage((p) => Math.max(1, p - 1))}
            disabled={page === 1}
            className="px-3 py-1 border border-border text-muted hover:text-foreground disabled:opacity-30 transition-colors"
          >
            prev
          </button>
          <span className="text-muted text-xs">
            [{page}/{Math.ceil(total / 25)}]
          </span>
          <button
            onClick={() => setPage((p) => p + 1)}
            disabled={page >= Math.ceil(total / 25)}
            className="px-3 py-1 border border-border text-muted hover:text-foreground disabled:opacity-30 transition-colors"
          >
            next
          </button>
        </div>
      )}
    </div>
  );
}

export default function SearchPage() {
  return (
    <Suspense
      fallback={<div className="py-8 text-muted text-sm">loading...</div>}
    >
      <SearchResults />
    </Suspense>
  );
}
