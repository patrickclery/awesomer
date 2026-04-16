'use client';

import { useState, useEffect, useRef, useMemo, useCallback } from 'react';
import Link from 'next/link';
import type { CategoryItem } from '@/lib/api';
import { repoPath } from '@/lib/routes';

type SortMode = '7d' | 'stars';

interface CategoryInfo {
  id: number;
  name: string;
  slug: string;
  count: number;
}

interface AllReposSectionProps {
  items: CategoryItem[];
  categories: CategoryInfo[];
  listSlug: string;
}

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

interface DeduplicatedRepo {
  item: CategoryItem;
  categoryIds: Set<number>;
  key: string;
}

export function AllReposSection({ items, categories, listSlug }: AllReposSectionProps) {
  const [selectedCategories, setSelectedCategories] = useState<Set<number>>(
    () => new Set(categories.map((c) => c.id))
  );
  const [expanded, setExpanded] = useState(false);
  const [showBar, setShowBar] = useState(false);
  const [sortMode, setSortMode] = useState<SortMode>('7d');
  const sentinelRef = useRef<HTMLDivElement>(null);
  const barRef = useRef<HTMLDivElement>(null);
  const hasBeenVisible = useRef(false);

  // Show floating bar only after the sentinel has been visible then scrolls out
  useEffect(() => {
    const sentinel = sentinelRef.current;
    if (!sentinel) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          // Sentinel is visible — user has scrolled down to the section
          hasBeenVisible.current = true;
          setShowBar(false);
          setExpanded(false);
        } else if (hasBeenVisible.current) {
          // Sentinel scrolled out after being visible — show the bar
          // Only show when sentinel is ABOVE viewport (user scrolled past it)
          const rect = sentinel.getBoundingClientRect();
          if (rect.top < 0) {
            setShowBar(true);
          } else {
            setShowBar(false);
          }
        }
      },
      { threshold: 0 }
    );

    observer.observe(sentinel);
    return () => observer.disconnect();
  }, []);

  // Close expanded filter on click outside
  useEffect(() => {
    if (!expanded) return;
    const handleClick = (e: MouseEvent) => {
      if (barRef.current && !barRef.current.contains(e.target as Node)) {
        setExpanded(false);
      }
    };
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, [expanded]);

  // Close on Escape
  useEffect(() => {
    if (!expanded) return;
    const handleKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') setExpanded(false);
    };
    document.addEventListener('keydown', handleKey);
    return () => document.removeEventListener('keydown', handleKey);
  }, [expanded]);

  // Category lookup
  const categoryNameMap = useMemo(
    () => new Map(categories.map((c) => [c.id, c.name])),
    [categories]
  );

  const sortedCategories = useMemo(
    () => [...categories].sort((a, b) => a.name.localeCompare(b.name)),
    [categories]
  );

  // Deduplicate repos, collecting all categories per repo
  const repos: DeduplicatedRepo[] = useMemo(() => {
    const repoMap = new Map<string, DeduplicatedRepo>();

    for (const item of items) {
      const key = item.githubRepo || item.name || String(item.id);
      if (!repoMap.has(key)) {
        repoMap.set(key, { item, categoryIds: new Set(), key });
      }
      repoMap.get(key)!.categoryIds.add(item.category.id);
    }

    return Array.from(repoMap.values());
  }, [items]);

  // Filter and sort
  const filteredRepos = useMemo(() => {
    return repos
      .filter((r) => [...r.categoryIds].some((id) => selectedCategories.has(id)))
      .sort((a, b) => {
        if (sortMode === '7d') {
          return (
            (b.item.repo?.stars7d ?? 0) - (a.item.repo?.stars7d ?? 0) ||
            (b.item.stars ?? 0) - (a.item.stars ?? 0)
          );
        }
        return (b.item.stars ?? 0) - (a.item.stars ?? 0);
      });
  }, [repos, selectedCategories, sortMode]);

  const allSelected = selectedCategories.size === categories.length;
  const noneSelected = selectedCategories.size === 0;

  const selectAll = useCallback(
    () => setSelectedCategories(new Set(categories.map((c) => c.id))),
    [categories]
  );
  const selectNone = useCallback(() => setSelectedCategories(new Set()), []);
  const toggleCategory = useCallback((id: number) => {
    setSelectedCategories((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }, []);

  // Shared pill grid renderer
  const renderCategoryPills = (compact?: boolean) => (
    <div className={`grid ${compact ? 'grid-cols-2 sm:grid-cols-3' : 'grid-cols-2 sm:grid-cols-3 md:grid-cols-4'} gap-1.5`}>
      {sortedCategories.map((cat) => (
        <button
          key={cat.id}
          onClick={() => toggleCategory(cat.id)}
          className={`flex items-center justify-between px-2 py-1.5 text-xs font-mono border transition-colors cursor-pointer text-left ${
            selectedCategories.has(cat.id)
              ? 'border-accent/50 text-accent bg-accent/8'
              : 'border-border text-muted/60 hover:border-accent/30 hover:text-foreground'
          }`}
        >
          <span className="truncate">{cat.name}</span>
          <span className="ml-1.5 opacity-50 shrink-0">{cat.count}</span>
        </button>
      ))}
    </div>
  );

  return (
    <div>
      {/* Sentinel — triggers floating bar when it scrolls out of view */}
      <div ref={sentinelRef} />

      {/* Section header */}
      <div className="flex items-center gap-3 mb-4">
        <span className="text-accent text-xs font-mono tracking-widest">ALL REPOS</span>
        <span className="flex-1 h-px bg-border"></span>
        <span className="text-muted text-xs">
          {filteredRepos.length} of {repos.length} repos
        </span>
      </div>

      {/* Inline filter controls (visible at section start) */}
      <div className="mb-4">
        <div className="flex items-center gap-2 mb-3">
          <button
            onClick={selectAll}
            className={`px-2.5 py-1 text-xs font-mono border transition-colors cursor-pointer ${
              allSelected
                ? 'border-accent text-accent bg-accent/10'
                : 'border-border text-muted hover:border-accent/50 hover:text-foreground'
            }`}
          >
            All
          </button>
          <button
            onClick={selectNone}
            className={`px-2.5 py-1 text-xs font-mono border transition-colors cursor-pointer ${
              noneSelected
                ? 'border-accent text-accent bg-accent/10'
                : 'border-border text-muted hover:border-accent/50 hover:text-foreground'
            }`}
          >
            None
          </button>
          <span className="text-muted text-xs ml-2">
            {selectedCategories.size} of {categories.length} categories
          </span>
        </div>
        {renderCategoryPills()}
      </div>

      {/* Floating filter bar — appears when inline controls scroll out of view */}
      <div
        ref={barRef}
        className={`fixed left-0 right-0 z-40 transition-all duration-300 ease-out ${
          showBar
            ? 'translate-y-0 opacity-100'
            : '-translate-y-4 opacity-0 pointer-events-none'
        }`}
        style={{ top: '48px' }}
      >
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
          <div
            className="border border-border/80 bg-background/95 backdrop-blur-md"
            style={{ boxShadow: '0 8px 32px rgba(0, 0, 0, 0.6), 0 0 1px rgba(0, 255, 65, 0.1)' }}
          >
            {/* Compact bar */}
            <div
              role="button"
              tabIndex={0}
              onClick={() => setExpanded(!expanded)}
              onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') setExpanded(!expanded); }}
              className="flex items-center justify-between px-4 py-2 cursor-pointer select-none"
            >
              <div className="flex items-center gap-3">
                <span className="text-accent text-xs font-mono tracking-widest">
                  {expanded ? '\u25B2' : '\u25BC'} CATEGORIES
                </span>
                <span className="text-muted text-xs">
                  {allSelected
                    ? 'all selected'
                    : noneSelected
                      ? 'none selected'
                      : `${selectedCategories.size} of ${categories.length}`}
                </span>
                <span className="text-muted/40 text-xs hidden sm:inline">
                  {filteredRepos.length} repos shown
                </span>
              </div>
              <div className="flex items-center gap-1.5">
                <button
                  onClick={(e) => { e.stopPropagation(); selectAll(); }}
                  className={`px-2 py-0.5 text-xs font-mono border transition-colors cursor-pointer ${
                    allSelected
                      ? 'border-accent/60 text-accent'
                      : 'border-border text-muted hover:text-foreground hover:border-accent/40'
                  }`}
                >
                  All
                </button>
                <button
                  onClick={(e) => { e.stopPropagation(); selectNone(); }}
                  className={`px-2 py-0.5 text-xs font-mono border transition-colors cursor-pointer ${
                    noneSelected
                      ? 'border-accent/60 text-accent'
                      : 'border-border text-muted hover:text-foreground hover:border-accent/40'
                  }`}
                >
                  None
                </button>
              </div>
            </div>

            {/* Expanded pill grid */}
            <div
              className={`overflow-hidden transition-all duration-300 ease-out ${
                expanded ? 'max-h-[60vh] opacity-100' : 'max-h-0 opacity-0'
              }`}
            >
              <div className="px-4 pb-3 border-t border-border/50">
                <div className="mt-2.5 max-h-[50vh] overflow-y-auto">
                  {renderCategoryPills(true)}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Sort controls */}
      <div className="flex items-center gap-3 mb-3 mt-6">
        <span className="text-muted text-xs">sort:</span>
        <button
          onClick={() => setSortMode('7d')}
          className={`text-xs font-mono transition-colors cursor-pointer ${
            sortMode === '7d' ? 'text-accent' : 'text-muted hover:text-foreground'
          }`}
        >
          trending{sortMode === '7d' ? ' \u2193' : ''}
        </button>
        <button
          onClick={() => setSortMode('stars')}
          className={`text-xs font-mono transition-colors cursor-pointer ${
            sortMode === 'stars' ? 'text-accent' : 'text-muted hover:text-foreground'
          }`}
        >
          stars{sortMode === 'stars' ? ' \u2193' : ''}
        </button>
        <span className="flex-1 h-px bg-border"></span>
      </div>

      {/* Repo list */}
      {noneSelected ? (
        <div className="py-12 text-center text-muted text-sm">
          no categories selected.{' '}
          <button onClick={selectAll} className="text-accent hover:underline cursor-pointer">
            select all
          </button>
        </div>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-muted text-xs uppercase tracking-wider">
                <th className="text-left py-2 px-2 w-full">repo</th>
                <th className="text-right py-2 px-2">stars</th>
                <th className="text-right py-2 px-2">7d</th>
              </tr>
            </thead>
            <tbody>
              {filteredRepos.map((r) => {
                const { item, categoryIds } = r;
                const href = item.githubRepo
                  ? repoPath(item.githubRepo)
                  : item.primaryUrl || '#';
                const isExternal = !item.githubRepo;
                const delta = item.repo?.stars7d;

                return (
                  <tr
                    key={r.key}
                    className="border-b border-border/50 hover:bg-surface transition-colors group"
                  >
                    <td className="py-2.5 px-2 max-w-0 w-full">
                      <div className="flex items-center gap-2">
                        <Link
                          href={href}
                          className="group-hover:text-accent transition-colors shrink-0"
                          {...(isExternal
                            ? { target: '_blank', rel: 'noopener noreferrer' }
                            : {})}
                        >
                          {item.githubRepo
                            ? item.githubRepo.split('/')[1]
                            : item.name}
                        </Link>
                        <div className="flex gap-1 shrink-0">
                          {[...categoryIds].slice(0, 2).map((catId) => (
                            <span
                              key={catId}
                              className="px-1.5 py-px text-[10px] font-mono border border-accent/20 text-accent/60 bg-accent/5 whitespace-nowrap"
                            >
                              {categoryNameMap.get(catId)}
                            </span>
                          ))}
                          {categoryIds.size > 2 && (
                            <span className="px-1 py-px text-[10px] font-mono text-muted/50">
                              +{categoryIds.size - 2}
                            </span>
                          )}
                        </div>
                      </div>
                    </td>
                    <td className="py-2.5 px-2 text-right text-muted tabular-nums whitespace-nowrap">
                      {item.stars != null ? formatStars(item.stars) : '\u2014'}
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
      )}
    </div>
  );
}
