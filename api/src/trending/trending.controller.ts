import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import { TrendingService } from './trending.service.js';

@ApiTags('Trending')
@Controller('trending')
export class TrendingController {
  constructor(private readonly trendingService: TrendingService) {}

  @Get()
  @ApiOperation({ summary: 'Get global trending repos across all verticals' })
  @ApiQuery({ name: 'period', required: false, enum: ['7d', '30d', '90d'] })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  async getGlobalTrending(
    @Query('period') period: '7d' | '30d' | '90d' = '7d',
    @Query('limit') limit: number = 10,
  ) {
    const repos = await this.trendingService.getGlobalTrending(
      period,
      Math.min(Number(limit) || 10, 50),
    );
    return { data: repos };
  }

  @Get(':slug')
  @ApiOperation({ summary: 'Get trending repos for a specific vertical' })
  @ApiQuery({ name: 'period', required: false, enum: ['7d', '30d', '90d'] })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  async getTrendingBySlug(
    @Param('slug') slug: string,
    @Query('period') period: '7d' | '30d' | '90d' = '7d',
    @Query('limit') limit: number = 10,
  ) {
    const repos = await this.trendingService.getTrendingByAwesomeList(
      slug,
      period,
      Math.min(Number(limit) || 10, 50),
    );
    return { data: repos };
  }
}
