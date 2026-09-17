import { GithubService } from '../github.service.js';
import { SKIP_URL } from './default-readme-parser.js';
import type { ReadmeParser, ParseResult, ParsedCategory, ParsedItem } from './readme-parser.interface.js';

// Strip all HTML tags. `title` and `description` are free text an outside contributor can set
// through an upstream pull request, and they are served verbatim by the public categories endpoint.
const HTML_TAG_RE = /<[^>]*>/g;

/** A single project entry inside an upstream category (awesome.immich.app `items.json`). */
interface ImmichProject {
  title: string;
  description?: string | null;
  websiteUrl?: string | null;
  sourceCodeUrl?: string | null;
  tags?: string[];
}

/** A top-level category object in the upstream `items.json` array. */
interface ImmichCategory {
  id?: string;
  name?: string;
  types?: string[];
  projects?: ImmichProject[];
}

function stripHtml(raw: string): string {
  return raw.replace(HTML_TAG_RE, '').trim();
}

/**
 * Parses awesome.immich.app's source of truth, which is a JSON data file rather than a README.
 *
 * Never throws: malformed or restructured upstream input returns an empty result, which the
 * `diffSyncAwesomeList` zero-item safeguard converts into a skip rather than a wipe.
 */
export class ImmichItemsJsonParser implements ReadmeParser {
  readonly sourcePath = 'apps/awesome.immich.app/src/data/items.json';

  parse(content: string): ParseResult {
    const categories: ParsedCategory[] = [];
    const items: ParsedItem[] = [];

    let raw: unknown;
    try {
      raw = JSON.parse(content);
    } catch {
      return { categories, items };
    }
    if (!Array.isArray(raw)) return { categories, items };

    for (const category of raw as ImmichCategory[]) {
      if (!category?.name) continue;

      const categoryIndex = categories.length;
      categories.push({ name: stripHtml(String(category.name)), order: categories.length });

      const projects = Array.isArray(category.projects) ? category.projects : [];
      for (const project of projects) {
        // No source URL at all (website-only guides) -- dropped per the `github_repo IS NULL` rule.
        const url = project?.sourceCodeUrl;
        if (!url) continue;
        // File references inside a repo (/blob/, /tree/, /raw/).
        if (SKIP_URL.test(url)) continue;
        // Anything that is not a GitHub root repo URL (non-GitHub forges, deep paths).
        const parsed = GithubService.parseGithubRepo(url);
        if (!parsed) continue;

        const name = stripHtml(String(project.title ?? ''));
        if (!name) continue;
        const description = stripHtml(String(project.description ?? ''));

        items.push({
          name,
          // Rebuilt from owner/name -- never the raw URL, since `repos.githubRepo` is unique
          // and a stray `.git` or trailing slash would mint a ghost repo row.
          primaryUrl: `https://github.com/${parsed.owner}/${parsed.name}`,
          githubRepo: `${parsed.owner}/${parsed.name}`,
          description: description || null,
          categoryIndex,
        });
      }
    }

    return { categories, items };
  }
}
