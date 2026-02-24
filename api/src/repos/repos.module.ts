import { Module } from '@nestjs/common';
import { ReposController } from './repos.controller.js';
import { ReposService } from './repos.service.js';

@Module({
  controllers: [ReposController],
  providers: [ReposService],
  exports: [ReposService],
})
export class ReposModule {}
