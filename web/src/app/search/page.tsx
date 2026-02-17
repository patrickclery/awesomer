'use client';

import { useSearchParams } from 'next/navigation';
import { useState, useEffect, Suspense } from 'react';
import Link from 'next/link';
import { getReposByList, type CategoryItem } from '@/lib/api';

function SearchResults() {
  const searchParams = useSearchParams();
  const query = searchParams.get('q') || '';
  const [results, setResults] = useState<CategoryItem[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!query) return;
    setLoading(true);
    // Search across all lists — for now search the first available
    // This will be improved with a dedicated search endpoint
    getReposByList('awesome-claude-code', { search: query, per_page: 50 })
      .then((res) => setResults(res.data))
      .catch(() => setResults([]))
      .finally(() => setLoading(false));
  }, [query]);

  if (!query) {
    return (
      <div className="text-center py-12 text-muted">
        Enter a search term to find repos.
      </div>
    );
  }

  if (loading) {
    return <div className="text-center py-12 text-muted">Searching...</div>;
  }

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">
        Search results for &quot;{query}&quot;
      </h1>
      {results.length > 0 ? (
        <div className="space-y-3">
          {results.map((item) => (
            <div
              key={item.id}
              className="p-4 bg-surface border border-border rounded-lg"
            >
              <div className="flex items-start justify-between">
                <div>
                  <Link
                    href={item.primaryUrl || '#'}
                    className="font-medium hover:text-accent"
                    target="_blank"
                    rel="noopener noreferrer"
                  >
                    {item.name || item.githubRepo}
                  </Link>
                  <p className="text-muted text-sm mt-1">
                    {item.githubDescription || item.description}
                  </p>
                  <p className="text-muted text-xs mt-2">
                    {item.category.name}
                  </p>
                </div>
                <div className="text-right font-mono text-sm">
                  {item.stars !== null && (
                    <span className="text-foreground">
                      {item.stars.toLocaleString()} stars
                    </span>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="text-center py-12 text-muted">
          No results found for &quot;{query}&quot;.
        </div>
      )}
    </div>
  );
}

export default function SearchPage() {
  return (
    <Suspense
      fallback={<div className="text-center py-12 text-muted">Loading...</div>}
    >
      <SearchResults />
    </Suspense>
  );
}
