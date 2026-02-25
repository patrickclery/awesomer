import Link from 'next/link';

interface TrendingRepo {
  id: number;
  githubRepo: string;
  description: string | null;
  stars: number | null;
  stars7d: number | null;
}

interface FeaturedRepoProps {
  repo: TrendingRepo;
  rank: 1 | 2 | 3;
  listSlug: string;
}

export function FeaturedRepo({ repo, rank, listSlug }: FeaturedRepoProps) {
  const repoSlug = repo.githubRepo.replace('/', '~');
  const href = `/${listSlug}/repos/${repoSlug}`;

  const sizeClasses = {
    1: 'p-6 border-2 border-accent',
    2: 'p-4 border border-accent/60 max-w-2xl',
    3: 'p-3 border border-accent/30 max-w-xl',
  };

  const titleClasses = {
    1: 'text-xl font-bold',
    2: 'text-lg font-bold',
    3: 'text-base font-bold',
  };

  return (
    <div className={`${sizeClasses[rank]} bg-surface mb-4`}>
      <div className="flex items-baseline gap-2 mb-1">
        <span className="text-accent text-xs font-mono">
          #{rank}
        </span>
        <Link href={href} className={`${titleClasses[rank]} hover:text-accent transition-colors`}>
          {repo.githubRepo}
        </Link>
      </div>

      {rank <= 2 && repo.description && (
        <p className={`text-muted text-sm mb-2 ${rank === 2 ? 'truncate' : ''}`}>
          {repo.description}
        </p>
      )}

      <div className="flex items-center gap-4 text-sm">
        <span className="text-muted">
          {repo.stars?.toLocaleString() ?? '—'} ★
        </span>
        {repo.stars7d != null && repo.stars7d > 0 && (
          <span className="text-success">
            +{repo.stars7d.toLocaleString()} this week
          </span>
        )}
      </div>
    </div>
  );
}
