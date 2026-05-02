import {
  getAwesomeList,
  getTrendingByList,
  getAllReposByList,
} from '@/lib/api';
import { getStaticLists } from '@/lib/static-data';
import { ListInfoCard } from '@/components/list-info-card';
import { RepoHeroCard } from '@/components/repo-hero-card';
import { RepoMiniCard } from '@/components/repo-mini-card';
import { SidebarRepoList } from '@/components/sidebar-repo-list';
import { AllReposSection } from '@/components/all-repos-section';
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

  // Parallelize three independent fetches; preserve current per-fetch error semantics.
  const [listResult, trendingResult, allReposResult] = await Promise.allSettled([
    getAwesomeList(slug),
    getTrendingByList(slug, { period: '7d', limit: 30 }),
    getAllReposByList(slug),
  ]);

  if (listResult.status !== 'fulfilled') {
    notFound();
  }
  const list = listResult.value.data;

  const trending7d =
    trendingResult.status === 'fulfilled' ? trendingResult.value.data : [];
  const allItems =
    allReposResult.status === 'fulfilled' ? allReposResult.value.data : [];

  const heroRepo = trending7d[0];
  const gridRepos = trending7d.slice(1, 5);
  const sidebarRepos = trending7d.slice(5, 14);

  // Group items by category (migrated verbatim from /all/page.tsx lines 35-52).
  const itemsByCategory = new Map<number, typeof allItems>();
  for (const item of allItems) {
    const catId = item.category.id;
    if (!itemsByCategory.has(catId)) {
      itemsByCategory.set(catId, []);
    }
    itemsByCategory.get(catId)!.push(item);
  }

  const categoryTotalStars = new Map<number, number>();
  for (const [catId, items] of itemsByCategory) {
    categoryTotalStars.set(
      catId,
      items.reduce((sum, item) => sum + (item.stars ?? 0), 0),
    );
  }

  const sortedCategories = [...(list.categories || [])]
    .filter(
      (cat) =>
        cat.slug != null && (itemsByCategory.get(cat.id)?.length ?? 0) > 0,
    )
    .sort(
      (a, b) =>
        (categoryTotalStars.get(b.id) ?? 0) -
        (categoryTotalStars.get(a.id) ?? 0),
    );

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

      {/* Seven-day trending grid (Phase 17 — preserved) */}
      {trending7d.length > 0 ? (
        <div className="stagger">
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div className="lg:col-span-2">
              {heroRepo && (
                <div className="mb-4">
                  <RepoHeroCard repo={heroRepo} />
                </div>
              )}
              {gridRepos.length > 0 && (
                <div className="flex flex-col gap-2 stagger">
                  {gridRepos.map((repo, i) => (
                    <RepoMiniCard key={repo.id} repo={repo} rank={i + 2} />
                  ))}
                </div>
              )}
            </div>
            {sidebarRepos.length > 0 && (
              <div className="lg:col-span-1">
                <SidebarRepoList repos={sidebarRepos} />
              </div>
            )}
          </div>
        </div>
      ) : (
        <div className="py-8 text-muted text-sm">
          <span className="text-danger">[ERR]</span> no trending data available. check the API connection.
        </div>
      )}

      {/* Phase 27: Inlined AllReposSection (full-width sibling, OUTSIDE .stagger) */}
      {sortedCategories.length > 0 ? (
        <section id="all-repos" className="mt-12">
          <AllReposSection
            items={allItems}
            categories={sortedCategories.map((cat) => ({
              id: cat.id,
              name: cat.name,
              slug: cat.slug,
              count: itemsByCategory.get(cat.id)?.length ?? 0,
            }))}
            listSlug={slug}
          />
        </section>
      ) : (
        <section id="all-repos" className="mt-12 py-8 text-muted text-sm">
          <span className="text-danger">[ERR]</span> no repos available for this list.
        </section>
      )}
    </div>
  );
}
