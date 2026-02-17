import { Module } from '@nestjs/common';
import { TrendingController } from './trending.controller.js';
import { TrendingService } from './trending.service.js';

@Module({
  controllers: [TrendingController],
  providers: [TrendingService],
  exports: [TrendingService],
})
export class TrendingModule {}
