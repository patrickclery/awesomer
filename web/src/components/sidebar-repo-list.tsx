import Link from 'next/link';
import { Star } from 'lucide-react';
import { repoPath, listAllPath } from '@/lib/routes';
import { GitHubIcon } from '@/components/github-icon';
import { OwnerAvatar } from '@/components/owner-avatar';
import { cleanDescription } from '@/lib/text';

interface SidebarRepo {
  id: number;
  githubRepo: string;
  description?: string | null;
  stars?: number | null;
  stars7d: number | null;
}

interface SidebarRepoListProps {
  repos: SidebarRepo[];
  listSlug: string;
  hasMore: boolean;
}

function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

export function SidebarRepoList({ repos, listSlug, hasMore }: SidebarRepoListProps) {
  return (
    <div>
      <div className="flex flex-col gap-0.5">
        {repos.map((repo, i) => (
          <Link
            key={repo.id}
            href={repoPath(repo.githubRepo)}
            className="block card-tiny px-2.5 py-2 group relative overflow-hidden"
          >
            {/* Rank watermark */}
            <span className="absolute -right-1 -bottom-2 text-4xl font-black font-mono text-accent/[0.07] select-none pointer-events-none leading-none">
              {i + 6}
            </span>
            {/* Line 1: avatar + (title + description) */}
            <div className="flex items-center gap-2 min-w-0 relative">
              <OwnerAvatar owner={repo.githubRepo.split('/')[0]} size={20} />
              <div className="flex items-baseline gap-1.5 min-w-0 flex-1">
                <span className="text-xs font-bold group-hover:text-accent transition-colors truncate shrink-0">
                  {repo.githubRepo.split('/')[1]}
                </span>
                {cleanDescription(repo.description) && (
                  <span className="description text-[11px] text-muted truncate min-w-0">
                    {cleanDescription(repo.description)}
                  </span>
                )}
              </div>
            </div>
            {/* Line 2: metrics + github icon */}
            <div className="flex items-center gap-3 mt-1 text-[11px] relative">
              {repo.stars7d != null && repo.stars7d > 0 && (
                <span className="font-bold text-success">
                  +{repo.stars7d.toLocaleString()}
                </span>
              )}
              {repo.stars != null && (
                <span className="inline-flex items-center gap-1 text-muted">
                  <Star className="w-3 h-3 text-accent" aria-hidden="true" />
                  <span className="font-bold text-foreground">{formatStars(repo.stars)}</span>
                </span>
              )}
              <GitHubIcon size={11} className="text-muted group-hover:text-foreground transition-colors" />
            </div>
          </Link>
        ))}
        {hasMore && (
          <Link
            href={listAllPath(listSlug)}
            className="text-xs text-muted hover:text-accent transition-colors text-center py-2 mt-1"
          >
            view all &rarr;
          </Link>
        )}
      </div>
    </div>
  );
}
