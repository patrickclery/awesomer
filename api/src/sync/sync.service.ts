import { AsyncLocalStorage } from 'node:async_hooks';
import { existsSync, readdirSync } from 'fs';
import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import type { Prisma } from '../generated/prisma/client.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { GithubService } from './github.service.js';
import { BackfillService } from './backfill.service.js';
import { StaticDataService } from './static-data.service.js';
import { MarkdownService, readmeForMain } from './markdown.service.js';
import { replaceEmojiShortcodes } from '../common/emoji.js';
import { META_AWESOME_LIST_SLUG, SYNC_WRITE_LOCK_KEY } from '../common/constants.js';
import { getParser } from './parsers/parser-factory.js';
import { NUMBERED_NAME_RE, summarizeParseResult } from './parsers/parse-summary.js';
import type { ParseSummary } from './parsers/parse-summary.js';

const GRAPHQL_BATCH_SIZE = 100;

const TRENDING_PERIODS = [
  { column: 'stars7d' as const, days: 7 },
  { column: 'stars30d' as const, days: 30 },
  { column: 'stars90d' as const, days: 90 },
];
const TOLERANCE_DAYS = 3;
const DEPLOY_DIR = '/tmp/gh-pages-deploy';
// The Next.js payload names in a static export. Never widen this to a bare wildcard
// on the extension: real files such as robots.txt must publish.
const RSC_PAYLOAD_EXCLUDES = ['__next.*.txt', 'index.txt'];
const README_WORKTREE_DIR = '/tmp/awesomer-readme-worktree';
// Re-import refuses when the parse holds fewer than half the stored items, so a gutted
// upstream README cannot wipe a list.
const REIMPORT_MIN_RATIO = 0.5;

/** Quality counts of the rows one awesome list currently stores. */
export interface ListDataCounts {
  categories: number;
  emptyCategories: number;
  numberedCategories: number;
  items: number;
  nullDescriptions: number;
  badgeDescriptions: number;
  /** Items linked to a repo whose denormalized star count is missing (hidden from the site). */
  itemsWithoutStars: number;
}

/** Category and item totals, used to prove a re-import left other lists alone. */
export interface ListScopeCounts {
  categories: number;
  items: number;
}

/** What reimportAwesomeList() found, parsed and (when applied) wrote. */
export interface ReimportReport {
  awesomeListId: number;
  slug: string;
  applied: boolean;
  before: ListDataCounts;
  parsed: ParseSummary;
  after: ListDataCounts | null;
  otherListsBefore: ListScopeCounts;
  otherListsAfter: ListScopeCounts | null;
  /** Repo rows the apply created (null on a dry run). Undoing an apply must delete these. */
  newRepoIds: number[] | null;
}

export type SyncStep = 'diff' | 'stats' | 'snapshots' | 'trending' | 'markdown' | 'rebuild' | 'deploy';

const ALL_STEPS: SyncStep[] = ['diff', 'stats', 'snapshots', 'trending', 'markdown', 'rebuild', 'deploy'];

@Injectable()
export class SyncService {
  private readonly logger = new Logger(SyncService.name);
  // Marks the async call chain that already holds the sync write lock, so nested calls
  // (the daily pipeline's diff-syncs, the re-import CLI's dry run then apply) re-enter it.
  private readonly syncLockHeld = new AsyncLocalStorage<true>();

  constructor(
    private readonly prisma: PrismaService,
    private readonly github: GithubService,
    private readonly backfill: BackfillService,
    private readonly staticData: StaticDataService,
    private readonly markdown: MarkdownService,
  ) {}

  /**
   * Runs `fn` while holding the cross-process sync write lock (SYNC_WRITE_LOCK_KEY), so
   * the nightly pipeline, a manual sync or import, and a re-import never overlap. Throws
   * without running `fn` when another session holds the lock. Re-entrant within one
   * async call chain.
   */
  async runExclusive<T>(label: string, fn: () => Promise<T>): Promise<T> {
    if (this.syncLockHeld.getStore()) return fn();
    const release = await this.prisma.tryAdvisoryLock(SYNC_WRITE_LOCK_KEY);
    if (!release) {
      throw new Error(`Refusing to ${label}: another sync, import or re-import holds the sync write lock`);
    }
    try {
      return await this.syncLockHeld.run(true, fn);
    } finally {
      await release();
    }
  }

  // =========================================================================
  // Daily pipeline — runs at 6 AM EST (11 AM UTC)
  // =========================================================================

  // 6 AM EST = 11 AM UTC (EST is UTC-5)
  @Cron('0 11 * * *')
  async runDailyPipeline() {
    return this.runExclusive('run the daily pipeline', async () => {
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

        // Step 4: Rebuild static site
        await this.rebuildStaticSite();

        // Step 5: Deploy to GitHub Pages (markdown is generated inside, after rsync)
        const markdownDir = await this.deployStaticSite();

        // Step 6: Commit the README generated in step 5 to main. The l/ and r/ pages stay on gh-pages.
        await this.commitReadmeToMain(markdownDir);

        this.logger.log('Daily pipeline completed successfully');
      } catch (error) {
        this.logger.error('Daily pipeline failed', error);
        throw error;
      }
    });
  }

  // =========================================================================
  // Legacy sync — manual-only via API (no cron trigger)
  // =========================================================================

  async runDailySync(steps?: SyncStep[]) {
    const run = new Set(steps ?? ALL_STEPS);
    this.logger.log(`Starting sync pipeline (steps: ${[...run].join(', ')})...`);

    try {
      await this.runExclusive('run the sync pipeline', async () => {
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
      });
    } catch (error) {
      this.logger.error('Sync pipeline failed', error);
    }
  }

  // =========================================================================
  // Step 1: Import from Awesome List
  // =========================================================================

  async importAwesomeList(awesomeListId: number) {
    return this.runExclusive(`import list ${awesomeListId}`, () => this.importAwesomeListLocked(awesomeListId));
  }

  private async importAwesomeListLocked(awesomeListId: number) {
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

    // Some lists are generated from a JSON data file rather than a README; the parser declares
    // which file to read via `sourcePath` (undefined means use the README).
    const parser = getParser(list.parserType);
    const sourcePath = parser.sourcePath;
    const source = sourcePath
      ? await this.github.fetchFileContent(parsed.owner, parsed.name, sourcePath)
      : await this.github.fetchReadme(parsed.owner, parsed.name);
    if (!source) throw new Error(`Source content not found for ${list.githubRepo}`);

    // Update readme_content
    await this.prisma.awesomeList.update({
      where: { id: awesomeListId },
      data: { readmeContent: source },
    });

    // Parse source and extract categories/items
    const { categories, items } = parser.parse(source);

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
    return this.runExclusive(`diff-sync list ${awesomeListId}`, () => this.diffSyncAwesomeListLocked(awesomeListId));
  }

  private async diffSyncAwesomeListLocked(awesomeListId: number) {
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

    // 1. Fetch the latest source from GitHub (one API call). The parser decides whether that is
    // the README or a repo-relative data file it declares via `sourcePath`.
    const parser = getParser(list.parserType);
    const sourcePath = parser.sourcePath;
    const source = sourcePath
      ? await this.github.fetchFileContent(parsed.owner, parsed.name, sourcePath)
      : await this.github.fetchReadme(parsed.owner, parsed.name);
    if (!source) throw new Error(`Source content not found for ${list.githubRepo}`);

    await this.prisma.awesomeList.update({
      where: { id: awesomeListId },
      data: { readmeContent: source },
    });

    // 2. Parse the source into categories + items
    const { categories, items } = parser.parse(source);
    const filteredItems = await this.filterAwesomeListRepos(list.slug, items);

    // Safeguard: never wipe a list. If parsing returned 0 items but the list
    // has existing items, the upstream README was likely cleared/restructured
    // (e.g. "update in progress"). Skip the sync rather than delete everything.
    if (filteredItems.length === 0) {
      const existingCount = await this.prisma.categoryItem.count({
        where: { category: { awesomeListId } },
      });
      if (existingCount > 0) {
        this.logger.warn(
          `Diff-sync skipped for ${list.githubRepo}: parser returned 0 items but DB has ${existingCount} existing items (upstream README likely wiped). Preserving existing items.`,
        );
        await this.prisma.awesomeList.update({
          where: { id: awesomeListId },
          data: { lastSyncedAt: new Date() },
        });
        return { added: 0, removed: 0, unchanged: existingCount };
      }
    }

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

  /**
   * Clean re-import of one awesome list: replaces every category and category item of the
   * list with what the current parser reads from today's upstream source.
   *
   * Contract:
   * - Runs under the sync write lock (see runExclusive), and refuses when another sync,
   *   import or re-import holds it.
   * - Refuses (throws before any network call) when the list's slug is not `expectedSlug`.
   * - Refuses (throws before any write) when the parse holds zero items, or fewer than
   *   REIMPORT_MIN_RATIO of the stored item count.
   * - `apply = false` is a dry run: it reads and reports, and writes nothing at all.
   * - `apply = true` deletes and re-creates the list's rows inside one transaction, so a
   *   failure leaves the stored data as it was. Only categories that at least one item
   *   (after the awesome-list filter) uses are persisted. Other lists are never touched.
   */
  async reimportAwesomeList(awesomeListId: number, expectedSlug: string, apply: boolean): Promise<ReimportReport> {
    return this.runExclusive(`re-import list ${awesomeListId}`, () =>
      this.reimportAwesomeListLocked(awesomeListId, expectedSlug, apply),
    );
  }

  private async reimportAwesomeListLocked(
    awesomeListId: number,
    expectedSlug: string,
    apply: boolean,
  ): Promise<ReimportReport> {
    const list = await this.prisma.awesomeList.findUnique({
      where: { id: awesomeListId },
    });
    if (!list) throw new Error(`Awesome list ${awesomeListId} not found`);
    if (list.slug !== expectedSlug) {
      throw new Error(
        `Refusing to re-import list ${awesomeListId}: slug is '${list.slug}', expected '${expectedSlug}'`,
      );
    }

    const repoRef = GithubService.parseGithubRepo(`https://github.com/${list.githubRepo}`);
    if (!repoRef) throw new Error(`Invalid GitHub repo: ${list.githubRepo}`);

    const parser = getParser(list.parserType);
    const sourcePath = parser.sourcePath;
    const source = sourcePath
      ? await this.github.fetchFileContent(repoRef.owner, repoRef.name, sourcePath)
      : await this.github.fetchReadme(repoRef.owner, repoRef.name);
    if (!source) throw new Error(`Source content not found for ${list.githubRepo}`);

    const { categories, items } = parser.parse(source);
    const filtered = await this.filterAwesomeListRepos(list.slug, items);
    // persistParsedData() writes only the categories an item uses; summarize the same set
    // so `parsed.categories` matches what an apply stores.
    const usedOrders = new Set(filtered.map((item) => item.categoryIndex));
    const usedCategories = categories.filter((cat) => usedOrders.has(cat.order));
    const parsed = summarizeParseResult({ categories: usedCategories, items: filtered });

    const before = await this.countListData(awesomeListId);
    const otherListsBefore = await this.countOtherLists(awesomeListId);

    if (filtered.length === 0) {
      throw new Error(`Refusing to re-import list ${awesomeListId}: the source parsed to 0 items`);
    }
    const minItems = Math.ceil(before.items * REIMPORT_MIN_RATIO);
    if (before.items > 0 && filtered.length < minItems) {
      throw new Error(
        `Refusing to re-import list ${awesomeListId}: parsed ${filtered.length} items, ` +
          `fewer than ${minItems} (REIMPORT_MIN_RATIO ${REIMPORT_MIN_RATIO} of ${before.items} stored)`,
      );
    }

    if (!apply) {
      return {
        awesomeListId,
        slug: list.slug,
        applied: false,
        before,
        parsed,
        after: null,
        otherListsBefore,
        otherListsAfter: null,
        newRepoIds: null,
      };
    }

    const newRepoIds = await this.prisma.$transaction(
      async (tx) => {
        await tx.categoryItem.deleteMany({ where: { category: { awesomeListId } } });
        await tx.category.deleteMany({ where: { awesomeListId } });
        const created = await this.persistParsedData(awesomeListId, categories, filtered, tx);
        // The re-created rows start without the repo-derived columns the nightly snapshot
        // step keeps on category_items. The public pages filter on category_items.stars, so
        // copy them from the linked repos now instead of publishing an empty list until the
        // next nightly.
        await tx.$executeRaw`
          UPDATE category_items AS ci
          SET stars = r.stars, github_description = r.description, last_commit_at = r.last_commit_at
          FROM repos AS r, categories AS c
          WHERE ci.repo_id = r.id AND ci.category_id = c.id AND c.awesome_list_id = ${awesomeListId}`;
        await tx.awesomeList.update({
          where: { id: awesomeListId },
          data: { readmeContent: source, lastSyncedAt: new Date(), state: 'completed' },
        });
        return created;
      },
      { maxWait: 10_000, timeout: 600_000 },
    );

    // Non-fatal, like importAwesomeList: the re-imported rows are committed either way.
    try {
      await this.hydrateNewRepos(newRepoIds);
    } catch (error) {
      this.logger.error(`Re-import hydration failed (re-imported data preserved): ${error}`);
    }

    const after = await this.countListData(awesomeListId);
    const otherListsAfter = await this.countOtherLists(awesomeListId);
    this.logger.log(
      `Re-import complete for ${list.githubRepo}: ${before.items} -> ${after.items} items, ` +
        `${before.categories} -> ${after.categories} categories, ${newRepoIds.length} new repos`,
    );

    return {
      awesomeListId,
      slug: list.slug,
      applied: true,
      before,
      parsed,
      after,
      otherListsBefore,
      otherListsAfter,
      newRepoIds,
    };
  }

  /** Quality counts of the categories and items list `awesomeListId` stores. */
  private async countListData(awesomeListId: number): Promise<ListDataCounts> {
    const categories = await this.prisma.category.findMany({
      where: { awesomeListId },
      select: { name: true, _count: { select: { categoryItems: true } } },
    });
    const items = await this.prisma.categoryItem.count({
      where: { category: { awesomeListId } },
    });
    const nullDescriptions = await this.prisma.categoryItem.count({
      where: { category: { awesomeListId }, description: null },
    });
    const badgeDescriptions = await this.prisma.categoryItem.count({
      where: {
        category: { awesomeListId },
        OR: [{ description: { contains: '![' } }, { description: { contains: 'img.shields.io' } }],
      },
    });
    const itemsWithoutStars = await this.prisma.categoryItem.count({
      where: { category: { awesomeListId }, repoId: { not: null }, stars: null },
    });
    return {
      categories: categories.length,
      emptyCategories: categories.filter((cat) => cat._count.categoryItems === 0).length,
      numberedCategories: categories.filter((cat) => NUMBERED_NAME_RE.test(cat.name)).length,
      items,
      nullDescriptions,
      badgeDescriptions,
      itemsWithoutStars,
    };
  }

  /** Category and item totals of every list except `awesomeListId`. */
  private async countOtherLists(awesomeListId: number): Promise<ListScopeCounts> {
    const categories = await this.prisma.category.count({
      where: { awesomeListId: { not: awesomeListId } },
    });
    const items = await this.prisma.categoryItem.count({
      where: { category: { awesomeListId: { not: awesomeListId } } },
    });
    return { categories, items };
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
    const { spawn } = await import('child_process');
    const { writeFileSync, mkdirSync, rmSync, statSync, readdirSync, existsSync, copyFileSync } = await import('fs');
    const path = await import('path');
    const webDir = path.resolve(process.cwd(), '..', 'web');
    const dataDir = path.join(webDir, 'data');
    const outDir = path.join(webDir, 'out');

    try {
      // Export static data files so Next.js build doesn't need a running API
      mkdirSync(dataDir, { recursive: true });

      const lastSnapshot = await this.staticData.getLastSnapshotDate();
      writeFileSync(path.join(dataDir, 'last-snapshot.json'), JSON.stringify({ lastSnapshotDate: lastSnapshot }));
      this.logger.log(`Exported last-snapshot.json: ${lastSnapshot}`);

      const lists = await this.staticData.exportAllLists();
      writeFileSync(path.join(dataDir, 'lists.json'), JSON.stringify({ data: lists }));
      this.logger.log(`Exported lists.json: ${lists.length} lists`);

      const repoSlugs = await this.staticData.exportRepoSlugs();
      writeFileSync(path.join(dataDir, 'repo-slugs.json'), JSON.stringify({ data: repoSlugs }));
      this.logger.log(`Exported repo-slugs.json: ${repoSlugs.length} slugs`);

      // Client-side search index: the static site has no API, so /search filters this file in the browser.
      const searchIndex = await this.staticData.exportSearchIndex();
      const searchIndexJson = JSON.stringify(searchIndex);
      const searchIndexFile = path.join(dataDir, 'search-index.json');
      writeFileSync(searchIndexFile, searchIndexJson);
      mkdirSync(path.join(webDir, 'public'), { recursive: true });
      copyFileSync(searchIndexFile, path.join(webDir, 'public', 'search-index.json'));
      this.logger.log(
        `Exported search-index.json: ${searchIndex.repos.length} repos, ${Buffer.byteLength(searchIndexJson)} bytes`,
      );

      // Pre-dump per-repo detail JSON so build pages read from disk instead of HTTP
      const repoDir = path.join(dataDir, 'r');
      rmSync(repoDir, { recursive: true, force: true });
      mkdirSync(repoDir, { recursive: true });
      const repoDetails = await this.staticData.exportAllRepoDetails();
      for (const { repoSlug, data } of repoDetails) {
        writeFileSync(path.join(repoDir, `${repoSlug}.json`), JSON.stringify({ data }));
      }
      this.logger.log(`Exported ${repoDetails.length} per-repo JSON files`);

      // Clear .next/ cache to prevent stale data
      rmSync(path.join(webDir, '.next'), { recursive: true, force: true });

      // Umami analytics (layout.tsx) is only emitted when both vars reach the build env.
      // They pass through via `...process.env` below (ConfigModule loads api/.env into it);
      // warn so a nightly rebuild that silently drops analytics shows up in the sync logs.
      if (
        !process.env.NEXT_PUBLIC_UMAMI_SCRIPT_URL ||
        !process.env.NEXT_PUBLIC_UMAMI_WEBSITE_ID
      ) {
        this.logger.warn(
          'NEXT_PUBLIC_UMAMI_SCRIPT_URL / NEXT_PUBLIC_UMAMI_WEBSITE_ID not set — static build will ship without analytics',
        );
      }

      // Use spawn instead of execSync so the API event loop stays free —
      // build pages call localhost:4000/api/* during SSG and need this process responsive.
      await new Promise<void>((resolve, reject) => {
        const child = spawn('npm', ['run', 'build'], {
          cwd: webDir,
          stdio: 'inherit',
          env: { ...process.env, NEXT_PUBLIC_API_URL: `http://localhost:${process.env.PORT ?? 4000}/api`, BASE_PATH: process.env.BASE_PATH ?? '/awesomer' },
        });
        const timer = setTimeout(() => {
          child.kill('SIGKILL');
          reject(new Error('build timed out after 600s'));
        }, 600_000);
        child.on('error', (err) => { clearTimeout(timer); reject(err); });
        child.on('exit', (code) => {
          clearTimeout(timer);
          if (code === 0) resolve();
          else reject(new Error(`build exited with code ${code}`));
        });
      });

      // Sanity-check the build output before reporting success. Catches the
      // historical "all-pages-404 after build success" failure mode where
      // npm run build exits 0 but pages render the Next.js error fallback.
      const homepage = path.join(outDir, 'index.html');
      if (!existsSync(homepage) || statSync(homepage).size < 50_000) {
        throw new Error(`Build sanity check failed: ${homepage} missing or too small (< 50KB)`);
      }
      const repoDirs = existsSync(path.join(outDir, 'r')) ? readdirSync(path.join(outDir, 'r')).length : 0;
      if (repoDirs < 5_000) {
        throw new Error(`Build sanity check failed: web/out/r/ has only ${repoDirs} entries (expected >= 5000)`);
      }
      const listDirs = existsSync(path.join(outDir, 'l')) ? readdirSync(path.join(outDir, 'l')).length : 0;
      if (listDirs < 25) {
        throw new Error(`Build sanity check failed: web/out/l/ has only ${listDirs} entries (expected >= 25)`);
      }
      const outSearchIndex = path.join(outDir, 'search-index.json');
      if (!existsSync(outSearchIndex) || statSync(outSearchIndex).size < 500_000) {
        throw new Error(`Build sanity check failed: ${outSearchIndex} missing or too small (< 500KB)`);
      }
      this.logger.log(`Static site rebuilt successfully (homepage ${(statSync(homepage).size / 1024).toFixed(0)}KB, ${repoDirs} repo pages, ${listDirs} list pages, search index ${(statSync(outSearchIndex).size / 1024).toFixed(0)}KB)`);
    } catch (error) {
      this.logger.error('Static site build failed', error);
      throw error;
    }
  }

  async deployStaticSite(deployDir: string = DEPLOY_DIR): Promise<string> {
    this.logger.log('Step 7: Deploying static site to GitHub Pages...');
    const { execSync } = await import('child_process');
    const { writeFileSync, mkdirSync, rmSync } = await import('fs');
    const path = await import('path');
    const projectRoot = path.resolve(process.cwd(), '..');
    const outDir = path.join(projectRoot, 'web', 'out');

    try {
      // Clean and prepare deploy directory
      rmSync(deployDir, { recursive: true, force: true });
      mkdirSync(deployDir, { recursive: true });

      // Copy static site build output without its payload files. The removal above
      // is what guarantees no stale payload survives from an earlier run.
      const excludes = RSC_PAYLOAD_EXCLUDES.map((pattern) => `--exclude='${pattern}'`).join(' ');
      execSync(`rsync -a ${excludes} "${outDir}/" "${deployDir}/"`, { stdio: 'inherit', timeout: 120_000 });

      // Generate markdown files AFTER rsync (preserves existing ordering per Phase 24 decision)
      await this.generateMarkdown(deployDir);

      // Prevent Jekyll from ignoring _next/ directory
      writeFileSync(path.join(deployDir, '.nojekyll'), '');

      // Init fresh git repo, commit, force-push to gh-pages.
      // Identity inherits from global ~/.config/git/.gitconfig.
      execSync('git init', { cwd: deployDir, timeout: 30_000 });
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
      return deployDir;
    } catch (error) {
      this.logger.error('Static site deployment failed', error);
      throw error;
    }
  }

  /**
   * Commit the README.md that this run generated into markdownDir to main, so
   * the GitHub repo homepage stays in sync. Its list and repo page links target
   * gh-pages, because the l/ and r/ pages are published only there. Uses an
   * isolated worktree based on origin/main to avoid touching the user's working
   * tree or local main.
   * Non-fatal: a failure here doesn't fail the pipeline (deploy already
   * succeeded; the live site is fresh — only the GitHub repo homepage lags).
   */
  async commitReadmeToMain(markdownDir: string, worktreeDir: string = README_WORKTREE_DIR): Promise<void> {
    this.logger.log('Step 7: Committing README.md to main...');
    const { execSync } = await import('child_process');
    const fs = await import('fs');
    const path = await import('path');
    const projectRoot = path.resolve(process.cwd(), '..');

    try {
      // Clean any prior worktree
      try { execSync(`git worktree remove --force "${worktreeDir}"`, { cwd: projectRoot, stdio: 'pipe' }); } catch { /* none to remove */ }
      fs.rmSync(worktreeDir, { recursive: true, force: true });

      // Fetch and check out a detached worktree at origin/main
      execSync('git fetch origin main', { cwd: projectRoot, timeout: 60_000 });
      execSync(`git worktree add --detach "${worktreeDir}" origin/main`, { cwd: projectRoot, timeout: 30_000 });

      // A symlink is not a regular file, so it counts as absent.
      if (!this.listMarkdownFiles(markdownDir).includes('README.md')) {
        this.logger.warn(`README commit skipped: no README.md in ${markdownDir}`);
        return;
      }

      // Write the README generated by this run into the worktree
      const generated = fs.readFileSync(path.join(markdownDir, 'README.md'), 'utf-8');
      fs.writeFileSync(path.join(worktreeDir, 'README.md'), readmeForMain(generated));

      // README.md is the only generated file main receives.
      execSync('git add README.md', { cwd: worktreeDir, stdio: 'pipe' });

      // Skip if nothing changed
      const staged = execSync('git status --porcelain', { cwd: worktreeDir })
        .toString()
        .trim();
      if (!staged) {
        this.logger.log('README unchanged from origin/main; skipping auto-commit');
        return;
      }

      const fileCount = staged.split('\n').length;
      const date = new Date().toISOString().slice(0, 10);
      execSync(
        `git commit -m "chore: auto-update markdown (daily sync ${date}, ${fileCount} files)"`,
        { cwd: worktreeDir, stdio: 'inherit', timeout: 60_000 },
      );
      execSync('git push origin HEAD:main', {
        cwd: worktreeDir,
        stdio: 'inherit',
        timeout: 300_000,
      });
      this.logger.log(`README auto-committed and pushed to main (${fileCount} files)`);
    } catch (error) {
      this.logger.warn(`README auto-commit failed (non-fatal): ${error}`);
    } finally {
      try { execSync(`git worktree remove --force "${worktreeDir}"`, { cwd: projectRoot, stdio: 'pipe' }); } catch { /* ignore */ }
    }
  }

  /** Names of the regular *.md files directly inside dir; empty when dir is missing. */
  private listMarkdownFiles(dir: string): string[] {
    if (!existsSync(dir)) return [];
    return readdirSync(dir, { withFileTypes: true })
      .filter((entry) => entry.isFile() && entry.name.endsWith('.md'))
      .map((entry) => entry.name);
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
    db: Prisma.TransactionClient = this.prisma,
  ): Promise<number[]> {
    // Create only the categories an item uses. Every caller (full import, diff-sync,
    // re-import) shares this, so none of them can re-create a category whose items were
    // all filtered out (e.g. awesome-list cross-references) as an empty row.
    const usedOrders = new Set(items.map((item) => item.categoryIndex));
    const categoryMap = new Map<number, number>(); // index → DB id

    // Categories are matched by (awesomeListId, name), never by slug, and the DB unique
    // index categories_awesome_list_id_name_key enforces one row per heading. Legacy rows
    // carry un-prefixed slugs (`containers`); the empty update keeps their slug and name,
    // so existing `#category-<slug>` anchors keep working. The slug is only the create value.
    for (const cat of categories) {
      if (!usedOrders.has(cat.order)) continue;
      const name = cat.name.trim();
      const slug = await this.availableCategorySlug(awesomeListId, name, db);
      const created = await db.category.upsert({
        where: { awesomeListId_name: { awesomeListId, name } },
        update: {},
        create: {
          name,
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
        const existingRepo = await db.repo.findUnique({
          where: { githubRepo: item.githubRepo },
          select: { id: true },
        });

        const repo = await db.repo.upsert({
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
      const existing = await db.categoryItem.findFirst({
        where: {
          categoryId,
          OR: [
            { primaryUrl: item.primaryUrl },
            { name: item.name, githubRepo: item.githubRepo },
          ],
        },
      });

      if (!existing) {
        await db.categoryItem.create({
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

    await this.warnNearDuplicateCategories(awesomeListId, db);
    return newRepoIds;
  }

  /**
   * Pick the slug a new category of this list would be created with.
   *
   * slug is globally unique, and slugify() folds different headings into one value
   * ("C" and "C++" in list 187 both give `187-c`), so a bare create would throw P2002
   * and abort the import, or roll back the whole re-import transaction. Candidates are
   * the base slug, then `<base>-2`, `<base>-3` and so on, each kept within 100
   * characters. A candidate is free when no row holds it, or the row holding it is
   * this same (list, name) category.
   */
  private async availableCategorySlug(
    awesomeListId: number,
    name: string,
    db: Prisma.TransactionClient,
  ): Promise<string> {
    const MAX_CANDIDATES = 50;
    const base = this.slugify(`${awesomeListId}-${name}`);
    for (let n = 1; n <= MAX_CANDIDATES; n++) {
      const suffix = n === 1 ? '' : `-${n}`;
      const candidate = `${base.substring(0, 100 - suffix.length)}${suffix}`;
      const holder = await db.category.findUnique({
        where: { slug: candidate },
        select: { awesomeListId: true, name: true },
      });
      if (
        !holder ||
        (holder.awesomeListId === awesomeListId && holder.name === name)
      ) {
        return candidate;
      }
    }
    throw new Error(
      `No free category slug for list ${awesomeListId} name ${JSON.stringify(name)} ` +
        `after ${MAX_CANDIDATES} candidates`,
    );
  }

  /**
   * Log one warning per group of this list's category names that are equal after
   * lowercasing and whitespace collapse. The unique index only blocks exact duplicates;
   * this surfaces the near ones. Names are JSON.stringify'd because they are untrusted
   * upstream heading text, so control characters cannot forge log lines.
   */
  private async warnNearDuplicateCategories(
    awesomeListId: number,
    db: Prisma.TransactionClient = this.prisma,
  ): Promise<void> {
    const rows = await db.category.findMany({
      where: { awesomeListId },
      select: { id: true, name: true },
    });
    const groups = new Map<string, Array<{ id: number; name: string }>>();
    for (const row of rows) {
      const key = row.name.toLowerCase().replace(/\s+/g, ' ').trim();
      const group = groups.get(key) ?? [];
      group.push(row);
      groups.set(key, group);
    }
    for (const group of groups.values()) {
      if (group.length < 2) continue;
      const names = group.map((r) => JSON.stringify(r.name)).join(', ');
      const ids = group.map((r) => r.id).join(', ');
      this.logger.warn(
        `Near-duplicate category names in list ${awesomeListId}: ${names} (ids ${ids})`,
      );
    }
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
