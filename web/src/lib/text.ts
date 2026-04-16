/**
 * Clean repo/list descriptions for display.
 * - Strips all emojis (Extended_Pictographic + variation selectors + ZWJ)
 * - Strips leading awesome-list boilerplate:
 *   "A/An {adjective} list/collection of", optionally plural — e.g.
 *   "A curated list of", "An awesome collection of", "Lists of",
 *   "The best list of", "A great awesome curated list of", etc.
 * - Strips leading intensifier + "awesome" phrases once boilerplate is gone:
 *   "Awesome ", "Amazingly awesome ", "Super awesome ", etc.
 * - Collapses double spaces
 * - Capitalizes the first letter of the result
 */
export function cleanDescription(desc: string | null | undefined): string | null {
  if (!desc) return null;
  const stripped = desc
    .replace(/\p{Extended_Pictographic}(\uFE0F|\u200D\p{Extended_Pictographic})*/gu, '')
    .replace(/[\u{E000}-\u{F8FF}\u{F0000}-\u{FFFFD}\u{100000}-\u{10FFFD}]/gu, '')
    .replace(/\s+/g, ' ')
    .trim()
    .replace(/^(?:(?:a|an|the)\s+)?(?:[\w-]+\s+){0,3}(?:lists?|collections?)\s+of\s+/i, '')
    .replace(/^(?:[\w-]+ly\s+)?awesome\s+/i, '')
    .trim();
  if (!stripped) return null;
  return stripped.charAt(0).toUpperCase() + stripped.slice(1);
}
