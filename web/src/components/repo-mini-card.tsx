import Link from 'next/link';
import { repoPath } from '@/lib/routes';
import { Star } from 'lucide-react';
import { ExternalGitHubLink } from '@/components/external-github-link';
import { OwnerAvatar } from '@/components/owner-avatar';
import { cleanDescription } from '@/lib/text';

interface RepoMiniCardProps {
  repo: {
    id: number;
    githubRepo: string;
    description: string | null;
    stars: number | null;
    stars7d: number | null;
  };
  rank: number;
}

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

function formatDelta(value: number): string {
  if (value === 0) return '0';
  return value >= 0 ? `+${value.toLocaleString()}` : value.toLocaleString();
}

export function RepoMiniCard({ repo, rank }: RepoMiniCardProps) {
  const description = cleanDescription(repo.description);
  return (
    <div className="card-mini p-3 sm:p-4 h-full group relative overflow-hidden flex-1">
      {/* Watermark rank number */}
      <span className="absolute -right-1 -bottom-3 text-7xl font-black font-mono text-accent/[0.07] select-none pointer-events-none leading-none">
        {rank}
      </span>
      <div className="relative">
        <div className="flex items-center gap-2 min-w-0">
          <OwnerAvatar owner={repo.githubRepo.split('/')[0]} size={24} />
          <Link
            href={repoPath(repo.githubRepo)}
            className="truncate cursor-pointer rounded focus-visible:outline-2 focus-visible:outline-accent min-w-0"
          >
            <h3 className="inline text-sm font-bold group-hover:text-accent transition-colors">
              {repo.githubRepo.split('/')[1]}
            </h3>
          </Link>
        </div>
        {description && (
          <p className="description text-muted text-xs mt-0.5">{description}</p>
        )}
        {/* Bottom metric row: delta · stars · github */}
        <div className="flex items-center gap-3 mt-2 text-xs">
          {repo.stars7d != null && repo.stars7d > 0 && (
            <span className="font-bold text-success">
              +{repo.stars7d.toLocaleString()}
            </span>
          )}
          <span className="inline-flex items-center gap-1 text-muted">
            <Star className="w-3 h-3 text-accent" aria-hidden="true" />
            <span className="font-bold text-foreground">
              {repo.stars != null ? formatStars(repo.stars) : '—'}
            </span>
          </span>
          <ExternalGitHubLink
            githubRepo={repo.githubRepo}
            size={12}
            label={`${repo.githubRepo.split('/')[1]} on GitHub`}
          />
        </div>
      </div>
    </div>
  );
}
