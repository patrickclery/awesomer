import { getAwesomeList, getTrendingByList } from '@/lib/api';
import { TrendingTable } from '@/components/trending-table';
import Link from 'next/link';
import { notFound } from 'next/navigation';

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
  let trending30d: Awaited<ReturnType<typeof getTrendingByList>>['data'] = [];
  let trending90d: Awaited<ReturnType<typeof getTrendingByList>>['data'] = [];

  try {
    const [t7, t30, t90] = await Promise.all([
      getTrendingByList(slug, { period: '7d', limit: 10 }),
      getTrendingByList(slug, { period: '30d', limit: 10 }),
      getTrendingByList(slug, { period: '90d', limit: 10 }),
    ]);
    trending7d = t7.data;
    trending30d = t30.data;
    trending90d = t90.data;
  } catch {
    // Trending data not available yet
  }

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold mb-2">{list.name}</h1>
        {list.description && (
          <p className="text-muted text-lg">{list.description}</p>
        )}
        <div className="mt-4">
          <Link
            href={`/${slug}/repos`}
            className="inline-block px-4 py-2 bg-accent text-white rounded-lg hover:bg-accent-hover transition-colors"
          >
            Browse all repos
          </Link>
        </div>
      </div>

      {list.categories && list.categories.length > 0 && (
        <div className="mb-8">
          <h2 className="text-lg font-semibold mb-3">Categories</h2>
          <div className="flex flex-wrap gap-2">
            {list.categories.map((cat) => (
              <Link
                key={cat.id}
                href={`/${slug}/repos?category=${cat.slug}`}
                className="px-3 py-1 bg-surface border border-border rounded-full text-sm text-muted hover:text-foreground hover:border-accent transition-colors"
              >
                {cat.name}
                {cat._count && (
                  <span className="ml-1 text-xs">
                    ({cat._count.categoryItems})
                  </span>
                )}
              </Link>
            ))}
          </div>
        </div>
      )}

      <div className="space-y-12">
        {trending7d.length > 0 && (
          <TrendingTable
            title="Top 10: 7-Day Trending"
            repos={trending7d}
            period="7d"
            listSlug={slug}
          />
        )}
        {trending30d.length > 0 && (
          <TrendingTable
            title="Top 10: 30-Day Trending"
            repos={trending30d}
            period="30d"
            listSlug={slug}
          />
        )}
        {trending90d.length > 0 && (
          <TrendingTable
            title="Top 10: 90-Day Trending"
            repos={trending90d}
            period="90d"
            listSlug={slug}
          />
        )}
      </div>
    </div>
  );
}
