import type { Category } from '@/lib/api';

interface CategoryLegendProps {
  categories: Category[];
}

export function CategoryLegend({ categories }: CategoryLegendProps) {
  return (
    <div className="mb-10">
      <div className="flex items-center gap-3 mb-5">
        <span className="text-accent text-xs font-mono tracking-widest">CATEGORIES</span>
        <span className="flex-1 h-px bg-border"></span>
        <span className="text-xs text-muted">{categories.length} total</span>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-x-6 gap-y-0.5 text-sm font-mono">
        {categories.map((cat, i) => (
          <LegendEntry key={cat.id} index={i} category={cat} />
        ))}
      </div>
    </div>
  );
}

function LegendEntry({
  index,
  category,
}: {
  index: number;
  category: Category;
}) {
  const num = String(index + 1).padStart(2, '0');
  const count = category._count?.categoryItems ?? 0;

  return (
    <a
      href={`#category-${category.slug}`}
      className="flex items-baseline gap-2 py-1 text-muted hover:text-accent transition-colors group"
    >
      <span className="text-xs w-5 text-right shrink-0 text-accent/40 group-hover:text-accent">{num}</span>
      <span className="truncate">
        {category.name}
        <span className="text-muted/40 ml-1">({count})</span>
      </span>
    </a>
  );
}
