import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  ParseIntPipe,
  Headers,
  UnauthorizedException,
  NotFoundException,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import { BackfillService } from './backfill.service.js';
import { StaticDataService } from './static-data.service.js';
import { SyncService, SyncStep } from './sync.service.js';

@ApiTags('Sync')
@Controller('sync')
export class SyncController {
  constructor(
    private readonly syncService: SyncService,
    private readonly staticData: StaticDataService,
    private readonly config: ConfigService,
    private readonly backfillService: BackfillService,
  ) {}

  private checkAdminKey(authHeader?: string) {
    const adminKey = this.config.get<string>('ADMIN_API_KEY');
    if (!adminKey) throw new UnauthorizedException('Admin API key not configured');
    if (authHeader !== `Bearer ${adminKey}`) {
      throw new UnauthorizedException('Invalid admin API key');
    }
  }

  @Post('run')
  @ApiOperation({ summary: 'Trigger sync pipeline (admin only). Optionally pass { "steps": ["snapshots", "trending", "markdown", "rebuild"] }' })
  async triggerSync(
    @Headers('authorization') auth?: string,
    @Body() body?: { steps?: SyncStep[] },
  ) {
    this.checkAdminKey(auth);
    const steps = body?.steps?.length ? body.steps : undefined;
    void this.syncService.runDailySync(steps);
    return { message: 'Sync pipeline started', steps: steps ?? 'all (default)' };
  }

  @Post('daily')
  @ApiOperation({ summary: 'Trigger the full daily pipeline (diff-sync + stats + backfill + trending + markdown + rebuild)' })
  async triggerDailyPipeline(@Headers('authorization') auth?: string) {
    this.checkAdminKey(auth);
    void this.syncService.runDailyPipeline();
    return { message: 'Daily pipeline started' };
  }

  @Post('import/:id')
  @ApiOperation({ summary: 'Import/re-import a specific awesome list (admin only)' })
  async importList(
    @Param('id', ParseIntPipe) id: number,
    @Headers('authorization') auth?: string,
  ) {
    this.checkAdminKey(auth);
    void this.syncService.importAwesomeList(id);
    return { message: 'Import started (stats → snapshots → backfill → trending will follow)' };
  }

  @Post('diff/:id')
  @ApiOperation({ summary: 'Diff-sync an awesome list (add new, remove stale, skip existing)' })
  async diffSync(
    @Param('id', ParseIntPipe) id: number,
    @Headers('authorization') auth?: string,
  ) {
    this.checkAdminKey(auth);
    const result = await this.syncService.diffSyncAwesomeList(id);
    return { data: result };
  }

  @Post('markdown')
  @ApiOperation({ summary: 'Regenerate all markdown files (admin only)' })
  async generateMarkdown(@Headers('authorization') auth?: string) {
    this.checkAdminKey(auth);
    const files = await this.syncService.generateMarkdown();
    return { data: { files, count: files.length } };
  }

  @Post('rebuild')
  @ApiOperation({ summary: 'Rebuild static site (admin only)' })
  async rebuildSite(@Headers('authorization') auth?: string) {
    this.checkAdminKey(auth);
    void this.syncService.rebuildStaticSite();
    return { message: 'Static site rebuild started' };
  }

  @Post('backfill-stars')
  @ApiOperation({ summary: 'Trigger star history backfill via GitHub stargazers API (admin only)' })
  async backfillStars(
    @Headers('authorization') auth?: string,
    @Body() body?: { repoIds?: number[] },
  ) {
    this.checkAdminKey(auth);
    if (body?.repoIds?.length) {
      void this.backfillService.backfillStarSnapshotsForRepos(body.repoIds).then(() =>
        this.syncService.computeTrendingForRepos(body.repoIds!),
      );
      return { message: `Backfill started for ${body.repoIds.length} repos (trending will follow)` };
    }
    void this.backfillService.backfillStarSnapshots();
    return { message: 'Star snapshot backfill started' };
  }

  // =========================================================================
  // Static data export endpoints (for Next.js SSG build)
  // =========================================================================

  @Get('static/last-snapshot')
  @ApiOperation({ summary: 'Get the date of the most recent star snapshot' })
  async getLastSnapshotDate() {
    const date = await this.staticData.getLastSnapshotDate();
    return { data: { lastSnapshotDate: date } };
  }

  @Get('static/lists')
  @ApiOperation({ summary: 'Export all list data for static build' })
  async exportLists() {
    const data = await this.staticData.exportAllLists();
    return { data };
  }

  @Get('static/trending')
  @ApiOperation({ summary: 'Export global trending for static build' })
  async exportTrending() {
    const data = await this.staticData.exportGlobalTrending();
    return { data };
  }

  @Get('static/repo-slugs')
  @ApiOperation({ summary: 'Export all repo slugs for generateStaticParams' })
  async exportRepoSlugs() {
    const data = await this.staticData.exportRepoSlugs();
    return { data };
  }

  @Get('static/repo/:owner/:name')
  @ApiOperation({ summary: 'Export single repo detail for static build' })
  async exportRepoDetail(
    @Param('owner') owner: string,
    @Param('name') name: string,
  ) {
    const data = await this.staticData.exportRepoDetail(owner, name);
    if (!data) throw new NotFoundException();
    return { data };
  }
}
