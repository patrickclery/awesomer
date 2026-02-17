import {
  Controller,
  Get,
  NotFoundException,
  Param,
  ParseIntPipe,
  Query,
} from '@nestjs/common';
import { ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import { ReposService } from './repos.service.js';

@ApiTags('Repos')
@Controller()
export class ReposController {
  constructor(private readonly reposService: ReposService) {}

  @Get('awesome-lists/:slug/repos')
  @ApiOperation({ summary: 'Get repos in an awesome list vertical' })
  @ApiQuery({ name: 'sort', required: false, enum: ['stars', 'trending_7d', 'trending_30d', 'trending_90d'] })
  @ApiQuery({ name: 'category', required: false })
  @ApiQuery({ name: 'search', required: false })
  @ApiQuery({ name: 'min_stars', required: false, type: Number })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'per_page', required: false, type: Number })
  async findByAwesomeList(
    @Param('slug') slug: string,
    @Query('sort') sort?: 'stars' | 'trending_7d' | 'trending_30d' | 'trending_90d',
    @Query('category') category?: string,
    @Query('search') search?: string,
    @Query('min_stars') min_stars?: string,
    @Query('page') page?: string,
    @Query('per_page') per_page?: string,
  ) {
    return this.reposService.findByAwesomeListSlug(slug, {
      sort,
      category,
      search,
      min_stars: min_stars ? Number(min_stars) : undefined,
      page: page ? Number(page) : 1,
      per_page: per_page ? Number(per_page) : 25,
    });
  }

  @Get('search')
  @ApiOperation({ summary: 'Search repos across all verticals' })
  @ApiQuery({ name: 'q', required: true, description: 'Search query' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'per_page', required: false, type: Number })
  async searchGlobal(
    @Query('q') q: string,
    @Query('page') page?: string,
    @Query('per_page') per_page?: string,
  ) {
    if (!q || q.trim().length === 0) {
      return { data: [], meta: { total: 0, page: 1, per_page: 25, total_pages: 0 } };
    }
    return this.reposService.searchGlobal(q, {
      page: page ? Number(page) : 1,
      per_page: per_page ? Math.min(Number(per_page) || 25, 50) : 25,
    });
  }

  @Get('repos/by-github/:owner/:name')
  @ApiOperation({ summary: 'Get a repo by GitHub owner/name' })
  async findByGithubRepo(
    @Param('owner') owner: string,
    @Param('name') name: string,
  ) {
    const repo = await this.reposService.findByGithubRepo(`${owner}/${name}`);
    if (!repo) {
      throw new NotFoundException(`Repo ${owner}/${name} not found`);
    }
    return { data: repo };
  }

  @Get('repos/:id')
  @ApiOperation({ summary: 'Get a single repo by ID' })
  async findById(@Param('id', ParseIntPipe) id: number) {
    const repo = await this.reposService.findById(id);
    if (!repo) {
      throw new NotFoundException(`Repo with ID ${id} not found`);
    }
    return { data: repo };
  }

  @Get('repos/:id/star-history')
  @ApiOperation({ summary: 'Get star history for a repo' })
  async getStarHistory(@Param('id', ParseIntPipe) id: number) {
    const history = await this.reposService.getStarHistory(id);
    return { data: history };
  }
}
