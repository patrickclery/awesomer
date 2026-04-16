'use client';

import Link from 'next/link';
import { repoPath } from '@/lib/routes';

interface TrendingRepo {
  id: number;
  githubRepo: string;
  description: string | null;
  stars: number | null;
  stars7d: number | null;
  stars30d: number | null;
  stars90d: number | null;
  categoryItems?: Array<{
    category: {
      name: string;
      slug: string;
      awesomeList?: {
        slug: string;
      };
    };
  }>;
}

interface TrendingTableProps {
  title: string;
  repos: TrendingRepo[];
  period: '7d' | '30d' | '90d';
  listSlug?: string;
  startRank?: number;
}

function formatDelta(value: number | null): string {
  if (value === null || value === undefined) return '';
  return value >= 0 ? `+${value.toLocaleString()}` : value.toLocaleString();
}

function formatStars(value: number | null): string {
  if (value === null || value === undefined) return '-';
  return value.toLocaleString();
}

export function TrendingTable({
  title,
  repos,
  period,
  listSlug,
  startRank,
}: TrendingTableProps) {
  const getDelta = (repo: TrendingRepo) => {
    switch (period) {
      case '7d':
        return repo.stars7d;
      case '30d':
        return repo.stars30d;
      case '90d':
        return repo.stars90d;
    }
  };

  return (
    <div>
      {title && (
        <div className="flex items-center gap-3 mb-3">
          <span className="text-muted text-xs font-mono tracking-wider">{title}</span>
          <span className="flex-1 h-px bg-border"></span>
        </div>
      )}
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border text-muted text-xs uppercase tracking-wider">
              <th className="text-left py-2 px-2 w-8">#</th>
              <th className="text-left py-2 px-2">repo</th>
              <th className="text-right py-2 px-2">stars</th>
              <th className="text-right py-2 px-2">{period}</th>
            </tr>
          </thead>
          <tbody>
            {repos.map((repo, index) => {
              const delta = getDelta(repo);
              const href = repoPath(repo.githubRepo);

              return (
                <tr
                  key={repo.id}
                  className="border-b border-border/50 hover:bg-surface transition-colors group"
                >
                  <td className="py-2.5 px-2 text-muted text-xs">
                    {String(index + (startRank ?? 1)).padStart(2, '0')}
                  </td>
                  <td className="py-2.5 px-2 max-w-0 w-full">
                    <Link href={href} className="group-hover:text-accent transition-colors">
                      <span>{repo.githubRepo.split('/')[1]}</span>
                    </Link>
                  </td>
                  <td className="py-2.5 px-2 text-right text-muted tabular-nums whitespace-nowrap">
                    {formatStars(repo.stars)}
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
                    {formatDelta(delta)}
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
