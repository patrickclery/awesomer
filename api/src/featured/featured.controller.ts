import { Controller, Get, Query } from '@nestjs/common';
import { ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import { FeaturedService } from './featured.service.js';

@ApiTags('Featured')
@Controller('featured')
export class FeaturedController {
  constructor(private readonly featuredService: FeaturedService) {}

  @Get()
  @ApiOperation({ summary: 'Get current featured profiles' })
  @ApiQuery({ name: 'list', required: false, description: 'Filter by awesome list slug' })
  async findActive(@Query('list') listSlug?: string) {
    const profiles = await this.featuredService.findActive(listSlug);
    return { data: profiles };
  }
}
