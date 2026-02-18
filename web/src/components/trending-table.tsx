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
      <div className="text-muted text-sm mb-3">--- {title} ---</div>
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
              const repoSlug = repo.githubRepo.replace('/', '-');
              const href = listSlug
                ? `/${listSlug}/repos/${repoSlug}`
                : `/${repo.categoryItems?.[0]?.category?.awesomeList?.slug || 'repos'}/${repoSlug}`;

              return (
                <tr
                  key={repo.id}
                  className="border-b border-border/50 hover:bg-surface transition-colors"
                >
                  <td className="py-2 px-2 text-muted text-xs">
                    {String(index + 1).padStart(2, '0')}
                  </td>
                  <td className="py-2 px-2">
                    <Link href={href} className="hover:text-accent transition-colors">
                      <span>{repo.githubRepo}</span>
                    </Link>
                    {repo.description && (
                      <p className="text-muted text-xs mt-0.5 truncate max-w-md">
                        {repo.description}
                      </p>
                    )}
                  </td>
                  <td className="py-2 px-2 text-right text-muted">
                    {formatStars(repo.stars)}
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
