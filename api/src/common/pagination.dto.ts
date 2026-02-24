import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsInt, IsOptional, Max, Min } from 'class-validator';

export class PaginationDto {
  @ApiPropertyOptional({ default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page: number = 1;

  @ApiPropertyOptional({ default: 25, minimum: 1, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  per_page: number = 25;

  get skip(): number {
    return (this.page - 1) * this.per_page;
  }

  get take(): number {
    return this.per_page;
  }
}

export class PaginatedResponseMeta {
  total: number;
  page: number;
  per_page: number;
  total_pages: number;

  constructor(total: number, page: number, per_page: number) {
    this.total = total;
    this.page = page;
    this.per_page = per_page;
    this.total_pages = Math.ceil(total / per_page);
  }
}

export class PaginatedResponse<T> {
  data: T[];
  meta: PaginatedResponseMeta;

  constructor(data: T[], total: number, page: number, per_page: number) {
    this.data = data;
    this.meta = new PaginatedResponseMeta(total, page, per_page);
  }
}
