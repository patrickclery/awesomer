import {
  Controller,
  Post,
  Param,
  ParseIntPipe,
  Headers,
  UnauthorizedException,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import { SyncService } from './sync.service.js';

@ApiTags('Sync')
@Controller('sync')
export class SyncController {
  constructor(
    private readonly syncService: SyncService,
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
}
