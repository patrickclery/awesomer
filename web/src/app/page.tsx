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
      <section className="py-12">
        <div className="text-accent glow text-lg mb-2">$ cat README.md</div>
        <h1 className="text-2xl font-bold mb-3 text-foreground">
          discover trending open-source tools
        </h1>
        <p className="text-muted text-sm max-w-xl">
          powered by real github data. no votes, no hype — just stars.
        </p>
      </section>

      <section>
        <div className="text-muted text-sm mb-4">
          ## verticals ({lists.length})
        </div>
        {lists.length > 0 ? (
          <div className="space-y-1">
            {lists.map((list) => (
              <Link
                key={list.id}
                href={`/${list.slug}`}
                className="block py-2 px-3 border border-transparent hover:border-border hover:bg-surface transition-colors group"
              >
                <div className="flex items-center gap-3">
                  <span className="text-muted group-hover:text-accent">&gt;</span>
                  <span className="text-foreground group-hover:text-accent font-medium">
                    {list.name}
                  </span>
                  {list._count && (
                    <span className="text-muted text-xs">
                      [{list._count.categories} categories]
                    </span>
                  )}
                </div>
                {list.description && (
                  <p className="text-muted text-xs ml-6 mt-0.5 truncate">
                    {list.description}
                  </p>
                )}
              </Link>
            ))}
          </div>
        ) : (
          <div className="py-8 text-muted text-sm">
            <span className="text-danger">[ERR]</span> no verticals available. connect the API to get started.
          </div>
        )}
      </section>
    </div>
  );
}
