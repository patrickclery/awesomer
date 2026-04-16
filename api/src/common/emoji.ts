import { nameToEmoji } from 'gemoji';

/**
 * Replace GitHub-style emoji shortcodes (e.g. `:whale:`) with Unicode emoji.
 * Returns the original string if no shortcodes are found, or null if input is null.
 */
export function replaceEmojiShortcodes(
  text: string | null,
): string | null {
  if (!text) return text;
  return text.replace(/:([a-z0-9_+-]+):/g, (match, name: string) => {
    return nameToEmoji[name] ?? match;
  });
}
