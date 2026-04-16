import fs from 'node:fs';
import path from 'node:path';
import type { AwesomeList } from './api';

/**
 * Read a JSON file from the web/data/ directory.
 *
 * Next.js runs from the web/ directory, so process.cwd() resolves to web/.
 * The export script writes JSON files to web/data/.
 */
function readJsonFile<T>(filename: string): T {
  const filePath = path.join(process.cwd(), 'data', filename);
  try {
    const raw = fs.readFileSync(filePath, 'utf-8');
    return JSON.parse(raw) as T;
  } catch (error) {
    throw new Error(
      `Failed to read static data file: ${filePath}\n` +
        `Run "cd api && npm run build && node scripts/export-static-data.js" first.\n` +
        `Original error: ${error instanceof Error ? error.message : error}`,
    );
  }
}

/**
 * Get all awesome lists from static JSON.
 *
 * Drop-in replacement for getAwesomeLists() from ./api.
 * Returns { data: AwesomeList[] } matching the API response shape.
 * Respects BUILD_SLUG env var to filter to a single list.
 */
export function getStaticLists(): { data: AwesomeList[] } {
  const result = readJsonFile<{ data: AwesomeList[] }>('lists.json');
  const buildSlug = process.env.BUILD_SLUG;
  if (buildSlug) {
    result.data = result.data.filter((list) => list.slug === buildSlug);
  }
  return result;
}

/**
 * Get all repo slugs from static JSON.
 *
 * Drop-in replacement for the repo slug fetch in repos/[repoSlug]/page.tsx.
 * Returns { data: Array<{ repoSlug: string }> } matching the API response shape.
 */
export function getStaticRepoSlugs(): { data: Array<{ repoSlug: string }> } {
  return readJsonFile<{ data: Array<{ repoSlug: string }> }>('repo-slugs.json');
}
