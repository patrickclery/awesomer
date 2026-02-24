import type { Category } from '@/lib/api';

interface CategoryLegendProps {
  categories: Category[];
}

export function CategoryLegend({ categories }: CategoryLegendProps) {
  const sorted = [...categories].sort((a, b) =>
    a.name.localeCompare(b.name),
  );

  const midpoint = Math.ceil(sorted.length / 2);
  const leftColumn = sorted.slice(0, midpoint);
  const rightColumn = sorted.slice(midpoint);

  return (
    <div className="mb-10">
      <div className="text-muted text-sm mb-4">── categories ──</div>
      <div className="grid grid-cols-2 gap-x-8 text-sm font-mono">
        <div className="flex flex-col gap-y-1">
          {leftColumn.map((cat, i) => (
            <LegendEntry key={cat.id} index={i} category={cat} />
          ))}
        </div>
        <div className="flex flex-col gap-y-1">
          {rightColumn.map((cat, i) => (
            <LegendEntry key={cat.id} index={midpoint + i} category={cat} />
          ))}
        </div>
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
      className="flex items-baseline gap-2 py-0.5 text-muted hover:text-accent transition-colors"
    >
      <span className="text-xs w-5 text-right shrink-0">{num}</span>
      <span className="truncate">
        {category.name}
        <span className="text-muted/60 ml-1">({count})</span>
      </span>
    </a>
  );
}
