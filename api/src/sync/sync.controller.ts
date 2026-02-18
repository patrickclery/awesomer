import {
  Controller,
  Get,
  Post,
  Param,
  ParseIntPipe,
  Headers,
  UnauthorizedException,
  NotFoundException,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import { StaticDataService } from './static-data.service.js';
import { SyncService } from './sync.service.js';

@ApiTags('Sync')
@Controller('sync')
export class SyncController {
  constructor(
    private readonly syncService: SyncService,
    private readonly staticData: StaticDataService,
    private readonly config: ConfigService,
  ) {}

  private checkAdminKey(authHeader?: string) {
    const adminKey = this.config.get<string>('ADMIN_API_KEY');
    if (!adminKey) throw new UnauthorizedException('Admin API key not configured');
    if (authHeader !== `Bearer ${adminKey}`) {
      throw new UnauthorizedException('Invalid admin API key');
    }
  }

  @Post('run')
  @ApiOperation({ summary: 'Trigger full daily sync pipeline (admin only)' })
  async triggerSync(@Headers('authorization') auth?: string) {
    this.checkAdminKey(auth);
    // Run async so we don't block the request
    void this.syncService.runDailySync();
    return { message: 'Sync pipeline started' };
  }

  @Post('import/:id')
  @ApiOperation({ summary: 'Import/re-import a specific awesome list (admin only)' })
  async importList(
    @Param('id', ParseIntPipe) id: number,
    @Headers('authorization') auth?: string,
  ) {
    this.checkAdminKey(auth);
    const result = await this.syncService.importAwesomeList(id);
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

  // =========================================================================
  // Static data export endpoints (for Next.js SSG build)
  // =========================================================================

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
