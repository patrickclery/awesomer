import Link from 'next/link';
import { repoPath } from '@/lib/routes';
import { Star } from 'lucide-react';
import { GitHubIcon } from '@/components/github-icon';
import { OwnerAvatar } from '@/components/owner-avatar';
import { cleanDescription } from '@/lib/text';

interface RepoHeroCardProps {
  repo: {
    id: number;
    githubRepo: string;
    description: string | null;
    stars: number | null;
    stars7d: number | null;
  };
}

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

export function RepoHeroCard({ repo }: RepoHeroCardProps) {
  const description = cleanDescription(repo.description);
  return (
    <Link href={repoPath(repo.githubRepo)} className="block cursor-pointer">
      <div className="card-featured card-pulse p-4 sm:p-5 h-full group relative flex flex-col">
        {/* Watermark rank */}
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <span className="absolute -right-2 -bottom-6 text-[10rem] font-black font-mono text-accent/[0.07] select-none leading-none">
            1
          </span>
        </div>
        {/* Hottest repo starburst badge */}
        <div className="starburst">
          <span className="starburst-text">
            HOTTEST
            <span className="starburst-sub">this week</span>
          </span>
        </div>
        <div className="flex items-center gap-3 mb-2">
          <OwnerAvatar owner={repo.githubRepo.split('/')[0]} size={40} />
          <h2 className="text-2xl sm:text-3xl font-bold gradient-text transition-opacity group-hover:opacity-90">
            {repo.githubRepo.split('/')[1]}
          </h2>
        </div>
        {description && (
          <p className="description text-muted text-sm mb-3 max-w-2xl">
            {description}
          </p>
        )}
        {/* Metric row: delta · stars · github */}
        <div className="flex items-center gap-4 text-sm">
          {repo.stars7d != null && repo.stars7d > 0 && (
            <span className="font-bold text-success">
              +{repo.stars7d.toLocaleString()}
            </span>
          )}
          <span className="inline-flex items-center gap-1.5 text-muted">
            <Star className="w-4 h-4 text-accent" aria-hidden="true" />
            <span className="font-bold text-foreground">
              {repo.stars != null ? formatStars(repo.stars) : '—'}
            </span>
          </span>
          <GitHubIcon size={16} className="text-muted group-hover:text-foreground transition-colors" />
        </div>
      </div>
    </Link>
  );
}
