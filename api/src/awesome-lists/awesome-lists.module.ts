import { Module } from '@nestjs/common';
import { AwesomeListsController } from './awesome-lists.controller.js';
import { AwesomeListsService } from './awesome-lists.service.js';

@Module({
  controllers: [AwesomeListsController],
  providers: [AwesomeListsService],
  exports: [AwesomeListsService],
})
export class AwesomeListsModule {}
