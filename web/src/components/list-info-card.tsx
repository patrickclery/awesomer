import { Star, BookMarked, Clock } from 'lucide-react';
import { GitHubIcon } from '@/components/github-icon';
import { cleanDescription } from '@/lib/text';
import { relativeTime } from '@/lib/relative-time';
import { generateAsciiBanner, displayName } from '@/lib/ascii-banner';

interface ListInfoCardProps {
  list: {
    name: string;
    githubRepo: string;          // "owner/repo" format
    description: string | null;
    lastCommitAt: string | null; // ISO timestamp
    repoCount: number;           // total CategoryItems tracked (currently unused — reserved for future stats)
    ownRepoStars: number | null; // AwesomeList.repo.stars
    slug: string;                // used only for unique <h1> id
  };
}

/**
 * Compact integer formatter matching repo-hero-card / repo-mini-card / sidebar-repo-list.
 */
function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

export function ListInfoCard({ list }: ListInfoCardProps) {
  const { name, githubRepo, description, lastCommitAt, repoCount, ownRepoStars, slug } = list;
  const owner = githubRepo.split('/')[0];
  const repoUrl = `https://github.com/${githubRepo}`;
  const listName = displayName(name);
  const cleanedDescription = cleanDescription(description);
  const friendlyTime = relativeTime(lastCommitAt);
  const ghLabel = `${name} on GitHub`;
  const headingId = `list-info-${slug}-name`;

  const { text: asciiText, fontSize } = generateAsciiBanner(name);

  return (
    <section
      className="py-2 sm:py-3"
      aria-labelledby={headingId}
    >
      {/* Accessible title — visual title is the ASCII figlet, which is aria-hidden */}
      <h1 id={headingId} className="sr-only">{listName}</h1>

      <div className="grid gap-6 md:grid-cols-3">
        {/* Left column — 2/3: ANSI figlet + description */}
        <div className="md:col-span-2 min-w-0">
          {/* Desktop figlet */}
          <div className="hidden sm:block overflow-hidden mb-3">
            <pre
              className="ascii-art text-accent"
              style={{ fontSize: `${fontSize}px` }}
              aria-hidden="true"
            >
              {asciiText}
            </pre>
          </div>

          {/* Mobile fallback — plain bold text instead of figlet */}
          <div
            className="sm:hidden text-accent text-2xl font-bold mb-3"
            aria-hidden="true"
          >
            {listName}
            <span className="cursor-blink">_</span>
          </div>

          {cleanedDescription && (
            <p className="text-sm font-mono text-muted leading-relaxed mb-[10px]">
              <span className="text-accent">&gt;</span> {cleanedDescription}
            </p>
          )}
        </div>

        {/* Right column — 1/3: tab header + attribution + stats panel */}
        <div className="flex flex-col mb-[10px]">
          <div
            className="self-start px-3 py-1 text-xs font-mono font-bold text-accent rounded-t-md"
            style={{ background: 'var(--surface)' }}
          >
            ## about
          </div>
          <aside
            className="flex flex-col gap-3 text-[11px] pl-4 py-4 pr-2 rounded-lg rounded-tl-none"
            style={{ background: 'color-mix(in srgb, var(--surface) 40%, transparent)' }}
          >
          {/* Stats — author first (avatar + full repo URI), then stars, repos, freshness */}
          <div
            role="list"
            aria-label="List statistics"
            className="flex flex-col gap-2"
          >
            {/* Author — avatar + full GitHub URI as the top row */}
            <a
              role="listitem"
              href={repoUrl}
              aria-label={`${name} on GitHub — curated by ${owner}`}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2 text-muted hover:text-foreground focus-visible:text-foreground transition-colors rounded-full focus-visible:outline-2 focus-visible:outline-accent min-w-0"
            >
              <GitHubIcon size={16} />
              <span className="text-foreground break-all">{githubRepo}</span>
            </a>

            <span
              role="listitem"
              className="inline-flex items-center gap-2"
              title="Stars on the awesome-list repo"
            >
              <Star className="w-4 h-4 text-accent" aria-hidden="true" />
              <span className="font-bold text-foreground">
                {ownRepoStars != null ? formatStars(ownRepoStars) : '—'}
              </span>
              <span className="text-muted">stars</span>
            </span>

            <span
              role="listitem"
              className="inline-flex items-center gap-2"
              title="Repositories tracked in this list"
            >
              <BookMarked className="w-4 h-4 text-muted" aria-hidden="true" />
              <span className="font-bold text-foreground">
                {repoCount.toLocaleString()}
              </span>
              <span className="text-muted">repos</span>
            </span>

            {lastCommitAt && friendlyTime && (
              <span
                role="listitem"
                className="inline-flex items-center gap-2"
                title={`Last commit ${new Date(lastCommitAt).toLocaleString()}`}
              >
                <Clock className="w-4 h-4 text-muted" aria-hidden="true" />
                <span className="text-muted">
                  Updated <time dateTime={lastCommitAt}>{friendlyTime}</time>
                </span>
              </span>
            )}
          </div>
          </aside>
        </div>
      </div>
    </section>
  );
}
