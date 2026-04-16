import Link from 'next/link';
import { repoPath } from '@/lib/routes';

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

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

export function FeaturedRepo({ repo, rank, listSlug }: FeaturedRepoProps) {
  const href = repoPath(repo.githubRepo);

  if (rank === 1) {
    return (
      <Link href={href} className="block cursor-pointer">
        <div className="card-featured p-5 sm:p-6 mb-4 group">
          <div className="flex items-start justify-between mb-3">
            <div className="flex-1 min-w-0">
              <div className="text-accent text-xs font-mono tracking-widest mb-2 glow">
                TRENDING #1
              </div>
              <h3 className="text-xl sm:text-2xl font-bold group-hover:text-accent transition-colors truncate">
                {repo.githubRepo.split('/')[1]}
              </h3>
            </div>
            <div className="text-right ml-4 shrink-0">
              <div className="text-xl font-bold text-accent glow">
                {repo.stars != null ? formatStars(repo.stars) : '-'}
              </div>
              <div className="text-xs text-muted">stars</div>
            </div>
          </div>
          {repo.description && (
            <p className="description text-muted text-sm mb-3 line-clamp-2">{repo.description}</p>
          )}
          {repo.stars7d != null && repo.stars7d > 0 && (
            <span className="stat-pill" style={{ background: 'rgba(0, 255, 65, 0.12)' }}>
              +{repo.stars7d.toLocaleString()} this week
            </span>
          )}
        </div>
      </Link>
    );
  }

  return (
    <Link href={href} className="block cursor-pointer">
      <div className={`card p-4 mb-4 group ${rank === 2 ? 'max-w-2xl' : 'max-w-xl'}`}>
        <div className="flex items-start justify-between">
          <div className="flex-1 min-w-0">
            <div className="flex items-baseline gap-2 mb-1">
              <span className="text-accent/60 text-xs font-mono">#{rank}</span>
              <span className={`${rank === 2 ? 'text-lg' : 'text-base'} font-bold group-hover:text-accent transition-colors truncate`}>
                {repo.githubRepo.split('/')[1]}
              </span>
            </div>
            {repo.description && (
              <p className="description text-muted text-xs mt-1 truncate max-w-md">
                {repo.description}
              </p>
            )}
          </div>
          <div className="text-right ml-4 shrink-0 text-sm">
            <span className="text-muted">{repo.stars != null ? formatStars(repo.stars) : '-'}</span>
            {repo.stars7d != null && repo.stars7d > 0 && (
              <div className="text-success text-xs mt-0.5">
                +{repo.stars7d.toLocaleString()}
              </div>
            )}
          </div>
        </div>
      </div>
    </Link>
  );
}
