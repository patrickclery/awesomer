'use client';

import Link from 'next/link';
import { useState } from 'react';
import type { CategoryItem } from '@/lib/api';

type SortMode = '7d' | 'stars';

interface CategorySectionProps {
  number: number;
  name: string;
  slug: string;
  items: CategoryItem[];
  listSlug: string;
}

export function CategorySection({
  number,
  name,
  slug,
  items,
  listSlug,
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
      <div className="text-muted text-sm mb-3">
        ── {num}. {name} ({items.length}) ──
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
              const repoSlug = item.githubRepo
                ? item.githubRepo.replace('/', '~')
                : null;
              const href = repoSlug
                ? `/${listSlug}/repos/${repoSlug}`
                : item.primaryUrl || '#';
              const isExternal = !repoSlug;
              const delta = item.repo?.stars7d;

              return (
                <tr
                  key={item.id}
                  className="border-b border-border/50 hover:bg-surface transition-colors"
                >
                  <td className="py-2 px-2">
                    <Link
                      href={href}
                      className="hover:text-accent transition-colors"
                      {...(isExternal
                        ? { target: '_blank', rel: 'noopener noreferrer' }
                        : {})}
                    >
                      {item.githubRepo || item.name}
                    </Link>
                    {(item.githubDescription || item.description) && (
                      <p className="text-muted text-xs mt-0.5 truncate max-w-md">
                        {item.githubDescription || item.description}
                      </p>
                    )}
                  </td>
                  <td className="py-2 px-2 text-right text-muted">
                    {item.stars?.toLocaleString() ?? '—'}
                  </td>
                  <td
                    className={`py-2 px-2 text-right ${
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
