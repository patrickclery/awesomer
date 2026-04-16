import { GithubService } from '../github.service.js';
import type { ReadmeParser, ParseResult, ParsedCategory, ParsedItem } from './readme-parser.interface.js';

export const SKIP_URL = /github\.com\/[^/]+\/[^/]+\/(?:blob|tree|raw)\//i;

const SKIP_HEADERS =
  /^(Contents?|Table of Contents?|Contributing|License|Acknowledgments?|Credits?)$/i;
const HEADER_RE = /^(#{1,3})\s+(.+)$/;
// Standard: - [name](url) - desc
// Emoji prefix: - [name](url) - desc
const ITEM_RE =
  /^\s*[-*]\s*(?:[^[\n]*?)\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\s*[-\u2013\u2014:]\s*(?<description>.+))?/;
// Badge prefix (e.g. Awesome-Linux-Software):
//   - [![badge][ref]](github-url) [Name](homepage) - desc
const BADGE_ITEM_RE =
  /^\s*[-*]\s*\[!\[[^\]]*\]\[[^\]]*\]\]\((?<badgeUrl>[^)]+)\)\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\s*[-\u2013\u2014:]\s*(?<description>.+))?/;

export class DefaultReadmeParser implements ReadmeParser {
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
        const headerText = headerMatch[2].trim();
        if (!SKIP_HEADERS.test(headerText)) {
          categories.push({ name: headerText, order: categories.length });
          currentCategoryIndex = categories.length - 1;
        }
        continue;
      }

      if (currentCategoryIndex < 0) continue;

      // Check for badge-prefix item (GitHub URL in badge link, name in second link)
      const badgeMatch = line.match(BADGE_ITEM_RE);
      if (badgeMatch?.groups) {
        const url = badgeMatch.groups.badgeUrl;
        if (SKIP_URL.test(url)) continue;
        const parsed = GithubService.parseGithubRepo(url);
        if (!parsed) continue;

        items.push({
          name: badgeMatch.groups.name,
          primaryUrl: `https://github.com/${parsed.owner}/${parsed.name}`,
          githubRepo: `${parsed.owner}/${parsed.name}`,
          description: badgeMatch.groups.description?.trim() || null,
          categoryIndex: currentCategoryIndex,
        });
        continue;
      }

      // Check for standard list item (with optional emoji/text prefix before link)
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
