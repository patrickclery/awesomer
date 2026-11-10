import { GithubService } from '../github.service.js';
import { SKIP_URL } from './default-readme-parser.js';
import type {
  ReadmeParser,
  ParseResult,
  ParsedCategory,
  ParsedItem,
} from './readme-parser.interface.js';

const SKIP_HEADERS =
  /^(Contents?|Table of Contents?|Contributing|License|Acknowledgments?|Credits?)$/i;

// Matches h1 through h4 headings
const HEADER_RE = /^(#{1,4})\s+(.+)$/;

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

// Strip leading number prefix from h3 category names: "1. Core Frameworks" -> "Core Frameworks"
const NUMBER_PREFIX_RE = /^\d+\.\s+/;

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

export class OpensourceAiReadmeParser implements ReadmeParser {
  parse(content: string): ParseResult {
    const categories: ParsedCategory[] = [];
    const items: ParsedItem[] = [];

    let currentCategoryIndex = -1;
    const lines = content.split('\n');

    for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
      const line = lines[lineIdx];

      // Check for header
      const headerMatch = line.match(HEADER_RE);
      if (headerMatch) {
        const level = headerMatch[1].length;
        const headerText = headerMatch[2].trim();

        // Skip h1 (title heading only)
        if (level === 1) continue;

        // Skip h2 and known skip headers at any level
        if (level === 2 || SKIP_HEADERS.test(headerText)) continue;

        // h3 and h4 become flat categories
        let categoryName = headerText;

        // Strip leading number prefix from h3 headings (e.g., "1. Core Frameworks & Libraries")
        if (level === 3) {
          categoryName = categoryName.replace(NUMBER_PREFIX_RE, '');
        }

        categories.push({ name: categoryName, order: categories.length });
        currentCategoryIndex = categories.length - 1;
        continue;
      }

      if (currentCategoryIndex < 0) continue;

      // Check for list item
      const itemMatch = line.match(ITEM_RE);
      if (itemMatch?.groups) {
        const url = itemMatch.groups.url;
        if (SKIP_URL.test(url)) continue;
        const parsed = GithubService.parseGithubRepo(url);
        if (!parsed) continue;

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
