import { GithubService } from '../github.service.js';
import { SKIP_URL } from './default-readme-parser.js';
import type { ReadmeParser, ParseResult, ParsedCategory, ParsedItem } from './readme-parser.interface.js';

// Matches: ## [Project Name](URL)
const H2_PROJECT_RE = /^##\s+\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)\s*$/;

// Matches bullet link inside ### Links: - [Text](url)
const LINK_ITEM_RE = /^\s*[-*]\s*\[(?<text>[^\]]+)\]\((?<url>[^)]+)\)/;

// Top-level section boundaries
const OPEN_SOURCE_HEADER = /^#\s+Open.?source\s+projects/i;
const CLOSED_SOURCE_HEADER = /^#\s+Closed.?source/i;

// E2B integration section at bottom (skip)
const E2B_SECTION_RE = /^#\s+.*E2B/i;

export class AiAgentsReadmeParser implements ReadmeParser {
  parse(content: string): ParseResult {
    const categories: ParsedCategory[] = [];
    const items: ParsedItem[] = [];

    const lines = content.split('\n');

    // Single category for all open-source items
    categories.push({ name: 'Open Source AI Agents', order: 0 });
    const openSourceCategoryIndex = 0;

    let inOpenSource = false;
    let i = 0;

    while (i < lines.length) {
      const line = lines[i];

      // Detect section boundaries
      if (OPEN_SOURCE_HEADER.test(line)) {
        inOpenSource = true;
        i++;
        continue;
      }
      if (CLOSED_SOURCE_HEADER.test(line) || E2B_SECTION_RE.test(line)) {
        inOpenSource = false;
        i++;
        continue;
      }

      // Only process items inside the open-source section
      if (!inOpenSource) {
        i++;
        continue;
      }

      // Match H2 project heading: ## [Name](URL)
      const h2Match = line.match(H2_PROJECT_RE);
      if (!h2Match?.groups) {
        i++;
        continue;
      }

      const projectName = h2Match.groups.name;
      const h2Url = h2Match.groups.url.replace(/[?#].*$/, '').replace(/\/+$/, '');
      i++;

      // Capture description from the next non-empty line (before <details> or next ##)
      let description: string | null = null;
      while (i < lines.length) {
        const nextLine = lines[i].trim();
        if (nextLine === '' || nextLine.startsWith('<details') || nextLine.startsWith('##')) break;
        // Strip "ProjectName: " prefix if present
        const prefixRe = new RegExp(`^${projectName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*[:\u2013\u2014-]\\s*`, 'i');
        description = nextLine.replace(prefixRe, '').trim() || null;
        i++;
        break;
      }

      // Try to extract GitHub repo from H2 URL first
      let githubRepo: string | null = null;
      let primaryUrl = h2Url;

      if (!SKIP_URL.test(h2Url)) {
        const parsed = GithubService.parseGithubRepo(h2Url);
        if (parsed) {
          githubRepo = `${parsed.owner}/${parsed.name}`;
          primaryUrl = `https://github.com/${parsed.owner}/${parsed.name}`;
        }
      }

      // If H2 URL is not a GitHub repo, search ### Links inside <details> for one
      if (!githubRepo) {
        // Scan forward through <details> block looking for a GitHub link
        const savedI = i;
        let inDetails = false;
        while (i < lines.length) {
          const scanLine = lines[i].trim();
          if (scanLine.startsWith('<details')) {
            inDetails = true;
            i++;
            continue;
          }
          if (scanLine === '</details>') {
            i++;
            break;
          }
          if (scanLine.startsWith('## ') && !inDetails) break; // next project
          if (scanLine.startsWith('# ')) break; // next section

          if (inDetails && !githubRepo) {
            const linkMatch = scanLine.match(LINK_ITEM_RE);
            if (linkMatch?.groups) {
              const linkUrl = linkMatch.groups.url.replace(/[?#].*$/, '').replace(/\/+$/, '');
              if (!SKIP_URL.test(linkUrl)) {
                const parsed = GithubService.parseGithubRepo(linkUrl);
                if (parsed) {
                  githubRepo = `${parsed.owner}/${parsed.name}`;
                  primaryUrl = `https://github.com/${parsed.owner}/${parsed.name}`;
                  // Don't break — keep scanning to consume the rest of <details>
                }
              }
            }
          }
          i++;
        }
        // If we didn't find a </details> close, reset position
        if (!inDetails) {
          i = savedI;
        }
      } else {
        // Skip past the <details> block for entries where we already have the GitHub URL
        while (i < lines.length) {
          const scanLine = lines[i].trim();
          if (scanLine === '</details>') {
            i++;
            break;
          }
          if (scanLine.startsWith('## ')) break;
          if (scanLine.startsWith('# ')) break;
          i++;
        }
      }

      // Only include items that have a valid GitHub repo (per existing parser rules)
      if (githubRepo) {
        items.push({
          name: projectName,
          primaryUrl,
          githubRepo,
          description,
          categoryIndex: openSourceCategoryIndex,
        });
      }
    }

    return { categories, items };
  }
}
