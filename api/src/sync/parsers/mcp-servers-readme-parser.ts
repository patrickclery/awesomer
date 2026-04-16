import { GithubService } from '../github.service.js';
import { SKIP_URL } from './default-readme-parser.js';
import type { ReadmeParser, ParseResult, ParsedCategory, ParsedItem } from './readme-parser.interface.js';

// Strip all HTML tags (per D-01)
const HTML_TAG_RE = /<[^>]*>/g;

// Strip emoji: presentation forms, extended pictographic, modifiers, components, variation selectors, ZWJ (per D-04)
const EMOJI_RE = /[\p{Emoji_Presentation}\p{Extended_Pictographic}\p{Emoji_Modifier}\p{Emoji_Component}\u200D\uFE0F]+/gu;

// Section boundaries -- only parse categories/items inside these sections
const SERVER_IMPL_RE = /^##\s+Server Implementations/;
const FRAMEWORKS_RE = /^##\s+Frameworks/;

// Any other ## heading exits the relevant section
const H2_RE = /^##\s+/;

// Category header: ### anything (within a relevant section)
const H3_RE = /^###\s+(.+)$/;

// Item line: - [Name](url) [optional badges, emoji] - description
const ITEM_RE = /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:.*?[-\u2013\u2014]\s+(?<description>.+))?$/;

function cleanCategoryName(raw: string): string {
  return raw
    .replace(HTML_TAG_RE, '')
    .replace(EMOJI_RE, '')
    .trim();
}

export class McpServersReadmeParser implements ReadmeParser {
  parse(content: string): ParseResult {
    const categories: ParsedCategory[] = [];
    const items: ParsedItem[] = [];

    let currentCategoryIndex = -1;
    const categoryNameMap = new Map<string, number>();
    let inRelevantSection = false;

    const lines = content.split('\n');

    for (const line of lines) {
      // Check for ## Frameworks
      if (FRAMEWORKS_RE.test(line)) {
        inRelevantSection = true;
        const cleanName = 'Frameworks';
        const dedupKey = cleanName.toLowerCase();
        if (categoryNameMap.has(dedupKey)) {
          currentCategoryIndex = categoryNameMap.get(dedupKey)!;
        } else {
          categories.push({ name: cleanName, order: categories.length });
          currentCategoryIndex = categories.length - 1;
          categoryNameMap.set(dedupKey, currentCategoryIndex);
        }
        continue;
      }

      // Check for ## Server Implementations
      if (SERVER_IMPL_RE.test(line)) {
        inRelevantSection = true;
        continue;
      }

      // Check for any other ## heading (exits relevant section)
      if (H2_RE.test(line)) {
        inRelevantSection = false;
        continue;
      }

      // If not in relevant section, skip
      if (!inRelevantSection) continue;

      // Check for ### heading
      const h3Match = line.match(H3_RE);
      if (h3Match) {
        const raw = h3Match[1];
        const cleanName = cleanCategoryName(raw);
        const dedupKey = cleanName.toLowerCase();
        if (categoryNameMap.has(dedupKey)) {
          currentCategoryIndex = categoryNameMap.get(dedupKey)!;
        } else {
          categories.push({ name: cleanName, order: categories.length });
          currentCategoryIndex = categories.length - 1;
          categoryNameMap.set(dedupKey, currentCategoryIndex);
        }
        continue;
      }

      // If no category established yet, skip
      if (currentCategoryIndex < 0) continue;

      // Check for item
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
          description: itemMatch.groups.description?.trim() || null,
          categoryIndex: currentCategoryIndex,
        });
      }
    }

    return { categories, items };
  }
}
