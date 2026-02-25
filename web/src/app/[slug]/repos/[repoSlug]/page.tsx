import Link from 'next/link';
import { notFound } from 'next/navigation';
import StarChart from './star-chart';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000/api';

export async function generateStaticParams() {
  const res = await fetch(`${API_BASE}/sync/static/repo-slugs`);
  const { data } = await res.json();
  const buildSlug = process.env.BUILD_SLUG;
  const filtered = buildSlug
    ? data.filter((r: { listSlug: string }) => r.listSlug === buildSlug)
    : data;
  return filtered.map((r: { listSlug: string; repoSlug: string }) => ({
    slug: r.listSlug,
    repoSlug: r.repoSlug,
  }));
}

async function getRepoData(repoSlug: string) {
  // repoSlug is "owner~name" where / was replaced with ~
  const tildeIndex = repoSlug.indexOf('~');
  if (tildeIndex === -1) return null;
  const owner = repoSlug.substring(0, tildeIndex);
  const name = repoSlug.substring(tildeIndex + 1);

  const res = await fetch(`${API_BASE}/sync/static/repo/${owner}/${name}`);
  if (!res.ok) return null;
  const { data } = await res.json();
  return data;
}

function formatDelta(value: number | null) {
  if (value === null || value === 0) return '-';
  return value > 0 ? `+${value.toLocaleString()}` : value.toLocaleString();
}

export default async function RepoDetailPage({
  params,
}: {
  params: Promise<{ slug: string; repoSlug: string }>;
}) {
  const { slug, repoSlug } = await params;
  const repo = await getRepoData(repoSlug);

  if (!repo) return notFound();

  return (
    <div>
      {/* Breadcrumb */}
      <nav className="text-xs text-muted mb-6">
        <Link href={`/${slug}`} className="hover:text-accent">
          {slug}
        </Link>
        <span className="mx-1">/</span>
        <Link href={`/${slug}/repos`} className="hover:text-accent">
          repos
        </Link>
        <span className="mx-1">/</span>
        <span className="text-foreground">{repo.githubRepo}</span>
      </nav>

      {/* Header */}
      <div className="mb-8">
        <h1 className="text-xl font-bold mb-1">{repo.githubRepo}</h1>
        {repo.description && (
          <p className="text-muted text-sm mb-4">{repo.description}</p>
        )}

        <div className="flex flex-wrap gap-3 items-center">
          <a
            href={`https://github.com/${repo.githubRepo}`}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-block px-3 py-1 border border-border text-sm text-muted hover:text-accent hover:border-accent transition-colors"
          >
            [view on github]
          </a>
          {repo.lastCommitAt && (
            <span className="text-xs text-muted">
              last commit: {new Date(repo.lastCommitAt).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
              })}
            </span>
          )}
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-8">
        <div className="p-3 border border-border">
          <div className="text-xs text-muted mb-1">stars</div>
          <div className="text-lg font-bold">
            {repo.stars?.toLocaleString() ?? '-'}
          </div>
        </div>
        <div className="p-3 border border-border">
          <div className="text-xs text-muted mb-1">7d</div>
          <div
            className={`text-lg font-bold ${
              repo.stars7d && repo.stars7d > 0
                ? 'text-success'
                : repo.stars7d && repo.stars7d < 0
                  ? 'text-danger'
                  : ''
            }`}
          >
            {formatDelta(repo.stars7d)}
          </div>
        </div>
        <div className="p-3 border border-border">
          <div className="text-xs text-muted mb-1">30d</div>
          <div
            className={`text-lg font-bold ${
              repo.stars30d && repo.stars30d > 0
                ? 'text-success'
                : repo.stars30d && repo.stars30d < 0
                  ? 'text-danger'
                  : ''
            }`}
          >
            {formatDelta(repo.stars30d)}
          </div>
        </div>
        <div className="p-3 border border-border">
          <div className="text-xs text-muted mb-1">90d</div>
          <div
            className={`text-lg font-bold ${
              repo.stars90d && repo.stars90d > 0
                ? 'text-success'
                : repo.stars90d && repo.stars90d < 0
                  ? 'text-danger'
                  : ''
            }`}
          >
            {formatDelta(repo.stars90d)}
          </div>
        </div>
      </div>

      <StarChart data={repo.starHistory} />

      {/* Found In */}
      {repo.foundIn && repo.foundIn.length > 0 && (
        <div>
          <div className="text-muted text-sm mb-3">## found in</div>
          <div className="flex flex-wrap gap-1">
            {repo.foundIn.map((f: { listSlug: string; listName: string; categoryName: string; categorySlug: string }, i: number) => (
              <Link
                key={i}
                href={`/${f.listSlug}/repos?category=${f.categorySlug}`}
                className="px-2 py-0.5 border border-border text-xs text-muted hover:text-accent hover:border-accent transition-colors"
              >
                {f.listName}/{f.categoryName}
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
