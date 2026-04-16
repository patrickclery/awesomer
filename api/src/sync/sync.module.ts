import { Module } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { BackfillService } from './backfill.service.js';
import { GithubService } from './github.service.js';
import { MarkdownService } from './markdown.service.js';
import { StaticDataService } from './static-data.service.js';
import { SyncController } from './sync.controller.js';
import { SyncService } from './sync.service.js';

@Module({
  imports: [ScheduleModule.forRoot()],
  controllers: [SyncController],
  providers: [SyncService, GithubService, StaticDataService, BackfillService, MarkdownService],
  exports: [SyncService, StaticDataService, BackfillService],
})
export class SyncModule {}
