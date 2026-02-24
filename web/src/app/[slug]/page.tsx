import {
  getAwesomeLists,
  getAwesomeList,
  getTrendingByList,
  getAllReposByList,
} from '@/lib/api';
import { TrendingTable } from '@/components/trending-table';
import { FeaturedRepo } from '@/components/featured-repo';
import { CategoryLegend } from '@/components/category-legend';
import { CategorySection } from '@/components/category-section';
import { notFound } from 'next/navigation';

export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
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

  // Fetch trending + all repos in parallel
  let trending7d: Awaited<ReturnType<typeof getTrendingByList>>['data'] = [];
  let allItems: Awaited<ReturnType<typeof getAllReposByList>>['data'] = [];

  try {
    const [t7, repos] = await Promise.all([
      getTrendingByList(slug, { period: '7d', limit: 10 }),
      getAllReposByList(slug),
    ]);
    trending7d = t7.data;
    allItems = repos.data;
  } catch {
    // Data not available yet
  }

  // Split trending into featured top 3 and remaining rows
  const featuredRepos = trending7d.slice(0, 3);
  const remainingTrending = trending7d.slice(3);

  // Group items by category
  const itemsByCategory = new Map<number, typeof allItems>();
  for (const item of allItems) {
    const catId = item.category.id;
    if (!itemsByCategory.has(catId)) {
      itemsByCategory.set(catId, []);
    }
    itemsByCategory.get(catId)!.push(item);
  }

  // Only include categories that have items, sorted alphabetically
  const sortedCategories = [...(list.categories || [])]
    .filter((cat) => (itemsByCategory.get(cat.id)?.length ?? 0) > 0)
    .sort((a, b) => a.name.localeCompare(b.name));

  return (
    <div>
      {/* 1. Hero */}
      <div className="mb-6">
        <div className="text-muted text-sm mb-1">$ awesomer show {slug}</div>
        <h1 className="text-2xl font-bold mb-1 text-foreground">{list.name}</h1>
        {list.description && (
          <p className="text-muted text-sm">{list.description}</p>
        )}
      </div>

      {/* 2. Attribution banner */}
      <div className="mb-8 text-center">
        <a
          href={`https://github.com/${list.githubRepo}`}
          target="_blank"
          rel="noopener noreferrer"
          className="text-muted text-sm hover:text-accent transition-colors"
        >
          ── curated from {list.githubRepo} ──
        </a>
      </div>

      {/* 3. Seven-day trending with cascading top 3 */}
      {trending7d.length > 0 && (
        <div className="mb-10">
          <div className="text-muted text-sm mb-4">── 7-day trending ──</div>

          {/* Cascading featured cards */}
          {featuredRepos.map((repo, i) => (
            <FeaturedRepo
              key={repo.id}
              repo={repo}
              rank={(i + 1) as 1 | 2 | 3}
              listSlug={slug}
            />
          ))}

          {/* Remaining #4–10 as table rows */}
          {remainingTrending.length > 0 && (
            <TrendingTable
              title=""
              repos={remainingTrending}
              period="7d"
              listSlug={slug}
              startRank={4}
            />
          )}
        </div>
      )}

      {/* 4. Category legend / TOC */}
      {sortedCategories.length > 0 && (
        <CategoryLegend categories={sortedCategories} />
      )}

      {/* 5. All repos grouped by category */}
      {sortedCategories.map((cat, i) => (
        <CategorySection
          key={cat.id}
          number={i + 1}
          name={cat.name}
          slug={cat.slug!}
          items={itemsByCategory.get(cat.id)!}
          listSlug={slug}
        />
      ))}
    </div>
  );
}
