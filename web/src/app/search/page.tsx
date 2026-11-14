'use client';

import { useSearchParams } from 'next/navigation';
import { Fragment, useState, useEffect, useMemo, Suspense } from 'react';
import Link, { siteAsset } from '@/components/site-link';
import { listPath, repoPath } from '@/lib/routes';
import { SEARCH_INDEX_PATH, searchRepos, type SearchIndex } from '@/lib/search';

const PER_PAGE = 25;

// One fetch per page load: the static site has no API, so search runs over this file in the browser.
let indexPromise: Promise<SearchIndex> | null = null;

function loadSearchIndex(): Promise<SearchIndex> {
  if (!indexPromise) {
    indexPromise = fetch(siteAsset(SEARCH_INDEX_PATH))
      .then((res) => {
        if (!res.ok) throw new Error(`search index: ${res.status} ${res.statusText}`);
        return res.json() as Promise<SearchIndex>;
      })
      .catch((error: unknown) => {
        indexPromise = null;
        throw error;
      });
  }
  return indexPromise;
}

function SearchResults() {
  const searchParams = useSearchParams();
  const query = searchParams.get('q') || '';
  const [index, setIndex] = useState<SearchIndex | null>(null);
  const [failed, setFailed] = useState(false);
  const [page, setPage] = useState(1);
  const [prevQuery, setPrevQuery] = useState(query);

  // A new query starts at page 1 and gets a fresh chance to load a previously failed index.
  if (prevQuery !== query) {
    setPrevQuery(query);
    setPage(1);
    setFailed(false);
  }

  useEffect(() => {
    if (!query.trim() || index || failed) return;
    let cancelled = false;
    loadSearchIndex()
      .then((loaded) => {
        if (!cancelled) setIndex(loaded);
      })
      .catch(() => {
        if (!cancelled) setFailed(true);
      });
    return () => {
      cancelled = true;
    };
  }, [query, index, failed]);

  const hits = useMemo(() => (index ? searchRepos(index, query) : []), [index, query]);
  const total = hits.length;
  const totalPages = Math.ceil(total / PER_PAGE);
  const results = hits.slice((page - 1) * PER_PAGE, page * PER_PAGE);

  if (!query) {
    return (
      <div className="py-8 text-muted text-sm">
        enter a search term to find repos across all verticals.
      </div>
    );
  }

  if (failed) {
    return <div className="py-8 text-muted text-sm">the search index could not be loaded. try again later.</div>;
  }

  if (!index) {
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
            const segment = item.githubRepo.split('/')[1] || item.githubRepo;

            return (
              <div
                key={item.githubRepo}
                className="py-2 px-3 border border-transparent hover:border-border hover:bg-surface transition-colors"
              >
                <div className="flex items-start justify-between">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <Link
                        href={repoPath(item.githubRepo)}
                        className="hover:text-accent transition-colors truncate"
                      >
                        {item.name || segment}
                      </Link>
                      <a
                        href={`https://github.com/${item.githubRepo}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-muted hover:text-accent text-xs flex-shrink-0"
                      >
                        [gh]
                      </a>
                    </div>
                    {item.memberships.length > 0 && (
                      <div className="flex flex-wrap gap-x-2 gap-y-1 mt-1 text-xs text-muted">
                        {item.memberships.map((m, i) => (
                          <Fragment key={`${m.listSlug}/${m.categorySlug}/${m.categoryName}`}>
                            {i > 0 && <span className="text-muted/50">·</span>}
                            <span className="flex gap-2">
                              <Link href={listPath(m.listSlug)} className="hover:text-accent">
                                {m.listName}
                              </Link>
                              <span className="text-muted/50">/</span>
                              <span>{m.categoryName}</span>
                            </span>
                          </Fragment>
                        ))}
                      </div>
                    )}
                  </div>
                  <div className="text-right text-xs ml-4 flex-shrink-0">
                    {item.stars !== null && (
                      <div className="text-muted">{item.stars.toLocaleString()}</div>
                    )}
                    {item.stars30d !== null && item.stars30d > 0 && (
                      <div className="text-success">
                        +{item.stars30d}/30d
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

      {total > PER_PAGE && (
        <div className="flex items-center gap-2 mt-4 text-sm">
          <button
            onClick={() => setPage((p) => Math.max(1, p - 1))}
            disabled={page === 1}
            className="px-3 py-1 border border-border text-muted hover:text-foreground disabled:opacity-30 transition-colors"
          >
            prev
          </button>
          <span className="text-muted text-xs">
            [{page}/{totalPages}]
          </span>
          <button
            onClick={() => setPage((p) => p + 1)}
            disabled={page >= totalPages}
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
