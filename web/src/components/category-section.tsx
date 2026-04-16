'use client';

import Link from 'next/link';
import { useState } from 'react';
import type { CategoryItem } from '@/lib/api';
import { repoPath } from '@/lib/routes';

type SortMode = '7d' | 'stars';

interface CategorySectionProps {
  number: number;
  name: string;
  slug: string;
  items: CategoryItem[];
  listSlug: string;
  totalStars: number;
}

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

export function CategorySection({
  number,
  name,
  slug,
  items,
  listSlug,
  totalStars,
}: CategorySectionProps) {
  const [sortMode, setSortMode] = useState<SortMode>('7d');
  const num = String(number).padStart(2, '0');

  const sorted = [...items].sort((a, b) => {
    if (sortMode === '7d') {
      return (b.repo?.stars7d ?? 0) - (a.repo?.stars7d ?? 0) || (b.stars ?? 0) - (a.stars ?? 0);
    }
    return (b.stars ?? 0) - (a.stars ?? 0);
  });

  return (
    <div id={`category-${slug}`} className="mb-10">
      <div className="flex items-center gap-3 mb-4">
        <span className="text-accent/50 text-xs font-mono">{num}</span>
        <span className="text-sm font-bold">{name}</span>
        <span className="text-xs text-muted">
          {items.length} repos · {formatStars(totalStars)} stars
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
                stars{sortMode === 'stars' ? ' ↓' : ''}
              </th>
              <th
                className={`text-right py-2 px-2 cursor-pointer select-none transition-colors ${
                  sortMode === '7d' ? 'text-accent' : 'hover:text-foreground'
                }`}
                onClick={() => setSortMode('7d')}
                title="Sort by 7-day trending"
              >
                7d{sortMode === '7d' ? ' ↓' : ''}
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
                  <td className="py-2.5 px-2">
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
                  <td className="py-2.5 px-2 text-right text-muted tabular-nums">
                    {item.stars?.toLocaleString() ?? '—'}
                  </td>
                  <td
                    className={`py-2.5 px-2 text-right tabular-nums ${
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
  );
}
