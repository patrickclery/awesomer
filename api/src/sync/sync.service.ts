import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service.js';
import { GithubService } from './github.service.js';
import { BackfillService } from './backfill.service.js';
import { StaticDataService } from './static-data.service.js';
import { MarkdownService } from './markdown.service.js';
import { replaceEmojiShortcodes } from '../common/emoji.js';
import { META_AWESOME_LIST_SLUG } from '../common/constants.js';
import { getParser } from './parsers/parser-factory.js';

const GRAPHQL_BATCH_SIZE = 100;

const TRENDING_PERIODS = [
  { column: 'stars7d' as const, days: 7 },
  { column: 'stars30d' as const, days: 30 },
  { column: 'stars90d' as const, days: 90 },
];
const TOLERANCE_DAYS = 3;

export type SyncStep = 'diff' | 'stats' | 'snapshots' | 'trending' | 'markdown' | 'rebuild' | 'deploy';

const ALL_STEPS: SyncStep[] = ['diff', 'stats', 'snapshots', 'trending', 'markdown', 'rebuild', 'deploy'];

@Injectable()
export class SyncService {
  private readonly logger = new Logger(SyncService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly github: GithubService,
    private readonly backfill: BackfillService,
    private readonly staticData: StaticDataService,
    private readonly markdown: MarkdownService,
  ) {}

  // =========================================================================
  // Daily pipeline — runs at 6 AM EST (11 AM UTC)
  // =========================================================================

  // 6 AM EST = 11 AM UTC (EST is UTC-5)
  @Cron('0 11 * * *')
  async runDailyPipeline() {
    this.logger.log('Starting daily pipeline (6 AM EST)...');

    try {
      // Step 1: Diff-sync all awesome lists — picks up new entries
      const lists = await this.prisma.awesomeList.findMany({
        where: { archived: false },
      });
      for (const list of lists) {
        try {
          await this.diffSyncAwesomeList(list.id);
        } catch (err) {
          this.logger.error(`Failed to diff-sync ${list.githubRepo}: ${err}`);
        }
      }

      // Step 2: Fetch GitHub stats via GraphQL (stars, description, lastCommitAt)
      // This is the authoritative source for today's star count — GitHub
      // GraphQL API returns exact current values.
      await this.takeStarSnapshots();

      // Step 3: Compute trending deltas (7d/30d/90d)
      await this.computeTrending();

      // Step 4: Generate markdown files
      await this.generateMarkdown();

      // Step 5: Rebuild static site
      await this.rebuildStaticSite();

      // Step 6: Deploy to GitHub Pages
      await this.deployStaticSite();

      this.logger.log('Daily pipeline completed successfully');
    } catch (error) {
      this.logger.error('Daily pipeline failed', error);
    }
  }

  // =========================================================================
  // Legacy sync — manual-only via API (no cron trigger)
  // =========================================================================

  async runDailySync(steps?: SyncStep[]) {
    const run = new Set(steps ?? ALL_STEPS);
    this.logger.log(`Starting sync pipeline (steps: ${[...run].join(', ')})...`);

    try {
      if (run.has('diff')) {
        const lists = await this.prisma.awesomeList.findMany({
          where: { archived: false },
        });
        for (const list of lists) {
          await this.diffSyncAwesomeList(list.id);
        }
      }
      if (run.has('stats'))     await this.syncGithubStats();
      if (run.has('snapshots')) await this.takeStarSnapshots();
      if (run.has('trending'))  await this.computeTrending();
      if (run.has('markdown'))  await this.generateMarkdown();
      if (run.has('rebuild'))   await this.rebuildStaticSite();
      if (run.has('deploy'))    await this.deployStaticSite();
      this.logger.log('Sync pipeline completed');
    } catch (error) {
      this.logger.error('Sync pipeline failed', error);
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

    // Create/find the Repo record for the list's own GitHub repo (D-04, D-05)
    const listRepo = await this.prisma.repo.upsert({
      where: { githubRepo: list.githubRepo },
      update: {},
      create: { githubRepo: list.githubRepo },
    });

    // Link the list to its own repo if not already linked
    if (list.repoId !== listRepo.id) {
      await this.prisma.awesomeList.update({
        where: { id: awesomeListId },
        data: { repoId: listRepo.id },
      });
    }

    this.logger.log(`Importing ${list.githubRepo}...`);

    const readme = await this.github.fetchReadme(parsed.owner, parsed.name);
    if (!readme) throw new Error(`README not found for ${list.githubRepo}`);

    // Update readme_content
    await this.prisma.awesomeList.update({
      where: { id: awesomeListId },
      data: { readmeContent: readme },
    });

    // Parse markdown and extract categories/items
    const parser = getParser(list.parserType);
    const { categories, items } = parser.parse(readme);

    // Filter out items that reference other awesome lists
    // (the "awesome" meta-list is exempt since it catalogs all lists)
    const filteredItems = await this.filterAwesomeListRepos(list.slug, items);

    this.logger.log(
      `Parsed ${categories.length} categories with ${filteredItems.length} items` +
        (items.length !== filteredItems.length
          ? ` (${items.length - filteredItems.length} awesome-list refs filtered)`
          : ''),
    );

    // Persist categories and items
    const repoIds = await this.persistParsedData(awesomeListId, categories, filteredItems);

    await this.prisma.awesomeList.update({
      where: { id: awesomeListId },
      data: { lastSyncedAt: new Date(), state: 'completed' },
    });

    this.logger.log(`Import complete for ${list.githubRepo}`);

    // Post-import: fetch stats, snapshots, backfill, and trending for new repos
    // Include the list's own repo in hydration so it gets star data immediately
    const allRepoIds = [...new Set([listRepo.id, ...repoIds])];
    if (allRepoIds.length > 0) {
      this.logger.log(`Post-import: processing ${allRepoIds.length} repos (stats → snapshots → backfill → trending)`);
      try {
        await this.syncGithubStatsForRepos(allRepoIds);
        await this.takeStarSnapshotsForRepos(
          await this.prisma.repo.findMany({
            where: { id: { in: allRepoIds }, githubRepo: { not: '' } },
            select: { id: true, githubRepo: true },
          }),
        );
        await this.backfill.backfillStarSnapshotsForRepos(allRepoIds);
        await this.computeTrendingForRepos(allRepoIds);
        this.logger.log(`Post-import chain complete for ${allRepoIds.length} repos`);
      } catch (error) {
        this.logger.error(`Post-import chain failed (import data preserved): ${error}`);
      }
    }

    return { categories: categories.length, items: filteredItems.length };
  }

  async diffSyncAwesomeList(awesomeListId: number) {
    const list = await this.prisma.awesomeList.findUnique({
      where: { id: awesomeListId },
    });
    if (!list) throw new Error(`Awesome list ${awesomeListId} not found`);

    const parsed = GithubService.parseGithubRepo(
      `https://github.com/${list.githubRepo}`,
    );
    if (!parsed) throw new Error(`Invalid GitHub repo: ${list.githubRepo}`);

    // Create/find the Repo record for the list's own GitHub repo (D-04, D-05)
    const listRepo = await this.prisma.repo.upsert({
      where: { githubRepo: list.githubRepo },
      update: {},
      create: { githubRepo: list.githubRepo },
    });

    // Link the list to its own repo if not already linked
    if (list.repoId !== listRepo.id) {
      await this.prisma.awesomeList.update({
        where: { id: awesomeListId },
        data: { repoId: listRepo.id },
      });
    }

    this.logger.log(`Diff-syncing ${list.githubRepo}...`);

    // 1. Fetch latest README from GitHub (one API call)
    const readme = await this.github.fetchReadme(parsed.owner, parsed.name);
    if (!readme) throw new Error(`README not found for ${list.githubRepo}`);

    await this.prisma.awesomeList.update({
      where: { id: awesomeListId },
      data: { readmeContent: readme },
    });

    // 2. Parse markdown into categories + items
    const parser = getParser(list.parserType);
    const { categories, items } = parser.parse(readme);
    const filteredItems = await this.filterAwesomeListRepos(list.slug, items);

    // 3. Build set of current README items keyed by primaryUrl
    const readmeUrls = new Set(filteredItems.map((i) => i.primaryUrl));

    // 4. Get all existing CategoryItems for this list
    const existingItems = await this.prisma.categoryItem.findMany({
      where: {
        category: { awesomeListId },
      },
      select: { id: true, primaryUrl: true },
    });

    // 5. Determine stale items (in DB but not in README)
    const staleIds = existingItems
      .filter((item) => item.primaryUrl && !readmeUrls.has(item.primaryUrl))
      .map((item) => item.id);

    // 6. Determine new items (in README but not in DB)
    const existingUrls = new Set(
      existingItems.map((item) => item.primaryUrl).filter(Boolean),
    );
    const newItems = filteredItems.filter(
      (item) => !existingUrls.has(item.primaryUrl),
    );

    // 7. Delete stale CategoryItems
    if (staleIds.length > 0) {
      await this.prisma.categoryItem.deleteMany({
        where: { id: { in: staleIds } },
      });
      this.logger.log(`Removed ${staleIds.length} stale items`);
    }

    // 8. Insert new items (reuse persistParsedData logic for categories + new items only)
    if (newItems.length > 0) {
      await this.persistParsedData(awesomeListId, categories, newItems);
      this.logger.log(`Added ${newItems.length} new items`);
    }

    // 9. Update sync timestamp
    await this.prisma.awesomeList.update({
      where: { id: awesomeListId },
      data: { lastSyncedAt: new Date() },
    });

    this.logger.log(
      `Diff-sync complete for ${list.githubRepo}: ` +
        `+${newItems.length} added, -${staleIds.length} removed, ` +
        `${existingItems.length - staleIds.length} unchanged`,
    );

    return {
      added: newItems.length,
      removed: staleIds.length,
      unchanged: existingItems.length - staleIds.length,
    };
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

    const repoIds = repos.map((r) => r.id);
    const result = await this.syncGithubStatsForRepos(repoIds);

    this.logger.log(
      `Stats sync complete: ${result.updated} updated, ${result.failed} failed out of ${result.total}`,
    );
    return result;
  }

  /**
   * Sync GitHub stats (stars, description, lastCommitAt) via REST API for a specific set of repos.
   * Updates both Repo records and linked CategoryItems.
   */
  async syncGithubStatsForRepos(repoIds: number[]): Promise<{ updated: number; failed: number; total: number }> {
    if (repoIds.length === 0) return { updated: 0, failed: 0, total: 0 };

    const repos = await this.prisma.repo.findMany({
      where: { id: { in: repoIds }, githubRepo: { not: '' } },
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
        const description = replaceEmojiShortcodes(stats.description);
        await this.prisma.repo.update({
          where: { id: repo.id },
          data: {
            stars: stats.stars,
            description,
            lastCommitAt: stats.lastCommitAt,
          },
        });

        // Also update category_items linked to this repo
        await this.prisma.categoryItem.updateMany({
          where: { repoId: repo.id },
          data: {
            stars: stats.stars,
            githubDescription: description,
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

    const result = await this.takeStarSnapshotsForRepos(repos);

    this.logger.log(
      `Snapshots complete: ${result.snapshotted} snapshotted, ${result.skipped} skipped`,
    );
    return result;
  }

  /**
   * Take star snapshots for a specific set of repos via GraphQL batch queries.
   * Updates Repo stars/description/lastCommitAt and syncs to linked CategoryItems.
   */
  async takeStarSnapshotsForRepos(
    repos: Array<{ id: number; githubRepo: string }>,
  ): Promise<{ snapshotted: number; skipped: number }> {
    if (repos.length === 0) return { snapshotted: 0, skipped: 0 };

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

          // Also update the repo's stars, description, and last_commit_at
          const gqlDescription = replaceEmojiShortcodes(data.description);
          await this.prisma.repo.update({
            where: { id: repoId },
            data: {
              stars: data.stargazerCount,
              description: gqlDescription,
              lastCommitAt: data.pushedAt ? new Date(data.pushedAt) : undefined,
            },
          });

          // Sync stars/description to linked category items
          await this.prisma.categoryItem.updateMany({
            where: { repoId },
            data: {
              stars: data.stargazerCount,
              githubDescription: gqlDescription,
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

    return { snapshotted, skipped };
  }

  // =========================================================================
  // Step 4: Trending Computation
  // =========================================================================

  async computeTrending() {
    this.logger.log('Step 4: Computing trending...');

    const repos = await this.prisma.repo.findMany({
      select: { id: true },
    });

    const repoIds = repos.map((r) => r.id);
    await this.computeTrendingForRepos(repoIds);

    this.logger.log('Trending computation complete');
  }

  /**
   * Compute trending deltas (7d/30d/90d) for a specific set of repos.
   * Compares star snapshots within tolerance windows at each period interval.
   */
  async computeTrendingForRepos(repoIds: number[]) {
    if (repoIds.length === 0) return;

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

      for (const repoId of repoIds) {
        // Find most recent snapshot within today's tolerance window
        const todaySnap = await this.prisma.starSnapshot.findFirst({
          where: {
            repoId,
            snapshotDate: { gte: todayWindowStart, lte: today },
          },
          orderBy: { snapshotDate: 'desc' },
        });

        // Find most recent snapshot within past tolerance window
        const pastSnap = await this.prisma.starSnapshot.findFirst({
          where: {
            repoId,
            snapshotDate: { gte: pastWindowStart, lte: pastTarget },
          },
          orderBy: { snapshotDate: 'desc' },
        });

        if (todaySnap && pastSnap) {
          const trending = todaySnap.stars - pastSnap.stars;
          await this.prisma.repo.update({
            where: { id: repoId },
            data: { [period.column]: trending },
          });
          updated++;
        }
      }

      this.logger.log(
        `  ${period.column}: updated ${updated}/${repoIds.length} repos`,
      );
    }
  }

  // =========================================================================
  // Hydrate new repos — fetch stars + compute trending immediately
  // =========================================================================

  /**
   * Fetch star snapshots and compute trending for newly imported repos.
   * Called after persistParsedData() so new repos appear with star data
   * and trending numbers immediately, without waiting for the daily pipeline.
   */
  async hydrateNewRepos(repoIds: number[]) {
    if (repoIds.length === 0) return;

    this.logger.log(`Hydrating ${repoIds.length} new repos (snapshots + trending)...`);

    // Fetch repo records for the new IDs
    const repos = await this.prisma.repo.findMany({
      where: { id: { in: repoIds }, githubRepo: { not: '' } },
      select: { id: true, githubRepo: true },
    });

    if (repos.length === 0) {
      this.logger.log('No valid repos to hydrate');
      return;
    }

    // Step 1: Take star snapshots via GraphQL batch
    const { snapshotted, skipped } = await this.takeStarSnapshotsForRepos(repos);
    this.logger.log(`Hydrate snapshots: ${snapshotted} snapshotted, ${skipped} skipped`);

    // Step 2: Compute trending deltas for these repos
    await this.computeTrendingForRepos(repoIds);
    this.logger.log(`Hydrate trending complete for ${repoIds.length} repos`);
  }

  // =========================================================================
  // Step 5: Markdown Generation
  // =========================================================================

  async generateMarkdown(outputDir?: string) {
    this.logger.log('Step 5: Generating markdown...');
    return this.markdown.generateAll(outputDir);
  }

  // =========================================================================
  // Step 6: Rebuild Static Site
  // =========================================================================

  async rebuildStaticSite() {
    this.logger.log('Step 6: Rebuilding static site...');
    const { execSync } = await import('child_process');
    const { writeFileSync, mkdirSync, rmSync } = await import('fs');
    const path = await import('path');
    const webDir = path.resolve(process.cwd(), '..', 'web');
    const dataDir = path.join(webDir, 'data');

    try {
      // Export static data files so Next.js build doesn't need a running API
      mkdirSync(dataDir, { recursive: true });

      const lastSnapshot = await this.staticData.getLastSnapshotDate();
      writeFileSync(path.join(dataDir, 'last-snapshot.json'), JSON.stringify({ lastSnapshotDate: lastSnapshot }));
      this.logger.log(`Exported last-snapshot.json: ${lastSnapshot}`);

      const lists = await this.staticData.exportAllLists();
      writeFileSync(path.join(dataDir, 'lists.json'), JSON.stringify(lists));
      this.logger.log(`Exported lists.json: ${lists.length} lists`);

      const repoSlugs = await this.staticData.exportRepoSlugs();
      writeFileSync(path.join(dataDir, 'repo-slugs.json'), JSON.stringify(repoSlugs));
      this.logger.log(`Exported repo-slugs.json: ${repoSlugs.length} slugs`);

      // Clear .next/ cache to prevent stale data
      rmSync(path.join(webDir, '.next'), { recursive: true, force: true });

      execSync('npm run build', {
        cwd: webDir,
        stdio: 'inherit',
        timeout: 600_000,
        env: { ...process.env, NEXT_PUBLIC_API_URL: `http://localhost:${process.env.PORT ?? 4000}/api`, BASE_PATH: process.env.BASE_PATH ?? '/awesomer' },
      });
      this.logger.log('Static site rebuilt successfully');
    } catch (error) {
      this.logger.error('Static site build failed', error);
    }
  }

  async deployStaticSite() {
    this.logger.log('Step 7: Deploying static site to GitHub Pages...');
    const { execSync } = await import('child_process');
    const { writeFileSync, mkdirSync, rmSync } = await import('fs');
    const path = await import('path');
    const projectRoot = path.resolve(process.cwd(), '..');
    const outDir = path.join(projectRoot, 'web', 'out');
    const deployDir = '/tmp/gh-pages-deploy';

    try {
      // Clean and prepare deploy directory
      rmSync(deployDir, { recursive: true, force: true });
      mkdirSync(deployDir, { recursive: true });

      // Copy static site build output
      execSync(`rsync -a ${outDir}/ ${deployDir}/`, { stdio: 'inherit', timeout: 120_000 });

      // Generate markdown files AFTER rsync (preserves existing ordering per Phase 24 decision)
      await this.generateMarkdown(deployDir);

      // Prevent Jekyll from ignoring _next/ directory
      writeFileSync(path.join(deployDir, '.nojekyll'), '');

      // Init fresh git repo, commit, force-push to gh-pages
      execSync('git init', { cwd: deployDir, timeout: 30_000 });
      execSync('git config user.name "Awesomer Deploy"', { cwd: deployDir });
      execSync('git config user.email "deploy@awesomer.dev"', { cwd: deployDir });
      execSync('git add -A', { cwd: deployDir, stdio: 'inherit', timeout: 60_000 });

      const date = new Date().toISOString().slice(0, 10);
      execSync(
        `git commit -m "deploy: daily sync ${date}"`,
        { cwd: deployDir, stdio: 'inherit', timeout: 60_000 },
      );

      // Get remote URL from the main repo to push gh-pages branch
      const remoteUrl = execSync('git remote get-url origin', { cwd: projectRoot })
        .toString()
        .trim();
      execSync(`git remote add origin ${remoteUrl}`, { cwd: deployDir });
      execSync('git push --force origin HEAD:gh-pages', {
        cwd: deployDir,
        stdio: 'inherit',
        timeout: 120_000,
      });

      this.logger.log('Static site deployed to gh-pages branch');
    } catch (error) {
      this.logger.error('Static site deployment failed', error);
    }
  }

  /**
   * Filter out items whose githubRepo matches a known AwesomeList.
   * The "awesome" meta-list is exempt — it catalogs awesome lists by design.
   */
  private async filterAwesomeListRepos(
    currentSlug: string,
    items: Array<{
      name: string;
      primaryUrl: string;
      githubRepo: string | null;
      description: string | null;
      categoryIndex: number;
    }>,
  ): Promise<typeof items> {
    const currentList = await this.prisma.awesomeList.findFirst({
      where: { slug: currentSlug },
      select: { githubRepo: true },
    });
    const selfRepo = currentList?.githubRepo?.toLowerCase() ?? '';

    // Meta-list keeps other awesome lists but still excludes itself
    if (currentSlug === META_AWESOME_LIST_SLUG) {
      return items.filter((item) => {
        if (!item.githubRepo) return true;
        return item.githubRepo.toLowerCase() !== selfRepo;
      });
    }

    const awesomeLists = await this.prisma.awesomeList.findMany({
      select: { githubRepo: true },
    });
    const awesomeListRepos = new Set(
      awesomeLists.map((l) => l.githubRepo.toLowerCase()),
    );

    const filtered = items.filter((item) => {
      if (!item.githubRepo) return true;
      return !awesomeListRepos.has(item.githubRepo.toLowerCase());
    });

    return filtered;
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
  ): Promise<number[]> {
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

    // Create repos and category items, tracking newly created repo IDs
    const newRepoIds: number[] = [];

    for (const item of items) {
      const categoryId = categoryMap.get(item.categoryIndex);
      if (!categoryId) continue;

      let repoId: number | null = null;

      if (item.githubRepo) {
        // Check if repo already exists to detect new creations
        const existingRepo = await this.prisma.repo.findUnique({
          where: { githubRepo: item.githubRepo },
          select: { id: true },
        });

        const repo = await this.prisma.repo.upsert({
          where: { githubRepo: item.githubRepo },
          update: {},
          create: { githubRepo: item.githubRepo },
        });
        repoId = repo.id;

        if (!existingRepo) {
          newRepoIds.push(repo.id);
        }
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

    return newRepoIds;
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
}
