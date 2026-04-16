'use client';

import { useState } from 'react';
import Link from 'next/link';
import type { CategoryItem } from '@/lib/api';
import { repoPath } from '@/lib/routes';

type SortMode = '7d' | 'stars';

interface CategoryData {
  id: number;
  name: string;
  slug: string;
  items: CategoryItem[];
  totalStars: number;
}

interface CategoryBrowserProps {
  categories: CategoryData[];
  listSlug: string;
}

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

export function CategoryBrowser({ categories, listSlug }: CategoryBrowserProps) {
  const [selectedId, setSelectedId] = useState<number>(categories[0]?.id ?? 0);
  const [sortMode, setSortMode] = useState<SortMode>('7d');

  const selected = categories.find((c) => c.id === selectedId);

  const sorted = selected
    ? [...selected.items].sort((a, b) => {
        if (sortMode === '7d') {
          return (b.repo?.stars7d ?? 0) - (a.repo?.stars7d ?? 0) || (b.stars ?? 0) - (a.stars ?? 0);
        }
        return (b.stars ?? 0) - (a.stars ?? 0);
      })
    : [];

  return (
    <div>
      {/* Section header */}
      <div className="flex items-center gap-3 mb-4">
        <span className="text-accent text-xs font-mono tracking-widest">CATEGORIES</span>
        <span className="flex-1 h-px bg-border"></span>
        <span className="text-muted text-xs">{categories.length} total</span>
      </div>

      {/* Category chips */}
      <div className="flex flex-wrap gap-2 mb-6">
        {categories.map((cat) => (
          <button
            key={cat.id}
            onClick={() => { setSelectedId(cat.id); setSortMode('7d'); }}
            className={`px-3 py-1.5 text-xs font-mono border transition-colors cursor-pointer ${
              cat.id === selectedId
                ? 'border-accent text-accent bg-accent/10'
                : 'border-border text-muted hover:border-accent/50 hover:text-foreground'
            }`}
          >
            {cat.name}
            <span className="ml-1.5 opacity-60">({cat.items.length})</span>
          </button>
        ))}
      </div>

      {/* Selected category table */}
      {selected && (
        <div>
          <div className="flex items-center gap-3 mb-3">
            <span className="text-sm font-bold">{selected.name}</span>
            <span className="text-xs text-muted">
              {selected.items.length} repos · {formatStars(selected.totalStars)} stars
            </span>
            <span className="flex-1 h-px bg-border"></span>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border text-muted text-xs uppercase tracking-wider">
                  <th className="text-left py-2 px-2">repo</th>
                  <th
                    className={`text-right py-2 px-2 cursor-pointer select-none transition-colors ${
                      sortMode === 'stars' ? 'text-accent' : 'hover:text-foreground'
                    }`}
                    onClick={() => setSortMode('stars')}
                    title="Sort by star count"
                  >
                    stars{sortMode === 'stars' ? ' \u2193' : ''}
                  </th>
                  <th
                    className={`text-right py-2 px-2 cursor-pointer select-none transition-colors ${
                      sortMode === '7d' ? 'text-accent' : 'hover:text-foreground'
                    }`}
                    onClick={() => setSortMode('7d')}
                    title="Sort by 7-day trending"
                  >
                    7d{sortMode === '7d' ? ' \u2193' : ''}
                  </th>
                </tr>
              </thead>
              <tbody>
                {sorted.map((item) => {
                  const href = item.githubRepo
                    ? repoPath(item.githubRepo)
                    : item.primaryUrl || '#';
                  const isExternal = !item.githubRepo;
                  const delta = item.repo?.stars7d;

                  return (
                    <tr
                      key={item.id}
                      className="border-b border-border/50 hover:bg-surface transition-colors group"
                    >
                      <td className="py-2.5 px-2 max-w-0 w-full">
                        <Link
                          href={href}
                          className="group-hover:text-accent transition-colors"
                          {...(isExternal
                            ? { target: '_blank', rel: 'noopener noreferrer' }
                            : {})}
                        >
                          {item.githubRepo
                            ? item.githubRepo.split('/')[1]
                            : item.name}
                        </Link>
                      </td>
                      <td className="py-2.5 px-2 text-right text-muted tabular-nums whitespace-nowrap">
                        {item.stars?.toLocaleString() ?? '\u2014'}
                      </td>
                      <td
                        className={`py-2.5 px-2 text-right tabular-nums whitespace-nowrap ${
                          delta && delta > 0
                            ? 'text-success'
                            : delta && delta < 0
                              ? 'text-danger'
                              : 'text-muted'
                        }`}
                      >
                        {delta
                          ? (delta > 0 ? '+' : '') + delta.toLocaleString()
                          : ''}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
