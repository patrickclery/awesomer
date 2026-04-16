import { Injectable, Logger } from '@nestjs/common';
import { writeFile, mkdir, readdir, unlink } from 'fs/promises';
import { resolve, join } from 'path';
import { PrismaService } from '../prisma/prisma.service.js';
import { MIN_STARS, STALE_DAYS } from '../common/constants.js';

const LIVE_SITE_BASE = 'https://patrickclery.com/awesomer';

@Injectable()
export class MarkdownService {
  private readonly logger = new Logger(MarkdownService.name);

  constructor(private readonly prisma: PrismaService) {}

  // ===========================================================================
  // Public API
  // ===========================================================================

  async generateAll(outputDir?: string): Promise<string[]> {
    const files: string[] = [];
    files.push(...(await this.generateHomepage(outputDir)));
    files.push(...(await this.generateListPages(outputDir)));
    files.push(...(await this.generateRepoPages(outputDir)));
    await this.cleanupOldFiles(outputDir);
    this.logger.log(`Markdown generation complete: ${files.length} files`);
    return files;
  }

  // ===========================================================================
  // Output directory resolution
  // ===========================================================================

  private resolveOutputDir(outputDir?: string): string {
    return outputDir ?? resolve(process.cwd(), '..', 'static', 'awesomer');
  }

  // ===========================================================================
  // Homepage (README.md) — D-01, D-02, D-03, D-13, D-14
  // ===========================================================================

  private async generateHomepage(outputDir?: string): Promise<string[]> {
    const lines: string[] = [];

    // Section 1: Title and tagline
    lines.push('# Awesomer');
    lines.push('');
    lines.push('What if every Awesome List had a trending page? Now they do.');
    lines.push('');
    lines.push(`[Live site ↗](${LIVE_SITE_BASE}/) | [GitHub ↗](https://github.com/patrickclery/awesomer)`);
    lines.push('');

    // Section 2: Hero trending list (D-01)
    await this.appendHeroSection(lines);

    // Section 3: Top 10 trending repos (D-02)
    await this.appendTop10TrendingRepos(lines);

    // Section 4: All awesome lists (D-03)
    await this.appendAllListsTable(lines);

    // Section 5: Footer
    const today = new Date().toISOString().substring(0, 10);
    lines.push('---');
    lines.push(`*Updated: ${today} | [View live site ↗](${LIVE_SITE_BASE}/)*`);
    lines.push('');

    const content = lines.join('\n');

    // Write to output directory
    const resolvedDir = this.resolveOutputDir(outputDir);
    await mkdir(resolvedDir, { recursive: true });
    await mkdir(join(resolvedDir, 'l'), { recursive: true });
    await mkdir(join(resolvedDir, 'r'), { recursive: true });
    await writeFile(join(resolvedDir, 'README.md'), content, 'utf-8');

    // Also write to repo root so github.com/patrickclery/awesomer shows trending data
    const repoRoot = resolve(process.cwd(), '..');
    await writeFile(join(repoRoot, 'README.md'), content, 'utf-8');

    this.logger.log('  Generated: README.md (deploy + repo root)');
    return ['README.md'];
  }

  // ===========================================================================
  // Hero trending list section (D-01)
  // ===========================================================================

  private async appendHeroSection(lines: string[]): Promise<void> {
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false, repo: { isNot: null } },
      include: {
        repo: { select: { stars: true, stars7d: true, stars30d: true, stars90d: true, description: true } },
      },
      orderBy: { repo: { stars7d: 'desc' } },
      take: 1,
    });

    if (lists.length === 0) return;

    const hero = lists[0];
    const repo = hero.repo;

    lines.push(`## Hottest This Week: [${hero.name}](l/${hero.slug}.md)`);
    lines.push('');
    if (repo?.description) {
      lines.push(`> ${this.escapeTableCell(repo.description)}`);
      lines.push('');
    }
    lines.push('| Stars | 7d | 30d | 90d |');
    lines.push('|-------|----|-----|-----|');
    lines.push(
      `| ${this.formatStars(repo?.stars ?? null)} | ${this.formatDelta(repo?.stars7d ?? null)} | ${this.formatDelta(repo?.stars30d ?? null)} | ${this.formatDelta(repo?.stars90d ?? null)} |`,
    );
    lines.push('');
  }

  // ===========================================================================
  // Top 10 trending repos section (D-02)
  // ===========================================================================

  private async appendTop10TrendingRepos(lines: string[]): Promise<void> {
    const topRepos = await this.prisma.repo.findMany({
      where: { stars7d: { not: null, gt: 0 }, stars: { gte: MIN_STARS } },
      orderBy: { stars7d: 'desc' },
      take: 10,
      include: {
        categoryItems: {
          take: 1,
          include: {
            category: {
              include: { awesomeList: { select: { name: true, slug: true } } },
            },
          },
        },
      },
    });

    if (topRepos.length === 0) return;

    lines.push('## Top 10 Trending Repos');
    lines.push('');
    lines.push('| # | Repo | List | Stars | 7d |');
    lines.push('|---|------|------|-------|----|');

    for (let i = 0; i < topRepos.length; i++) {
      const r = topRepos[i];
      const repoName = r.githubRepo.split('/').pop() ?? r.githubRepo;
      const repoLink = `[${repoName}](r/${this.repoSlug(r.githubRepo)}.md)`;

      const ci = r.categoryItems[0];
      const listName = ci?.category?.awesomeList?.name ?? '';
      const listSlug = ci?.category?.awesomeList?.slug ?? '';
      const listLink = listSlug ? `[${listName}](l/${listSlug}.md)` : listName;

      lines.push(
        `| ${i + 1} | ${repoLink} | ${listLink} | ${this.formatStars(r.stars)} | ${this.formatDelta(r.stars7d)} |`,
      );
    }

    lines.push('');
  }

  // ===========================================================================
  // All awesome lists table (D-03)
  // ===========================================================================

  private async appendAllListsTable(lines: string[]): Promise<void> {
    const allLists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      include: {
        repo: { select: { stars: true, stars7d: true, description: true } },
      },
      orderBy: { repo: { stars7d: 'desc' } },
    });

    if (allLists.length === 0) return;

    lines.push('## All Awesome Lists');
    lines.push('');
    lines.push('| List | Description | Stars | 7d |');
    lines.push('|------|-------------|-------|----|');

    for (const list of allLists) {
      const link = `[${list.name}](l/${list.slug}.md)`;
      const desc = this.escapeTableCell(list.repo?.description ?? '');
      const stars = this.formatStars(list.repo?.stars ?? null);
      const d7 = this.formatDelta(list.repo?.stars7d ?? null);
      lines.push(`| ${link} | ${desc} | ${stars} | ${d7} |`);
    }

    lines.push('');
  }

  // ===========================================================================
  // List pages (l/{slug}.md) — D-04, D-05, D-06, D-07, D-11, D-13, D-14
  // ===========================================================================

  private async generateListPages(outputDir?: string): Promise<string[]> {
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      include: {
        repo: {
          select: { description: true, stars: true, stars7d: true, stars30d: true, stars90d: true },
        },
        categories: {
          orderBy: { name: 'asc' },
          include: {
            categoryItems: {
              where: { primaryUrl: { not: null } },
              include: {
                repo: {
                  select: {
                    githubRepo: true,
                    stars: true,
                    stars7d: true,
                    stars30d: true,
                    stars90d: true,
                    lastCommitAt: true,
                    description: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    const resolvedDir = join(this.resolveOutputDir(outputDir), 'l');
    await mkdir(resolvedDir, { recursive: true });

    const files: string[] = [];

    for (const list of lists) {
      const lines: string[] = [];

      // Section 1: Header
      const listDesc = list.repo?.description || 'Curated list of open-source tools.';
      lines.push(`# ${list.name}`);
      lines.push('');
      lines.push(`> ${this.escapeTableCell(listDesc)}`);
      lines.push('');
      lines.push(
        `[Home](../README.md) | [Live site ↗](${LIVE_SITE_BASE}/l/${list.slug}/) | [Source ↗](https://github.com/${list.githubRepo})`,
      );
      lines.push('');

      // Collect all items across all categories for top 10
      const allItems = list.categories.flatMap((cat) => cat.categoryItems);

      // Section 2: Top 10 Trending (D-04) — only items with repo and stars7d > 0
      const seenRepoIds = new Set<number>();
      const top10Eligible = allItems
        .filter((item) => {
          if (item.repo === null || (item.repo.stars7d ?? 0) <= 0) return false;
          if (item.repoId !== null && seenRepoIds.has(item.repoId)) return false;
          if (item.repoId !== null) seenRepoIds.add(item.repoId);
          return true;
        })
        .sort((a, b) => (b.repo!.stars7d ?? 0) - (a.repo!.stars7d ?? 0))
        .slice(0, 10);

      if (top10Eligible.length >= 3) {
        lines.push('## Top 10 Trending');
        lines.push('');
        lines.push('| # | Repo | Stars | 7d | 30d | 90d |');
        lines.push('|---|------|-------|----|-----|-----|');

        for (let i = 0; i < top10Eligible.length; i++) {
          const item = top10Eligible[i];
          const name = item.name ?? 'Unknown';
          const repoLink = this.repoMdLink(item.repo!.githubRepo, name, true);
          lines.push(
            `| ${i + 1} | ${repoLink} | ${this.formatStars(item.repo!.stars)} | ${this.formatDelta(item.repo!.stars7d)} | ${this.formatDelta(item.repo!.stars30d)} | ${this.formatDelta(item.repo!.stars90d)} |`,
          );
        }

        lines.push('');
      }

      // Section 3: Table of Contents
      const catsWithItems = list.categories.filter((cat) => cat.categoryItems.length > 0);

      if (catsWithItems.length > 0) {
        lines.push('## Table of Contents');
        lines.push('');
        for (const cat of catsWithItems) {
          lines.push(`- [${cat.name}](#${this.tocSlug(cat.name)})`);
        }
        lines.push('');
      }

      // Section 4: Per-category sections (D-05, D-06, D-07)
      for (const cat of catsWithItems) {
        lines.push(`## ${cat.name}`);
        lines.push('');

        // Sort by 7-day trending (D-06), no syncThreshold cutoff (D-07)
        const sorted = [...cat.categoryItems].sort(
          (a, b) =>
            (b.repo?.stars7d ?? 0) - (a.repo?.stars7d ?? 0) ||
            (a.name ?? '').localeCompare(b.name ?? ''),
        );

        // Check if any items have star data for table vs bullet list
        const hasStarData = sorted.some(
          (item) => item.stars !== null || item.repo !== null,
        );

        if (hasStarData) {
          lines.push('| Repo | Description | Stars | 7d |');
          lines.push('|------|-------------|-------|----|');

          for (const item of sorted) {
            const name = item.name ?? 'Unknown';
            const desc = this.escapeTableCell(
              item.repo?.description || item.githubDescription || item.description || '',
            );
            const stars = this.formatStars(item.repo?.stars ?? item.stars);
            const d7 = this.formatDelta(item.repo?.stars7d ?? null);

            let nameLink: string;
            if (item.repo) {
              nameLink = this.repoMdLink(item.repo.githubRepo, name, true);
            } else {
              nameLink = `[${name}](${item.primaryUrl})`;
            }

            lines.push(`| ${nameLink} | ${desc} | ${stars} | ${d7} |`);
          }
        } else {
          for (const item of sorted) {
            const name = item.name ?? 'Unknown';
            const url = item.primaryUrl ?? '#';
            const desc = item.description
              ? ` - ${this.escapeTableCell(item.description)}`
              : '';
            lines.push(`- [${name}](${url})${desc}`);
          }
        }

        lines.push('');
        lines.push(`[Back to top](#${this.tocSlug(list.name)})`);
        lines.push('');
      }

      // Section 5: Footer
      const today = new Date().toISOString().substring(0, 10);
      lines.push('---');
      lines.push(`*Updated: ${today} | [View live site ↗](${LIVE_SITE_BASE}/l/${list.slug}/)*`);
      lines.push('');

      const content = lines.join('\n');

      // Skip lists with too little content
      if (content.split('\n').length < 5) continue;

      await writeFile(join(resolvedDir, `${list.slug}.md`), content, 'utf-8');
      this.logger.log(`  Generated: l/${list.slug}.md`);
      files.push(`static/awesomer/l/${list.slug}.md`);
    }

    this.logger.log(`  Generated ${files.length} list pages`);
    return files;
  }

  // ===========================================================================
  // Repo pages (r/{owner~repo}.md) — D-08, D-09, D-10, D-11, D-13, D-14, D-15
  // ===========================================================================

  private async generateRepoPages(outputDir?: string): Promise<string[]> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - STALE_DAYS);

    const repos = await this.prisma.repo.findMany({
      where: {
        stars: { gte: MIN_STARS },
        lastCommitAt: { gte: cutoffDate },
        categoryItems: {
          some: {
            category: {
              awesomeList: { archived: false },
            },
          },
        },
      },
      include: {
        categoryItems: {
          include: {
            category: {
              include: {
                awesomeList: {
                  select: { name: true, slug: true, archived: true },
                },
              },
            },
          },
        },
      },
    });

    this.logger.log(`  Generating repo pages for ${repos.length} qualifying repos...`);

    const resolvedDir = join(this.resolveOutputDir(outputDir), 'r');
    await mkdir(resolvedDir, { recursive: true });

    const files: string[] = [];
    const today = new Date().toISOString().substring(0, 10);

    for (let i = 0; i < repos.length; i++) {
      const repo = repos[i];
      const slug = this.repoSlug(repo.githubRepo);
      const lines: string[] = [];

      // Section 1: Header (D-08, D-15)
      lines.push(`# ${repo.githubRepo}`);
      lines.push('');
      lines.push(`> ${this.escapeTableCell(repo.description || 'No description available.')}`);
      lines.push('');
      lines.push(
        `[Home](../README.md) | [View on GitHub ↗](https://github.com/${repo.githubRepo}) | [Live site ↗](${LIVE_SITE_BASE}/r/${slug}/)`,
      );
      lines.push('');

      // Section 2: Stats table (D-08)
      lines.push('## Stats');
      lines.push('');
      lines.push('| Stars | 7d | 30d | 90d | Last Commit |');
      lines.push('|-------|----|-----|-----|-------------|');
      const lastCommit = repo.lastCommitAt
        ? repo.lastCommitAt.toISOString().substring(0, 10)
        : 'N/A';
      lines.push(
        `| ${this.formatStars(repo.stars)} | ${this.formatDelta(repo.stars7d)} | ${this.formatDelta(repo.stars30d)} | ${this.formatDelta(repo.stars90d)} | ${lastCommit} |`,
      );
      lines.push('');

      // Section 3: Found In (D-08, D-13)
      const foundIn = repo.categoryItems
        .filter((ci) => !ci.category.awesomeList.archived)
        .map((ci) => ({
          listName: ci.category.awesomeList.name,
          listSlug: ci.category.awesomeList.slug,
          categoryName: ci.category.name,
        }));

      // Deduplicate by listSlug + categoryName
      const seen = new Set<string>();
      const uniqueFoundIn = foundIn.filter((fi) => {
        const key = `${fi.listSlug}:${fi.categoryName}`;
        if (seen.has(key)) return false;
        seen.add(key);
        return true;
      });

      if (uniqueFoundIn.length > 0) {
        lines.push('## Found In');
        lines.push('');
        for (const fi of uniqueFoundIn) {
          const listLink = this.listMdLink(fi.listSlug, fi.listName, true);
          lines.push(`- ${listLink} / ${fi.categoryName}`);
        }
        lines.push('');
      }

      // Section 4: Footer
      lines.push('---');
      lines.push(`*Updated: ${today} | [View live site ↗](${LIVE_SITE_BASE}/r/${slug}/)*`);
      lines.push('');

      const content = lines.join('\n');
      const outputPath = join(resolvedDir, `${slug}.md`);
      await writeFile(outputPath, content, 'utf-8');
      files.push(`static/awesomer/r/${slug}.md`);

      // Log progress every 500 repos
      if ((i + 1) % 500 === 0) {
        this.logger.log(`  Repo pages: ${i + 1}/${repos.length}...`);
      }
    }

    this.logger.log(`  Generated ${files.length} repo pages`);
    return files;
  }

  // ===========================================================================
  // Cleanup old flat .md files (D-12)
  // ===========================================================================

  private async cleanupOldFiles(outputDir?: string): Promise<void> {
    const resolvedDir = this.resolveOutputDir(outputDir);

    let entries: string[];
    try {
      entries = await readdir(resolvedDir);
    } catch {
      return; // Directory doesn't exist yet
    }

    const KEEP_FILES = new Set(['README.md', 'CONTRIBUTING.md', 'LICENSE.md', 'CHANGELOG.md']);
    const oldMdFiles = entries.filter(
      (f) => f.endsWith('.md') && !KEEP_FILES.has(f),
    );

    for (const file of oldMdFiles) {
      await unlink(join(resolvedDir, file));
      this.logger.log(`  Cleaned up old file: ${file}`);
    }

    if (oldMdFiles.length > 0) {
      this.logger.log(`  Removed ${oldMdFiles.length} old flat .md files`);
    }
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  private escapeTableCell(text: string): string {
    return text.replace(/\|/g, '\\|').replace(/\n/g, ' ').substring(0, 120);
  }

  private formatStars(stars: number | null): string {
    return stars !== null ? stars.toLocaleString() : '';
  }

  private formatDelta(delta: number | null): string {
    if (delta === null) return '';
    return (delta >= 0 ? '+' : '') + delta.toLocaleString();
  }

  private repoSlug(githubRepo: string): string {
    // Defense-in-depth: sanitize to prevent path traversal from malformed DB entries
    const slug = githubRepo.toLowerCase().replace('/', '~');
    const sanitized = slug.replace(/[^a-z0-9._~-]/g, '');
    if (sanitized.includes('..')) {
      throw new Error(`Invalid githubRepo for slug: ${githubRepo}`);
    }
    return sanitized;
  }

  private repoMdLink(githubRepo: string, name: string, fromSubdir: boolean): string {
    const slug = this.repoSlug(githubRepo);
    const prefix = fromSubdir ? '../r/' : 'r/';
    return `[${name}](${prefix}${slug}.md)`;
  }

  private listMdLink(slug: string, name: string, fromSubdir: boolean): string {
    const prefix = fromSubdir ? '../l/' : 'l/';
    return `[${name}](${prefix}${slug}.md)`;
  }

  private tocSlug(text: string): string {
    return text
      .toLowerCase()
      .replace(/[^\w\s-]/g, '')
      .replace(/\s+/g, '-');
  }
}
