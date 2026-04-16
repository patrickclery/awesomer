import { Star, BookMarked, Clock, List } from 'lucide-react';
import { GitHubIcon } from '@/components/github-icon';
import { relativeTime } from '@/lib/relative-time';
import { generateAsciiBanner, displayName } from '@/lib/ascii-banner';

interface HomeInfoCardProps {
  githubRepo: string;           // "patrickclery/awesomer" — hard-coded by caller
  description: string | null;   // the homepage tagline (pre-cleaned)
  stars: number | null;         // stars on the awesomer repo itself (from GitHub API)
  listCount: number;            // lists.length
  repoCount: number;            // sum of all list.repoCount across tracked lists
  lastCommitAt: string | null;  // ISO timestamp or null — awesomer repo pushed_at, for "Updated X ago"
}

/**
 * Compact integer formatter matching repo-hero-card / repo-mini-card / sidebar-repo-list.
 */
function formatStars(value: number): string {
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}k`;
  return value.toLocaleString();
}

export function HomeInfoCard({
  githubRepo,
  description,
  stars,
  listCount,
  repoCount,
  lastCommitAt
}: HomeInfoCardProps) {
  const listName = displayName('awesomer');
  const { text: asciiText, fontSize } = generateAsciiBanner('awesomer');
  const friendlyTime = relativeTime(lastCommitAt);
  const headingId = 'home-info-awesomer-name';

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

          {description && (
            <p className="text-sm font-mono text-muted leading-relaxed mb-[10px]">
              <span className="text-accent">&gt;</span> {description}
            </p>
          )}
        </div>

        {/* Right column — 1/3: tab header + stats panel */}
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
            {/* Stats — GitHub → Lists → Stars → Repos → Updated */}
            <div
              role="list"
              aria-label="Awesomer statistics"
              className="flex flex-col gap-2"
            >
              {/* GitHub row */}
              <a
                role="listitem"
                href={`https://github.com/${githubRepo}`}
                aria-label={`Awesomer on GitHub — ${githubRepo}`}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 text-muted hover:text-foreground focus-visible:text-foreground transition-colors rounded-full focus-visible:outline-2 focus-visible:outline-accent min-w-0"
              >
                <GitHubIcon size={16} />
                <span className="text-foreground break-all">{githubRepo}</span>
              </a>

              {/* Awesome lists row */}
              <span
                role="listitem"
                className="inline-flex items-center gap-2"
                title="Awesome lists tracked"
              >
                <List className="w-4 h-4 text-muted" aria-hidden="true" />
                <span className="font-bold text-foreground">
                  {listCount.toLocaleString()}
                </span>
                <span className="text-muted">awesome lists</span>
              </span>

              {/* Stars row — stars on the awesomer repo itself */}
              <span
                role="listitem"
                className="inline-flex items-center gap-2"
                title="Stars on the awesomer repo"
              >
                <Star className="w-4 h-4 text-accent" aria-hidden="true" />
                <span className="font-bold text-foreground">
                  {stars != null ? formatStars(stars) : '—'}
                </span>
                <span className="text-muted">stars</span>
              </span>

              {/* Repos row */}
              <span
                role="listitem"
                className="inline-flex items-center gap-2"
                title="Repositories tracked across all lists"
              >
                <BookMarked className="w-4 h-4 text-muted" aria-hidden="true" />
                <span className="font-bold text-foreground">
                  {repoCount.toLocaleString()}
                </span>
                <span className="text-muted">repos</span>
              </span>

              {/* Updated row — conditional — awesomer repo last push */}
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
