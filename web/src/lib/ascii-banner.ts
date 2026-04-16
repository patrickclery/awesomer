import figlet from 'figlet';

interface BannerResult {
  text: string;
  fontSize: number;
  lineWidth: number;
}

/**
 * Convert a slug-format list name to a display name.
 * Strips the "awesome-" or "awesome " prefix and converts
 * to Title Case: "awesome-claude-code" → "Claude Code"
 */
export function displayName(name: string): string {
  const stripped = name.replace(/^awesome[-\s]+/i, '');
  return stripped
    .split(/[-\s]+/)
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}

/**
 * Generate ANSI Shadow figlet text with auto-calculated font-size.
 *
 * At a given monospace font-size, each character is approximately
 * fontSize * 0.6 pixels wide. The figlet renders inside the banner's
 * md:col-span-2 column (2/3 of a grid-cols-3 inside max-w-5xl main).
 *
 * Container widths by viewport:
 *   - sm (640-767px, 1-col banner): figlet gets full banner width ≈ 590-720px
 *   - md (768-1023px, 3-col banner): col-span-2 ≈ 470px ← TIGHTEST
 *   - lg+ (≥1024, max-w-5xl caps at 1024): col-span-2 ≈ 620px
 *
 * We size for the md breakpoint (tightest) so the figlet never overflows,
 * at the cost of slightly smaller rendering at lg+. Cap at 11px so very
 * short names ("Awesomer", "Python") don't blow up.
 */
export function generateAsciiBanner(listName: string): BannerResult {
  const name = displayName(listName);

  const text = figlet.textSync(name, {
    font: 'ANSI Shadow',
    width: 300,
  });

  // Measure the longest line in visual columns
  const lines = text.split('\n');
  const lineWidth = Math.max(...lines.map((l) => l.trimEnd().length));

  // Calculate font-size to fit within container (md col-span-2, ~470px with ~10px safety margin)
  // monospace char width ~= fontSize * 0.6
  const maxContainerPx = 460;
  const charWidthRatio = 0.6;
  const idealFontSize = maxContainerPx / (lineWidth * charWidthRatio);
  const fontSize = Math.min(11, Math.round(idealFontSize * 10) / 10);

  return { text, fontSize, lineWidth };
}
