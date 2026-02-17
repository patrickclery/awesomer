import { Controller, Get, NotFoundException, Param } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AwesomeListsService } from './awesome-lists.service.js';

@ApiTags('Awesome Lists')
@Controller('awesome-lists')
export class AwesomeListsController {
  constructor(private readonly awesomeListsService: AwesomeListsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all awesome list verticals' })
  async findAll() {
    const lists = await this.awesomeListsService.findAll();
    return { data: lists };
  }

  @Get(':slug')
  @ApiOperation({ summary: 'Get a single awesome list by slug' })
  async findBySlug(@Param('slug') slug: string) {
    const list = await this.awesomeListsService.findBySlug(slug);
    if (!list) {
      throw new NotFoundException(`Awesome list '${slug}' not found`);
    }
    return { data: list };
  }
}
