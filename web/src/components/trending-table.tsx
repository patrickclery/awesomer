'use client';

import Link from 'next/link';

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
      <h2 className="text-lg font-semibold mb-4">{title}</h2>
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border text-muted">
              <th className="text-left py-3 px-2 w-8">#</th>
              <th className="text-left py-3 px-2">Repository</th>
              <th className="text-right py-3 px-2">Stars</th>
              <th className="text-right py-3 px-2">
                {period === '7d' ? '7d' : period === '30d' ? '30d' : '90d'}
              </th>
            </tr>
          </thead>
          <tbody>
            {repos.map((repo, index) => {
              const delta = getDelta(repo);
              const repoSlug = repo.githubRepo.replace('/', '-');
              const href = listSlug
                ? `/${listSlug}/repos/${repoSlug}`
                : `/${repo.categoryItems?.[0]?.category?.awesomeList?.slug || 'repos'}/${repoSlug}`;

              return (
                <tr
                  key={repo.id}
                  className="border-b border-border hover:bg-surface-hover transition-colors"
                >
                  <td className="py-3 px-2 text-muted">{index + 1}</td>
                  <td className="py-3 px-2">
                    <Link href={href} className="hover:text-accent">
                      <span className="font-medium">{repo.githubRepo}</span>
                    </Link>
                    {repo.description && (
                      <p className="text-muted text-xs mt-1 truncate max-w-md">
                        {repo.description}
                      </p>
                    )}
                  </td>
                  <td className="py-3 px-2 text-right font-mono">
                    {formatStars(repo.stars)}
                  </td>
                  <td
                    className={`py-3 px-2 text-right font-mono ${
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
