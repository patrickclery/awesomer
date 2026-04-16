import Link from 'next/link';
import {
  getAwesomeList,
  getAllReposByList,
} from '@/lib/api';
import { listPath } from '@/lib/routes';
import { AllReposSection } from '@/components/all-repos-section';
import { notFound } from 'next/navigation';

interface Props {
  params: Promise<{ slug: string }>;
}

export default async function ViewAllPage({ params }: Props) {
  const { slug } = await params;

  let list;
  try {
    const response = await getAwesomeList(slug);
    list = response.data;
  } catch {
    notFound();
  }

  let allItems: Awaited<ReturnType<typeof getAllReposByList>>['data'] = [];

  try {
    const repos = await getAllReposByList(slug);
    allItems = repos.data;
  } catch {
    // Data not available yet
  }

  // Group items by category
  const itemsByCategory = new Map<number, typeof allItems>();
  for (const item of allItems) {
    const catId = item.category.id;
    if (!itemsByCategory.has(catId)) {
      itemsByCategory.set(catId, []);
    }
    itemsByCategory.get(catId)!.push(item);
  }

  // Only include categories that have items, sorted by total stars descending
  const categoryTotalStars = new Map<number, number>();
  for (const [catId, items] of itemsByCategory) {
    categoryTotalStars.set(catId, items.reduce((sum, item) => sum + (item.stars ?? 0), 0));
  }

  const sortedCategories = [...(list.categories || [])]
    .filter((cat) => cat.slug != null && (itemsByCategory.get(cat.id)?.length ?? 0) > 0)
    .sort((a, b) => (categoryTotalStars.get(b.id) ?? 0) - (categoryTotalStars.get(a.id) ?? 0));

  // Strip "awesome-" prefix for display name
  const displayName = list.name
    .replace(/^awesome[-\s]+/i, '')
    .replace(/-/g, ' ')
    .replace(/\b\w/g, (c: string) => c.toUpperCase());

  return (
    <div>
      {/* Breadcrumb back to vertical page */}
      <nav className="text-xs text-muted mb-6">
        <Link href={listPath(slug)} className="hover:text-accent transition-colors">
          &larr; {displayName}
        </Link>
      </nav>

      {/* All repos section with filter bar */}
      {sortedCategories.length > 0 ? (
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
      ) : (
        <div className="py-8 text-muted text-sm">
          <span className="text-danger">[ERR]</span> no repos available for this list.
        </div>
      )}
    </div>
  );
}
