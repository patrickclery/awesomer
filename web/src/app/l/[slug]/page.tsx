import {
  getAwesomeList,
  getTrendingByList,
} from '@/lib/api';
import { getStaticLists } from '@/lib/static-data';
import { ListInfoCard } from '@/components/list-info-card';
import { RepoHeroCard } from '@/components/repo-hero-card';
import { RepoMiniCard } from '@/components/repo-mini-card';
import { SidebarRepoList } from '@/components/sidebar-repo-list';
import { notFound } from 'next/navigation';

export async function generateStaticParams() {
  const { data: lists } = getStaticLists();
  return lists.map((list) => ({ slug: list.slug }));
}

interface Props {
  params: Promise<{ slug: string }>;
}

export default async function VerticalPage({ params }: Props) {
  const { slug } = await params;

  let list;
  try {
    const response = await getAwesomeList(slug);
    list = response.data;
  } catch {
    notFound();
  }

  let trending7d: Awaited<ReturnType<typeof getTrendingByList>>['data'] = [];

  try {
    const t7 = await getTrendingByList(slug, { period: '7d', limit: 30 });
    trending7d = t7.data;
  } catch {
    // Data not available yet
  }

  const heroRepo = trending7d[0];
  const gridRepos = trending7d.slice(1, 5);
  const sidebarRepos = trending7d.slice(5, 14);
  const hasMore = sidebarRepos.length > 0;

  return (
    <div>
      {/* List info card (Phase 22) */}
      <ListInfoCard
        list={{
          name: list.name,
          slug: list.slug,
          githubRepo: list.githubRepo,
          description: list.description,
          lastCommitAt: list.lastCommitAt,
          repoCount: list._count?.categoryItems ?? 0,
          ownRepoStars: list.repo?.stars ?? null,
        }}
      />

      {/* Seven-day trending */}
      {trending7d.length > 0 ? (
        <div className="stagger">
          {/* Main content: 2/3 left (hero + #2-5) | 1/3 right (#6-20 sidebar) */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Left 2/3: Hero + mini cards */}
            <div className="lg:col-span-2">
              {/* Hero #1 -- full width of left column */}
              {heroRepo && (
                <div className="mb-4">
                  <RepoHeroCard repo={heroRepo} />
                </div>
              )}

              {/* #2-5 mini cards stacked */}
              {gridRepos.length > 0 && (
                <div className="flex flex-col gap-2 stagger">
                  {gridRepos.map((repo, i) => (
                    <RepoMiniCard key={repo.id} repo={repo} rank={i + 2} />
                  ))}
                </div>
              )}
            </div>

            {/* Right 1/3: Sidebar #6-30 */}
            {sidebarRepos.length > 0 && (
              <div className="lg:col-span-1">
                <SidebarRepoList
                  repos={sidebarRepos}
                  listSlug={slug}
                  hasMore={hasMore}
                />
              </div>
            )}
          </div>
        </div>
      ) : (
        <div className="py-8 text-muted text-sm">
          <span className="text-danger">[ERR]</span> no trending data available. check the API connection.
        </div>
      )}
    </div>
  );
}
