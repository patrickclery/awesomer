import { Module } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { GithubService } from './github.service.js';
import { SyncController } from './sync.controller.js';
import { SyncService } from './sync.service.js';

@Module({
  imports: [ScheduleModule.forRoot()],
  controllers: [SyncController],
  providers: [SyncService, GithubService],
  exports: [SyncService],
})
export class SyncModule {}
