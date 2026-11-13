import type { Trophy, TrophyId } from '@/lib/api';
import { TROPHY_META } from '@/lib/trophies';

interface TrophyChipsProps {
  trophies?: Trophy[];
  max?: number;
  size: 'sm' | 'md';
  exclude?: TrophyId[];
}

interface TrophyIconProps {
  trophy: Trophy;
}

/**
 * Non-interactive trophy chips (D-14). Renders trophies in payload order (already priority-sorted, D-06)
 * and nothing at all when none are left (D-16). Colours come only from the .trophy-* classes (D-13).
 */
export function TrophyChips({ trophies, max, size, exclude }: TrophyChipsProps) {
  let visible = (trophies ?? []).filter((t) => !exclude?.includes(t.id) && TROPHY_META[t.id] !== undefined);
  if (max !== undefined) visible = visible.slice(0, max);
  if (visible.length === 0) return null;

  return (
    <ul className="trophy-list" aria-label="Trophies">
      {visible.map((t, i) => {
        const meta = TROPHY_META[t.id];
        const Icon = meta.icon;
        return (
          <li
            key={`${t.id}-${t.listSlug ?? i}`}
            className={`trophy-chip trophy-chip--${size} ${meta.variant}`}
            title={meta.title(t)}
          >
            <Icon aria-hidden="true" />
            <span className="trophy-label">{meta.label(t)}</span>
          </li>
        );
      })}
    </ul>
  );
}

/** Icon-only trophy for sidebar rows (D-11); the tooltip doubles as the accessible name. */
export function TrophyIcon({ trophy }: TrophyIconProps) {
  const meta = TROPHY_META[trophy.id];
  if (meta === undefined) return null;
  const Icon = meta.icon;
  const title = meta.title(trophy);
  return (
    <span role="img" className={`trophy-icon ${meta.variant}`} aria-label={title} title={title}>
      <Icon aria-hidden="true" />
    </span>
  );
}
