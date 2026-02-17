import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service.js';

@Injectable()
export class SyncService {
  private readonly logger = new Logger(SyncService.name);

  constructor(private readonly prisma: PrismaService) {}

  @Cron(CronExpression.EVERY_DAY_AT_2AM)
  async runDailySync() {
    this.logger.log('Starting daily sync pipeline...');

    try {
      await this.syncGithubStats();
      await this.takeStarSnapshots();
      await this.computeTrending();
      await this.generateMarkdown();
      this.logger.log('Daily sync pipeline completed');
    } catch (error) {
      this.logger.error('Daily sync pipeline failed', error);
    }
  }

  async syncGithubStats() {
    this.logger.log('Step 1: Syncing GitHub stats...');
    // TODO: Implement - fetch current stars and last commit for all repos
    // Uses Octokit with @octokit/plugin-throttling
  }

  async takeStarSnapshots() {
    this.logger.log('Step 2: Taking star snapshots...');
    // TODO: Implement - record one star_snapshot per repo per day
    // Uses GitHub GraphQL API for batch fetching
  }

  async computeTrending() {
    this.logger.log('Step 3: Computing trending...');
    // TODO: Implement - diff snapshots for 7d/30d/90d
    // 3-day tolerance window for missing snapshots
  }

  async generateMarkdown() {
    this.logger.log('Step 4: Generating markdown...');
    // TODO: Implement - generate markdown files and push to GitHub
  }

  async importAwesomeList(githubRepo: string) {
    this.logger.log(`Importing awesome list from ${githubRepo}...`);
    // TODO: Implement - fetch README, parse markdown, create repos/categories
  }
}
