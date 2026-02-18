import Link from 'next/link';
import { notFound } from 'next/navigation';
import StarChart from './star-chart';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000/api';

export async function generateStaticParams() {
  const res = await fetch(`${API_BASE}/sync/static/repo-slugs`);
  const { data } = await res.json();
  return data.map((r: { listSlug: string; repoSlug: string }) => ({
    slug: r.listSlug,
    repoSlug: r.repoSlug,
  }));
}

async function getRepoData(repoSlug: string) {
  // repoSlug is "owner-name" where / was replaced with -
  // Split on the first dash only to get owner and name
  const dashIndex = repoSlug.indexOf('-');
  if (dashIndex === -1) return null;
  const owner = repoSlug.substring(0, dashIndex);
  const name = repoSlug.substring(dashIndex + 1);

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
      <nav className="text-sm text-muted mb-6">
        <Link href={`/${slug}`} className="hover:text-accent">
          {slug}
        </Link>
        <span className="mx-2">/</span>
        <Link href={`/${slug}/repos`} className="hover:text-accent">
          repos
        </Link>
        <span className="mx-2">/</span>
        <span className="text-foreground">{repo.githubRepo}</span>
      </nav>

      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold mb-2">{repo.githubRepo}</h1>
        {repo.description && (
          <p className="text-muted text-lg mb-4">{repo.description}</p>
        )}

        <div className="flex flex-wrap gap-4 items-center">
          <a
            href={`https://github.com/${repo.githubRepo}`}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-4 py-2 bg-surface border border-border rounded-lg hover:border-accent transition-colors"
          >
            View on GitHub
          </a>
          {repo.lastCommitAt && (
            <span className="text-sm text-muted">
              Last commit: {new Date(repo.lastCommitAt).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
              })}
            </span>
          )}
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div className="p-4 bg-surface border border-border rounded-lg">
          <div className="text-sm text-muted mb-1">Stars</div>
          <div className="text-2xl font-bold font-mono">
            {repo.stars?.toLocaleString() ?? '-'}
          </div>
        </div>
        <div className="p-4 bg-surface border border-border rounded-lg">
          <div className="text-sm text-muted mb-1">7-day change</div>
          <div
            className={`text-2xl font-bold font-mono ${
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
        <div className="p-4 bg-surface border border-border rounded-lg">
          <div className="text-sm text-muted mb-1">30-day change</div>
          <div
            className={`text-2xl font-bold font-mono ${
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
        <div className="p-4 bg-surface border border-border rounded-lg">
          <div className="text-sm text-muted mb-1">90-day change</div>
          <div
            className={`text-2xl font-bold font-mono ${
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

      {/* Star History Chart (client component) */}
      <StarChart data={repo.starHistory} />

      {/* Found In */}
      {repo.foundIn && repo.foundIn.length > 0 && (
        <div>
          <h2 className="text-lg font-semibold mb-4">Found in</h2>
          <div className="flex flex-wrap gap-2">
            {repo.foundIn.map((f: { listSlug: string; listName: string; categoryName: string; categorySlug: string }, i: number) => (
              <Link
                key={i}
                href={`/${f.listSlug}/repos?category=${f.categorySlug}`}
                className="px-3 py-1 bg-surface border border-border rounded-full text-sm text-muted hover:text-foreground hover:border-accent transition-colors"
              >
                {f.listName} / {f.categoryName}
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
