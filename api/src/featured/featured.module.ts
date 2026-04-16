import { Module } from '@nestjs/common';
import { FeaturedController } from './featured.controller.js';
import { FeaturedService } from './featured.service.js';

@Module({
  controllers: [FeaturedController],
  providers: [FeaturedService],
  exports: [FeaturedService],
})
export class FeaturedModule {}
