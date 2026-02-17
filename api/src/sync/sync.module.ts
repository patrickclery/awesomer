import { Module } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { SyncService } from './sync.service.js';

@Module({
  imports: [ScheduleModule.forRoot()],
  providers: [SyncService],
  exports: [SyncService],
})
export class SyncModule {}
