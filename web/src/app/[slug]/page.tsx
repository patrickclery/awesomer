import { getAwesomeLists, getAwesomeList, getTrendingByList } from '@/lib/api';
import { TrendingTable } from '@/components/trending-table';
import Link from 'next/link';
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
        <div className="text-muted text-sm mb-1">$ awesomer show {slug}</div>
        <h1 className="text-2xl font-bold mb-1 text-foreground">{list.name}</h1>
        {list.description && (
          <p className="text-muted text-sm">{list.description}</p>
        )}
        <div className="mt-4">
          <Link
            href={`/${slug}/repos`}
            className="inline-block px-4 py-1.5 border border-accent text-accent text-sm hover:bg-accent hover:text-background transition-colors"
          >
            [ browse all repos ]
          </Link>
        </div>
      </div>

      {list.categories && list.categories.length > 0 && (
        <div className="mb-8">
          <div className="text-muted text-sm mb-3">## categories</div>
          <div className="flex flex-wrap gap-1">
            {list.categories.map((cat) => (
              <Link
                key={cat.id}
                href={`/${slug}/repos?category=${cat.slug}`}
                className="px-2 py-0.5 border border-border text-xs text-muted hover:text-accent hover:border-accent transition-colors"
              >
                {cat.name}
                {cat._count && (
                  <span className="ml-1 text-muted/60">
                    ({cat._count.categoryItems})
                  </span>
                )}
              </Link>
            ))}
          </div>
        </div>
      )}

      <div className="space-y-10">
        {trending7d.length > 0 && (
          <TrendingTable
            title="top 10 — 7-day trending"
            repos={trending7d}
            period="7d"
            listSlug={slug}
          />
        )}
        {trending30d.length > 0 && (
          <TrendingTable
            title="top 10 — 30-day trending"
            repos={trending30d}
            period="30d"
            listSlug={slug}
          />
        )}
        {trending90d.length > 0 && (
          <TrendingTable
            title="top 10 — 90-day trending"
            repos={trending90d}
            period="90d"
            listSlug={slug}
          />
        )}
      </div>
    </div>
  );
}
