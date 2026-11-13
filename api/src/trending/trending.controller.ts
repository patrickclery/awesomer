import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import { TrendingService } from './trending.service.js';

const DEFAULT_LIMIT = 10;
const MAX_LIMIT = 50;

/**
 * Turn a raw `?limit=` value into an integer in [1, MAX_LIMIT]. A negative Prisma `take` reads
 * from the end of the ordering, which would put the list's lowest repo at index 0 and hand it
 * hottest-in-list (WR-01). Missing, non-numeric, zero or negative input falls back to the default.
 */
export function clampLimit(limit: unknown): number {
  const n = Math.trunc(Number(limit));
  return Math.min(Number.isFinite(n) && n > 0 ? n : DEFAULT_LIMIT, MAX_LIMIT);
}

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
      clampLimit(limit),
    );
    return { data: repos };
  }

  @Get('lists')
  @ApiOperation({ summary: 'Get trending awesome lists ranked by 7d star growth' })
  async getTrendingLists() {
    const lists = await this.trendingService.getTrendingLists();
    return { data: lists };
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
      clampLimit(limit),
    );
    return { data: repos };
  }
}
