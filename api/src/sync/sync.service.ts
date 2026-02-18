import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service.js';
import { GithubService } from './github.service.js';

const GRAPHQL_BATCH_SIZE = 100;

const TRENDING_PERIODS = [
  { column: 'stars7d' as const, days: 7 },
  { column: 'stars30d' as const, days: 30 },
  { column: 'stars90d' as const, days: 90 },
];
const TOLERANCE_DAYS = 3;

@Injectable()
export class SyncService {
  private readonly logger = new Logger(SyncService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly github: GithubService,
  ) {}

  // =========================================================================
  // Daily pipeline — runs at 2 AM
  // =========================================================================

  @Cron(CronExpression.EVERY_DAY_AT_2AM)
  async runDailySync() {
    this.logger.log('Starting daily sync pipeline...');

    try {
      await this.syncGithubStats();
      await this.takeStarSnapshots();
      await this.computeTrending();
      await this.generateMarkdown();
      await this.rebuildStaticSite();
      this.logger.log('Daily sync pipeline completed');
    } catch (error) {
      this.logger.error('Daily sync pipeline failed', error);
    }
  }

  // =========================================================================
  // Step 1: Import from Awesome List
  // =========================================================================

  async importAwesomeList(awesomeListId: number) {
    const list = await this.prisma.awesomeList.findUnique({
      where: { id: awesomeListId },
    });
    if (!list) throw new Error(`Awesome list ${awesomeListId} not found`);

    const parsed = GithubService.parseGithubRepo(
      `https://github.com/${list.githubRepo}`,
    );
    if (!parsed) throw new Error(`Invalid GitHub repo: ${list.githubRepo}`);

    this.logger.log(`Importing ${list.githubRepo}...`);

    const readme = await this.github.fetchReadme(parsed.owner, parsed.name);
    if (!readme) throw new Error(`README not found for ${list.githubRepo}`);

    // Update readme_content
    await this.prisma.awesomeList.update({
      where: { id: awesomeListId },
      data: { readmeContent: readme },
    });

    // Parse markdown and extract categories/items
    const { categories, items } = this.parseReadmeMarkdown(readme);

    this.logger.log(
      `Parsed ${categories.length} categories with ${items.length} items`,
    );

    // Persist categories and items
    await this.persistParsedData(awesomeListId, categories, items);

    await this.prisma.awesomeList.update({
      where: { id: awesomeListId },
      data: { lastSyncedAt: new Date(), state: 'completed' },
    });

    this.logger.log(`Import complete for ${list.githubRepo}`);
    return { categories: categories.length, items: items.length };
  }

  // =========================================================================
  // Step 2: GitHub Stats Sync (REST API)
  // =========================================================================

  async syncGithubStats() {
    this.logger.log('Step 2: Syncing GitHub stats...');

    const repos = await this.prisma.repo.findMany({
      where: { githubRepo: { not: '' } },
      select: { id: true, githubRepo: true },
    });

    let updated = 0;
    let failed = 0;

    for (const repo of repos) {
      const parsed = GithubService.parseGithubRepo(
        `https://github.com/${repo.githubRepo}`,
      );
      if (!parsed) continue;

      const stats = await this.github.fetchRepoStats(
        parsed.owner,
        parsed.name,
      );

      if (stats) {
        await this.prisma.repo.update({
          where: { id: repo.id },
          data: {
            stars: stats.stars,
            description: stats.description,
            lastCommitAt: stats.lastCommitAt,
          },
        });

        // Also update category_items linked to this repo
        await this.prisma.categoryItem.updateMany({
          where: { repoId: repo.id },
          data: {
            stars: stats.stars,
            githubDescription: stats.description,
            lastCommitAt: stats.lastCommitAt,
          },
        });

        updated++;
      } else {
        failed++;
      }

      if ((updated + failed) % 100 === 0) {
        this.logger.log(
          `  Stats progress: ${updated + failed}/${repos.length} (${updated} updated, ${failed} failed)`,
        );
      }
    }

    this.logger.log(
      `Stats sync complete: ${updated} updated, ${failed} failed out of ${repos.length}`,
    );
    return { updated, failed, total: repos.length };
  }

  // =========================================================================
  // Step 3: Star Snapshots (GraphQL batch)
  // =========================================================================

  async takeStarSnapshots() {
    this.logger.log('Step 3: Taking star snapshots...');

    const repos = await this.prisma.repo.findMany({
      where: { githubRepo: { not: '' } },
      select: { id: true, githubRepo: true },
    });

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    let snapshotted = 0;
    let skipped = 0;

    // Process in batches of 100 for GraphQL
    for (let i = 0; i < repos.length; i += GRAPHQL_BATCH_SIZE) {
      const batch = repos.slice(i, i + GRAPHQL_BATCH_SIZE);

      const batchWithParsed = batch
        .map((repo) => {
          const parsed = GithubService.parseGithubRepo(
            `https://github.com/${repo.githubRepo}`,
          );
          return parsed ? { id: repo.id, owner: parsed.owner, name: parsed.name } : null;
        })
        .filter(Boolean) as Array<{
        id: number;
        owner: string;
        name: string;
      }>;

      const results = await this.github.batchFetchStars(batchWithParsed);

      for (const [repoId, data] of results) {
        try {
          await this.prisma.starSnapshot.upsert({
            where: {
              repoId_snapshotDate: { repoId, snapshotDate: today },
            },
            update: { stars: data.stargazerCount },
            create: {
              repoId,
              snapshotDate: today,
              stars: data.stargazerCount,
            },
          });

          // Also update the repo's stars and last_commit_at
          await this.prisma.repo.update({
            where: { id: repoId },
            data: {
              stars: data.stargazerCount,
              lastCommitAt: data.pushedAt ? new Date(data.pushedAt) : undefined,
            },
          });

          snapshotted++;
        } catch (error) {
          this.logger.warn(`Failed to snapshot repo ${repoId}: ${error}`);
          skipped++;
        }
      }

      this.logger.log(
        `  Snapshot progress: batch ${Math.floor(i / GRAPHQL_BATCH_SIZE) + 1}/${Math.ceil(repos.length / GRAPHQL_BATCH_SIZE)}`,
      );
    }

    this.logger.log(
      `Snapshots complete: ${snapshotted} snapshotted, ${skipped} skipped`,
    );
    return { snapshotted, skipped };
  }

  // =========================================================================
  // Step 4: Trending Computation
  // =========================================================================

  async computeTrending() {
    this.logger.log('Step 4: Computing trending...');

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    for (const period of TRENDING_PERIODS) {
      const pastTarget = new Date(today);
      pastTarget.setDate(pastTarget.getDate() - period.days);

      // Window boundaries for tolerance
      const todayWindowStart = new Date(today);
      todayWindowStart.setDate(todayWindowStart.getDate() - (TOLERANCE_DAYS - 1));

      const pastWindowStart = new Date(pastTarget);
      pastWindowStart.setDate(pastWindowStart.getDate() - (TOLERANCE_DAYS - 1));

      let updated = 0;

      const repos = await this.prisma.repo.findMany({
        select: { id: true },
      });

      for (const repo of repos) {
        // Find most recent snapshot within today's tolerance window
        const todaySnap = await this.prisma.starSnapshot.findFirst({
          where: {
            repoId: repo.id,
            snapshotDate: { gte: todayWindowStart, lte: today },
          },
          orderBy: { snapshotDate: 'desc' },
        });

        // Find most recent snapshot within past tolerance window
        const pastSnap = await this.prisma.starSnapshot.findFirst({
          where: {
            repoId: repo.id,
            snapshotDate: { gte: pastWindowStart, lte: pastTarget },
          },
          orderBy: { snapshotDate: 'desc' },
        });

        if (todaySnap && pastSnap) {
          const trending = todaySnap.stars - pastSnap.stars;
          await this.prisma.repo.update({
            where: { id: repo.id },
            data: { [period.column]: trending },
          });
          updated++;
        }
      }

      this.logger.log(
        `  ${period.column}: updated ${updated}/${repos.length} repos`,
      );
    }

    this.logger.log('Trending computation complete');
  }

  // =========================================================================
  // Step 5: Markdown Generation
  // =========================================================================

  async generateMarkdown() {
    this.logger.log('Step 5: Generating markdown...');

    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      include: {
        categories: {
          orderBy: { name: 'asc' },
          include: {
            categoryItems: {
              where: { primaryUrl: { not: null } },
              include: {
                repo: {
                  select: {
                    stars7d: true,
                    stars30d: true,
                    stars90d: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    const generatedFiles: string[] = [];

    for (const list of lists) {
      const content = this.generateListMarkdown(list);
      if (content.split('\n').length < 5 || content.length < 100) {
        this.logger.warn(`Skipping ${list.name}: content too short`);
        continue;
      }

      // Write to static/awesomer/ directory
      const filename = this.extractRepoName(list.githubRepo);
      const path = `static/awesomer/${filename}.md`;

      const fs = await import('fs');
      const pathModule = await import('path');
      const outputDir = pathModule.resolve(
        process.cwd(),
        '..',
        'static',
        'awesomer',
      );
      fs.mkdirSync(outputDir, { recursive: true });
      const outputPath = pathModule.join(outputDir, `${filename}.md`);
      fs.writeFileSync(outputPath, content, 'utf-8');

      generatedFiles.push(path);
      this.logger.log(`  Generated: ${path}`);
    }

    this.logger.log(
      `Markdown generation complete: ${generatedFiles.length} files`,
    );
    return generatedFiles;
  }

  // =========================================================================
  // Step 6: Rebuild Static Site
  // =========================================================================

  async rebuildStaticSite() {
    this.logger.log('Step 6: Rebuilding static site...');
    const { execSync } = await import('child_process');
    const path = await import('path');
    const webDir = path.resolve(process.cwd(), '..', 'web');
    try {
      execSync('npm run build', {
        cwd: webDir,
        stdio: 'inherit',
        timeout: 600_000,
        env: { ...process.env, NEXT_PUBLIC_API_URL: `http://localhost:${process.env.PORT ?? 4000}/api` },
      });
      this.logger.log('Static site rebuilt successfully');
    } catch (error) {
      this.logger.error('Static site build failed', error);
    }
  }

  // =========================================================================
  // Private: Markdown parsing
  // =========================================================================

  private parseReadmeMarkdown(content: string): {
    categories: Array<{ name: string; order: number }>;
    items: Array<{
      name: string;
      primaryUrl: string;
      githubRepo: string | null;
      description: string | null;
      categoryIndex: number;
    }>;
  } {
    const categories: Array<{ name: string; order: number }> = [];
    const items: Array<{
      name: string;
      primaryUrl: string;
      githubRepo: string | null;
      description: string | null;
      categoryIndex: number;
    }> = [];

    const SKIP_HEADERS =
      /^(Contents?|Table of Contents?|Contributing|License|Acknowledgments?|Credits?)$/i;
    const HEADER_RE = /^(#{2,3})\s+(.+)$/;
    const ITEM_RE =
      /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\s*[-:]\s*(?<description>.+))?/;

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

      // Check for list item
      const itemMatch = line.match(ITEM_RE);
      if (itemMatch?.groups && currentCategoryIndex >= 0) {
        const url = itemMatch.groups.url;
        const parsed = GithubService.parseGithubRepo(url);

        items.push({
          name: itemMatch.groups.name,
          primaryUrl: parsed
            ? `https://github.com/${parsed.owner}/${parsed.name}`
            : url,
          githubRepo: parsed ? `${parsed.owner}/${parsed.name}` : null,
          description: itemMatch.groups.description?.trim() || null,
          categoryIndex: currentCategoryIndex,
        });
      }
    }

    return { categories, items };
  }

  // =========================================================================
  // Private: Persist parsed data
  // =========================================================================

  private async persistParsedData(
    awesomeListId: number,
    categories: Array<{ name: string; order: number }>,
    items: Array<{
      name: string;
      primaryUrl: string;
      githubRepo: string | null;
      description: string | null;
      categoryIndex: number;
    }>,
  ) {
    // Create categories
    const categoryMap = new Map<number, number>(); // index → DB id

    for (const cat of categories) {
      const slug = this.slugify(`${awesomeListId}-${cat.name}`);
      const created = await this.prisma.category.upsert({
        where: { slug },
        update: { name: cat.name },
        create: {
          name: cat.name,
          slug,
          awesomeListId,
        },
      });
      categoryMap.set(cat.order, created.id);
    }

    // Create repos and category items
    for (const item of items) {
      const categoryId = categoryMap.get(item.categoryIndex);
      if (!categoryId) continue;

      let repoId: number | null = null;

      if (item.githubRepo) {
        const repo = await this.prisma.repo.upsert({
          where: { githubRepo: item.githubRepo },
          update: {},
          create: { githubRepo: item.githubRepo },
        });
        repoId = repo.id;
      }

      // Check if item already exists (by name + category)
      const existing = await this.prisma.categoryItem.findFirst({
        where: {
          categoryId,
          OR: [
            { primaryUrl: item.primaryUrl },
            { name: item.name, githubRepo: item.githubRepo },
          ],
        },
      });

      if (!existing) {
        await this.prisma.categoryItem.create({
          data: {
            name: item.name,
            primaryUrl: item.primaryUrl,
            githubRepo: item.githubRepo,
            description: item.description,
            categoryId,
            repoId,
          },
        });
      }
    }
  }

  // =========================================================================
  // Private: Markdown generation
  // =========================================================================

  private generateListMarkdown(
    list: {
      name: string;
      description: string | null;
      githubRepo: string;
      syncThreshold: number | null;
      sortPreference: string;
      categories: Array<{
        name: string;
        categoryItems: Array<{
          name: string | null;
          primaryUrl: string | null;
          description: string | null;
          githubDescription: string | null;
          stars: number | null;
          lastCommitAt: Date | null;
          repo: { stars7d: number | null; stars30d: number | null; stars90d: number | null } | null;
        }>;
      }>;
    },
  ): string {
    const threshold = list.syncThreshold ?? 10;
    const sections: string[] = [];
    const tocEntries: string[] = [];

    // Title & description
    sections.push(`# ${list.name}\n`);
    if (list.description) {
      sections.push(`${list.description}\n`);
    }
    sections.push(
      `**Source:** [${list.githubRepo}](https://github.com/${list.githubRepo})\n`,
    );

    // Collect all items across categories for Top 10
    const allItems = list.categories.flatMap((cat) =>
      cat.categoryItems.map((item) => ({ ...item, categoryName: cat.name })),
    );

    // Top 10: Stars
    const top10Stars = this.generateTop10Section(
      'Top 10: Stars',
      allItems,
      threshold,
      (a, b) => (b.stars ?? 0) - (a.stars ?? 0),
    );

    // Top 10: 30-Day Trending
    const top10Trending30d = this.generateTop10Section(
      'Top 10: 30-Day Trending',
      allItems.filter((i) => i.repo?.stars30d && i.repo.stars30d > 0),
      0,
      (a, b) => (b.repo?.stars30d ?? 0) - (a.repo?.stars30d ?? 0),
    );

    // Top 10: 90-Day Trending
    const top10Trending90d = this.generateTop10Section(
      'Top 10: 90-Day Trending',
      allItems.filter((i) => i.repo?.stars90d && i.repo.stars90d > 0),
      0,
      (a, b) => (b.repo?.stars90d ?? 0) - (a.repo?.stars90d ?? 0),
    );

    // ToC entries for top 10 sections
    if (top10Stars) tocEntries.push('- [Top 10: Stars](#top-10-stars)');
    if (top10Trending30d)
      tocEntries.push(
        '- [Top 10: 30-Day Trending](#top-10-30-day-trending)',
      );
    if (top10Trending90d)
      tocEntries.push(
        '- [Top 10: 90-Day Trending](#top-10-90-day-trending)',
      );

    // Category sections
    const categorySections: string[] = [];
    for (const cat of list.categories) {
      const catItems = cat.categoryItems
        .filter((i) => i.primaryUrl)
        .filter((i) => {
          if (i.stars !== null && i.stars < threshold) return false;
          return true;
        });

      if (catItems.length === 0) continue;

      const sorted =
        list.sortPreference === 'trending_30d'
          ? [...catItems].sort(
              (a, b) =>
                (b.repo?.stars30d ?? 0) - (a.repo?.stars30d ?? 0) ||
                (a.name ?? '').localeCompare(b.name ?? ''),
            )
          : [...catItems].sort(
              (a, b) =>
                (b.stars ?? 0) - (a.stars ?? 0) ||
                (a.name ?? '').localeCompare(b.name ?? ''),
            );

      const slug = this.tocSlug(cat.name);
      tocEntries.push(`- [${cat.name}](#${slug})`);

      let section = `## ${cat.name}\n\n`;

      if (sorted.some((i) => i.stars !== null)) {
        section += '| Name | Description | Stars | 7d | 30d | 90d | Last Commit |\n';
        section += '|------|-------------|-------|----|-----|-----|-------------|\n';
        for (const item of sorted) {
          const name = item.name ?? 'Unknown';
          const url = item.primaryUrl ?? '#';
          const desc =
            (item.githubDescription || item.description || '')
              .replace(/\|/g, '\\|')
              .substring(0, 120) || '';
          const stars =
            item.stars !== null ? item.stars.toLocaleString() : '';
          const d7 = item.repo?.stars7d
            ? `+${item.repo.stars7d}`
            : '';
          const d30 = item.repo?.stars30d
            ? `+${item.repo.stars30d}`
            : '';
          const d90 = item.repo?.stars90d
            ? `+${item.repo.stars90d}`
            : '';
          const commit = item.lastCommitAt
            ? item.lastCommitAt.toISOString().substring(0, 10)
            : 'N/A';

          section += `| [${name}](${url}) | ${desc} | ${stars} | ${d7} | ${d30} | ${d90} | ${commit} |\n`;
        }
      } else {
        for (const item of sorted) {
          const name = item.name ?? 'Unknown';
          const url = item.primaryUrl ?? '#';
          const desc = item.description ? ` - ${item.description}` : '';
          section += `- [${name}](${url})${desc}\n`;
        }
      }

      section += '\n[Back to Top](#table-of-contents)\n';
      categorySections.push(section);
    }

    // Assemble final content
    const toc =
      tocEntries.length > 0
        ? `## Table of Contents\n\n${tocEntries.join('\n')}\n`
        : '';

    const output = [
      ...sections,
      toc,
      ...(top10Stars ? [top10Stars] : []),
      ...(top10Trending30d ? [top10Trending30d] : []),
      ...(top10Trending90d ? [top10Trending90d] : []),
      ...categorySections,
    ].join('\n');

    return output;
  }

  private generateTop10Section(
    title: string,
    items: Array<{
      name: string | null;
      primaryUrl: string | null;
      stars: number | null;
      lastCommitAt: Date | null;
      categoryName: string;
      repo: { stars7d: number | null; stars30d: number | null; stars90d: number | null } | null;
    }>,
    threshold: number,
    sortFn: (
      a: { stars: number | null; repo: { stars7d: number | null; stars30d: number | null; stars90d: number | null } | null },
      b: { stars: number | null; repo: { stars7d: number | null; stars30d: number | null; stars90d: number | null } | null },
    ) => number,
  ): string | null {
    const eligible = items
      .filter((i) => i.stars !== null && i.stars >= threshold)
      .sort(sortFn)
      .slice(0, 10);

    if (eligible.length < 10) return null;

    let section = `## ${title}\n\n`;
    section +=
      '| Name | Category | Stars | 7d | 30d | 90d | Last Commit |\n';
    section +=
      '|------|----------|-------|----|-----|-----|-------------|\n';

    for (const item of eligible) {
      const name = item.name ?? 'Unknown';
      const url = item.primaryUrl ?? '#';
      const stars =
        item.stars !== null ? item.stars.toLocaleString() : '';
      const d7 = item.repo?.stars7d ? `+${item.repo.stars7d}` : '';
      const d30 = item.repo?.stars30d ? `+${item.repo.stars30d}` : '';
      const d90 = item.repo?.stars90d ? `+${item.repo.stars90d}` : '';
      const commit = item.lastCommitAt
        ? item.lastCommitAt.toISOString().substring(0, 10)
        : 'N/A';

      section += `| [${name}](${url}) | ${item.categoryName} | ${stars} | ${d7} | ${d30} | ${d90} | ${commit} |\n`;
    }

    section += '\n[Back to Top](#table-of-contents)\n';
    return section;
  }

  // =========================================================================
  // Utilities
  // =========================================================================

  private slugify(text: string): string {
    return text
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '')
      .substring(0, 100);
  }

  private tocSlug(text: string): string {
    return text
      .toLowerCase()
      .replace(/[^\w\s-]/g, '')
      .replace(/\s+/g, '-');
  }

  private extractRepoName(githubRepo: string): string {
    const parts = githubRepo.split('/');
    return parts[parts.length - 1] || githubRepo;
  }
}
