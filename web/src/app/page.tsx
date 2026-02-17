import Link from 'next/link';
import { getAwesomeLists } from '@/lib/api';

export default async function HomePage() {
  let lists: Awaited<ReturnType<typeof getAwesomeLists>>['data'] = [];

  try {
    const response = await getAwesomeLists();
    lists = response.data;
  } catch {
    // API not available yet — show placeholder
  }

  return (
    <div>
      <section className="text-center py-16">
        <h1 className="text-4xl font-bold mb-4">awesomer</h1>
        <p className="text-muted text-lg max-w-2xl mx-auto">
          Discover trending open-source tools, powered by real GitHub data. No
          votes, no hype — just stars.
        </p>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-6">Verticals</h2>
        {lists.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {lists.map((list) => (
              <Link
                key={list.id}
                href={`/${list.slug}`}
                className="block p-6 bg-surface border border-border rounded-lg hover:border-accent transition-colors"
              >
                <h3 className="font-semibold text-lg mb-2">{list.name}</h3>
                {list.description && (
                  <p className="text-muted text-sm line-clamp-2">
                    {list.description}
                  </p>
                )}
                {list._count && (
                  <p className="text-muted text-xs mt-3">
                    {list._count.categories} categories
                  </p>
                )}
              </Link>
            ))}
          </div>
        ) : (
          <div className="text-center py-12 text-muted">
            <p>No verticals available yet. Connect the API to get started.</p>
          </div>
        )}
      </section>
    </div>
  );
}
