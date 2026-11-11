import { GithubService } from '../github.service.js';
import { SKIP_URL } from './default-readme-parser.js';
import type {
  ReadmeParser,
  ParseResult,
  ParsedCategory,
  ParsedItem,
} from './readme-parser.interface.js';

// Headings whose content is never imported. Tested against the cleaned
// heading text, so "📋 Contents" is skipped too.
const SKIP_HEADERS =
  /^(Contents?|Table of Contents?|About|About this list|Contributing|License|Acknowledgments?|Credits?)$/i;

// Lines longer than this are skipped before any regex runs. The longest real
// upstream line is 3949 chars (2026-04-02), so this only drops hostile input.
const MAX_LINE_LENGTH = 10_000;

// Matches h1 through h4 headings
const HEADER_RE = /^(#{1,4})\s+(.+)$/;

// Opening or closing code fence (CommonMark: up to 3 spaces of indent, then 3+
// backticks or tildes). Anchored with one bounded run, so it is linear on any line.
const FENCE_RE = /^ {0,3}(`{3,}|~{3,})/;

// Matches link items, bold-wrapped or plain, with an optional description.
// Star badges appear in two positions upstream:
//   - **[Name](url)** ![badge](img) - Description text   (leading, 2026-04 format;
//                                                          skipped by this regex)
//   - [Name](url) - Description text ![badge](img)       (trailing, current format;
//                                                          stripped by cleanDescription)
//   - **[Name](url)** - Description text
//   - **[Name](url)**
const ITEM_RE =
  /^\s*[-*]\s*\*?\*?\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\*?\*?\s*(?:!\[[^\]]*\]\([^)]*\))*\s*[-\u2013\u2014:]\s*(?<description>.+))?/;

// Strip leading number prefix from section names: "1. Core Frameworks" -> "Core Frameworks"
const NUMBER_PREFIX_RE = /^\d+\.\s+/;

// Leading emoji on headings ("🧬 1. ...", "🖥️ 12. ..."): pictographs, skin-tone
// modifiers, ZWJ, variation selector 16, combining keycap, and whitespace.
// Deliberately narrower than the mcp-servers EMOJI_RE: its emoji-component
// class matches ASCII digits and '#', which would eat the section number.
const LEADING_EMOJI_RE =
  /^(?:[\p{Extended_Pictographic}\p{Emoji_Modifier}\s]|\u200D|\uFE0F|\u20E3)+/u;

// Badge and image markup. Negated character classes only, no nested
// quantifiers, so untrusted lines cannot trigger catastrophic backtracking.
const LINKED_IMAGE_RE = /\[!\[[^\]]*\]\([^)]*\)\]\([^)]*\)/g;
const IMAGE_RE = /!\[[^\]]*\]\([^)]*\)/g;
const WHITESPACE_RUN_RE = /\s+/g;
const DANGLING_SEPARATOR_RE = /(?:^|\s+)[-\u2013\u2014|]$/;

/**
 * Cleans a captured description: removes linked badges (`[![alt](img)](href)`)
 * and then any bare image (`![alt](src)`) anywhere in the text, collapses
 * whitespace, drops one trailing dangling separator, and returns null when
 * nothing remains.
 */
export function cleanDescription(raw: string | undefined): string | null {
  if (!raw) return null;
  const cleaned = raw
    .replace(LINKED_IMAGE_RE, ' ')
    .replace(IMAGE_RE, ' ')
    .replace(WHITESPACE_RUN_RE, ' ')
    .trim()
    .replace(DANGLING_SEPARATOR_RE, '')
    .trim();
  return cleaned || null;
}

/** Strips leading emoji, then a leading section number, from heading text. */
export function cleanHeading(text: string): string {
  return text
    .replace(LEADING_EMOJI_RE, '')
    .replace(NUMBER_PREFIX_RE, '')
    .trim();
}

/**
 * Parser for alvinreal/awesome-opensource-ai. Handles both upstream formats:
 * `### 🧬 1. Name` sections with leading badges (2026-04) and `## 1. Name`
 * sections with trailing badges (current).
 *
 * Heading rules:
 * - Lines inside a fenced code block are ignored, so a `# comment` in a shell
 *   snippet neither ends the section nor reads as an item.
 * - An h1 (the title) resets the current category; nothing under it is imported.
 * - Heading text is cleaned (leading emoji, then section number) at every
 *   level before the skip test. A heading that cleans to empty or matches
 *   SKIP_HEADERS (Contents, About, Contributing, License, ...) resets the
 *   current category, so items after it are dropped rather than filed into
 *   the category before it.
 * - Any other h2, h3 or h4 becomes the pending category. h2 counts because
 *   the current upstream puts its numbered sections at h2.
 * - Categories materialize lazily: a pending heading is emitted only when a
 *   valid GitHub item lands under it. Numbered parent sections whose items
 *   all sit under h4 subcategories therefore emit nothing, every item keeps
 *   its nearest heading, and no empty category is ever returned.
 */
export class OpensourceAiReadmeParser implements ReadmeParser {
  parse(content: string): ParseResult {
    const categories: ParsedCategory[] = [];
    const items: ParsedItem[] = [];

    let pendingName: string | null = null;
    let currentCategoryIndex = -1;
    // The fence character ('`' or '~') of the open code block, or null outside one.
    let fenceChar: string | null = null;
    const lines = content.split('\n');

    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
      const line = lines[lineIdx];

      // Code fences: a block closes only on a fence of the character that opened it
      const fenceMatch = line.match(FENCE_RE);
      if (fenceMatch) {
        const char = fenceMatch[1][0];
        if (fenceChar === null) fenceChar = char;
        else if (char === fenceChar) fenceChar = null;
        continue;
      }
      if (fenceChar !== null) continue;

      // Hostile-input guard: never run a regex over an oversized line
      if (line.length > MAX_LINE_LENGTH) continue;

      // Check for header
      const headerMatch = line.match(HEADER_RE);
      if (headerMatch) {
        const level = headerMatch[1].length;
        const name = cleanHeading(headerMatch[2]);

        if (level === 1 || !name || SKIP_HEADERS.test(name)) {
          pendingName = null;
        } else {
          pendingName = name;
        }
        currentCategoryIndex = -1;
        continue;
      }

      // Check for list item
      const itemMatch = line.match(ITEM_RE);
      if (itemMatch?.groups) {
        const url = itemMatch.groups.url;
        if (SKIP_URL.test(url)) continue;
        const parsed = GithubService.parseGithubRepo(url);
        if (!parsed) continue;

        if (currentCategoryIndex < 0) {
          if (pendingName === null) continue;
          categories.push({ name: pendingName, order: categories.length });
          currentCategoryIndex = categories.length - 1;
        }

        items.push({
          name: itemMatch.groups.name,
          primaryUrl: `https://github.com/${parsed.owner}/${parsed.name}`,
          githubRepo: `${parsed.owner}/${parsed.name}`,
          description: cleanDescription(itemMatch.groups.description),
          categoryIndex: currentCategoryIndex,
        });
      }
    }

    return { categories, items };
  }
}
