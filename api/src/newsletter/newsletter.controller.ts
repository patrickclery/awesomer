import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { NewsletterService } from './newsletter.service.js';
import { SubscribeDto } from './subscribe.dto.js';

@ApiTags('Newsletter')
@Controller('newsletter')
export class NewsletterController {
  constructor(private readonly newsletterService: NewsletterService) {}

  @Post('subscribe')
  @ApiOperation({ summary: 'Subscribe to a newsletter' })
  async subscribe(@Body() dto: SubscribeDto) {
    const subscriber = await this.newsletterService.subscribe(
      dto.email,
      dto.awesome_list_id,
    );
    return { data: { subscribed: true, id: subscriber.id } };
  }

  @Get(':slug/issues')
  @ApiOperation({ summary: 'Get newsletter issues for a vertical' })
  async getIssues(@Param('slug') slug: string) {
    const issues = await this.newsletterService.getIssues(slug);
    return { data: issues };
  }
}
