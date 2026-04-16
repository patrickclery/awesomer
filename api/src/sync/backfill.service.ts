import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { GithubService } from './github.service.js';
import { MIN_STARS } from '../common/constants.js';

export interface BackfillResult {
  totalRepos: number;
  processed: number;
  skipped: number;
  gapsFilled: number;
  errors: number;
}

@Injectable()
export class BackfillService {
  private readonly logger = new Logger(BackfillService.name);
  private static readonly INSERT_CHUNK_SIZE = 1000;

  constructor(
    private readonly prisma: PrismaService,
    private readonly github: GithubService,
  ) {}

  /**
   * Backfill star history for all candidate repos using the GitHub stargazers API.
   *
   * For each repo, paginates through all stargazers (with `starred_at` timestamps)
   * and inserts exact cumulative star counts per day. No correction factors — the
   * data comes directly from GitHub and matches their reported star count exactly.
   *
   * Resumability: repos with `starHistoryFetchedAt` within 24 hours are skipped.
   * Errors don't update the timestamp, so failed repos are retried on next run.
   */
  async backfillStarSnapshots(): Promise<BackfillResult> {
    const candidates = await this.findCandidateRepos();

    this.logger.log(
      `Starting star history backfill (GitHub stargazers API): ${candidates.length} candidate repos`,
    );

    let processed = 0;
    let skipped = 0;
    let gapsFilled = 0;
    let errors = 0;

    // Filter candidates: skip repos fetched within last 24 hours (resumability)
    const toProcess: typeof candidates = [];
    for (const repo of candidates) {
      if (repo.starHistoryFetchedAt) {
        const msSinceFetch = Date.now() - repo.starHistoryFetchedAt.getTime();
        if (msSinceFetch < 24 * 60 * 60 * 1000) {
          const hoursAgo = Math.round(msSinceFetch / 3_600_000);
          this.logger.debug(
            `Skipping ${repo.githubRepo} (fetched ${hoursAgo}h ago)`,
          );
          skipped++;
          continue;
        }
      }

      toProcess.push(repo);
    }

    this.logger.log(
      `${toProcess.length} repos to fetch (${skipped} skipped — fetched within 24h)`,
    );

    // Process repos one at a time (stargazers API is per-repo)
    for (let i = 0; i < toProcess.length; i++) {
      const repo = toProcess[i];
      const parsed = GithubService.parseGithubRepo(
        `https://github.com/${repo.githubRepo}`,
      );

      if (!parsed) {
        this.logger.warn(`${repo.githubRepo}: invalid GitHub URL, skipping`);
        errors++;
        this.logProgress(processed, skipped, errors, candidates.length, gapsFilled);
        continue;
      }

      try {
        const result = await this.github.fetchStargazersHistory(
          parsed.owner,
          parsed.name,
        );

        if (!result) {
          this.logger.log(`${repo.githubRepo}: no stargazer data (repo may be deleted)`);
          await this.prisma.repo.update({
            where: { id: repo.id },
            data: { starHistoryFetchedAt: new Date() },
          });
          processed++;
          this.logProgress(processed, skipped, errors, candidates.length, gapsFilled);
          continue;
        }

        // Build insert data from cumulative counts
        const insertData: Array<{ repoId: number; snapshotDate: Date; stars: number }> = [];
        for (const [date, stars] of result.dailyCumulativeCounts) {
          insertData.push({
            repoId: repo.id,
            snapshotDate: new Date(date + 'T00:00:00.000Z'),
            stars,
          });
        }

        if (insertData.length > 0) {
          // Insert in chunks to avoid OOM on large histories
          let repoInserted = 0;
          for (let c = 0; c < insertData.length; c += BackfillService.INSERT_CHUNK_SIZE) {
            const chunk = insertData.slice(c, c + BackfillService.INSERT_CHUNK_SIZE);
            const created = await this.prisma.starSnapshot.createMany({
              data: chunk,
              skipDuplicates: true,
            });
            repoInserted += created.count;
          }
          this.logger.log(
            `${repo.githubRepo}: inserted ${repoInserted} snapshots` +
              (result.truncated ? ' (truncated — hit 40k stargazer limit)' : ''),
          );
          gapsFilled += repoInserted;
        }

        await this.prisma.repo.update({
          where: { id: repo.id },
          data: { starHistoryFetchedAt: new Date() },
        });
        processed++;
      } catch (err) {
        this.logger.warn(`${repo.githubRepo}: unexpected error: ${err}`);
        errors++;
        // Do NOT update starHistoryFetchedAt so the repo is retried on next run
      }

      this.logProgress(processed, skipped, errors, candidates.length, gapsFilled);
    }

    this.logger.log(
      `Backfill complete: ${processed} processed, ${skipped} skipped, ${gapsFilled} gaps filled, ${errors} errors`,
    );

    return {
      totalRepos: candidates.length,
      processed,
      skipped,
      gapsFilled,
      errors,
    };
  }

  /**
   * Backfill star history for a specific set of repos.
   * Used by the post-import chain to immediately fill historical snapshots
   * for newly imported repos. Skips the 24h window and MIN_STARS filter
   * since these are targeted repos being hydrated after import.
   */
  async backfillStarSnapshotsForRepos(repoIds: number[]): Promise<BackfillResult> {
    if (repoIds.length === 0) return { totalRepos: 0, processed: 0, skipped: 0, gapsFilled: 0, errors: 0 };

    const repos = await this.prisma.repo.findMany({
      where: { id: { in: repoIds }, githubRepo: { not: '' } },
      select: { id: true, githubRepo: true, stars: true, starHistoryFetchedAt: true },
    });

    this.logger.log(`Backfilling star history for ${repos.length} targeted repos`);

    let processed = 0;
    let gapsFilled = 0;
    let errors = 0;

    for (const repo of repos) {
      const parsed = GithubService.parseGithubRepo(
        `https://github.com/${repo.githubRepo}`,
      );

      if (!parsed) {
        this.logger.warn(`${repo.githubRepo}: invalid GitHub URL, skipping`);
        errors++;
        continue;
      }

      try {
        const result = await this.github.fetchStargazersHistory(
          parsed.owner,
          parsed.name,
        );

        if (!result) {
          this.logger.log(`${repo.githubRepo}: no stargazer data`);
          await this.prisma.repo.update({
            where: { id: repo.id },
            data: { starHistoryFetchedAt: new Date() },
          });
          processed++;
          continue;
        }

        const insertData: Array<{ repoId: number; snapshotDate: Date; stars: number }> = [];
        for (const [date, stars] of result.dailyCumulativeCounts) {
          insertData.push({
            repoId: repo.id,
            snapshotDate: new Date(date + 'T00:00:00.000Z'),
            stars,
          });
        }

        if (insertData.length > 0) {
          let repoInserted = 0;
          for (let c = 0; c < insertData.length; c += BackfillService.INSERT_CHUNK_SIZE) {
            const chunk = insertData.slice(c, c + BackfillService.INSERT_CHUNK_SIZE);
            const created = await this.prisma.starSnapshot.createMany({
              data: chunk,
              skipDuplicates: true,
            });
            repoInserted += created.count;
          }
          this.logger.log(
            `${repo.githubRepo}: inserted ${repoInserted} snapshots` +
              (result.truncated ? ' (truncated — hit 40k stargazer limit)' : ''),
          );
          gapsFilled += repoInserted;
        }

        await this.prisma.repo.update({
          where: { id: repo.id },
          data: { starHistoryFetchedAt: new Date() },
        });
        processed++;
      } catch (err) {
        this.logger.warn(`${repo.githubRepo}: unexpected error: ${err}`);
        errors++;
      }
    }

    this.logger.log(
      `Targeted backfill complete: ${processed} processed, ${gapsFilled} gaps filled, ${errors} errors`,
    );

    return { totalRepos: repos.length, processed, skipped: 0, gapsFilled, errors };
  }

  /**
   * Find candidate repos for star history backfill.
   * Returns repos with stars >= MIN_STARS, ordered by trending activity then total stars.
   */
  private async findCandidateRepos() {
    return this.prisma.repo.findMany({
      where: {
        stars: { gte: MIN_STARS },
      },
      orderBy: [
        { stars7d: { sort: 'desc', nulls: 'last' } },
        { stars: { sort: 'desc', nulls: 'last' } },
      ],
      select: {
        id: true,
        githubRepo: true,
        stars: true,
        stars7d: true,
        starHistoryFetchedAt: true,
      },
    });
  }

  private logProgress(
    processed: number,
    skipped: number,
    errors: number,
    total: number,
    gapsFilled: number,
  ) {
    const done = processed + skipped + errors;
    if (done > 0 && done % 50 === 0) {
      this.logger.log(
        `Progress: ${done}/${total} (${gapsFilled} gaps filled, ${errors} errors)`,
      );
    }
  }
}
