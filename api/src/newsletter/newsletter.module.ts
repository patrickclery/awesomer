import { Module } from '@nestjs/common';
import { NewsletterController } from './newsletter.controller.js';
import { NewsletterService } from './newsletter.service.js';
import { ListmonkService } from './listmonk.service.js';

@Module({
  controllers: [NewsletterController],
  providers: [NewsletterService, ListmonkService],
  exports: [NewsletterService, ListmonkService],
})
export class NewsletterModule {}
