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

const RANK_LABELS = {
  1: '◆ TRENDING #1 ◆',
  2: '◈ TRENDING #2 ◈',
  3: '○ TRENDING #3 ○',
};

export function FeaturedRepo({ repo, rank, listSlug }: FeaturedRepoProps) {
  const repoSlug = repo.githubRepo.replace('/', '~');
  const href = `/${listSlug}/repos/${repoSlug}`;

  if (rank === 1) {
    return (
      <div className="mb-4 font-mono">
        <div className="text-accent/50 text-xs leading-none select-none">
          ╔══ {RANK_LABELS[1]} {'═'.repeat(44)}╗
        </div>
        <div className="terminal-box bg-surface px-6 py-4 border-x border-accent/50">
          <div className="flex items-baseline gap-3 mb-2">
            <span className="text-accent glow-intense text-sm font-bold tracking-widest">
              #{rank}
            </span>
            <Link href={href} className="text-xl font-bold hover:text-accent transition-colors glow">
              {repo.githubRepo}
            </Link>
          </div>
          {repo.description && (
            <p className="text-muted text-sm mb-3">{repo.description}</p>
          )}
          <div className="flex items-center gap-4 text-sm">
            <span className="text-muted">
              {repo.stars?.toLocaleString() ?? '—'} ★
            </span>
            {repo.stars7d != null && repo.stars7d > 0 && (
              <span className="text-success glow">
                +{repo.stars7d.toLocaleString()} this week
              </span>
            )}
          </div>
        </div>
        <div className="text-accent/50 text-xs leading-none select-none">
          ╚{'═'.repeat(68)}╝
        </div>
      </div>
    );
  }

  const sizeClasses = {
    2: 'p-4 border border-accent/40 max-w-2xl',
    3: 'p-3 border border-accent/20 max-w-xl',
  } as const;

  const titleClasses = {
    2: 'text-lg font-bold',
    3: 'text-base font-bold',
  } as const;

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
