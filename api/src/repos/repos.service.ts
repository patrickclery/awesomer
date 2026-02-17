import { Injectable } from '@nestjs/common';
import { Prisma } from '../../generated/prisma/client.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { PaginatedResponse } from '../common/pagination.dto.js';

export interface RepoQueryParams {
  sort?: 'stars' | 'trending_7d' | 'trending_30d' | 'trending_90d';
  category?: string;
  search?: string;
  min_stars?: number;
  page: number;
  per_page: number;
}

@Injectable()
export class ReposService {
  constructor(private readonly prisma: PrismaService) {}

  async findByAwesomeListSlug(
    slug: string,
    params: RepoQueryParams,
  ): Promise<PaginatedResponse<unknown>> {
    const skip = (params.page - 1) * params.per_page;
    const take = params.per_page;

    const where: Prisma.CategoryItemWhereInput = {
      category: {
        awesomeList: { slug },
      },
      ...(params.min_stars ? { stars: { gte: params.min_stars } } : {}),
      ...(params.search
        ? {
            OR: [
              { name: { contains: params.search, mode: 'insensitive' as const } },
              {
                description: {
                  contains: params.search,
                  mode: 'insensitive' as const,
                },
              },
              {
                githubDescription: {
                  contains: params.search,
                  mode: 'insensitive' as const,
                },
              },
            ],
          }
        : {}),
      ...(params.category
        ? { category: { slug: params.category } }
        : {}),
    };

    const orderBy = this.getOrderBy(params.sort);

    const [items, total] = await Promise.all([
      this.prisma.categoryItem.findMany({
        where,
        include: {
          category: { select: { id: true, name: true, slug: true } },
          repo: { select: { stars7d: true, stars30d: true, stars90d: true } },
        },
        orderBy,
        skip,
        take,
      }),
      this.prisma.categoryItem.count({ where }),
    ]);

    return new PaginatedResponse(items, total, params.page, params.per_page);
  }

  async searchGlobal(
    search: string,
    params: { page: number; per_page: number },
  ): Promise<PaginatedResponse<unknown>> {
    const skip = (params.page - 1) * params.per_page;
    const take = params.per_page;

    const where: Prisma.CategoryItemWhereInput = {
      OR: [
        { name: { contains: search, mode: 'insensitive' as const } },
        { description: { contains: search, mode: 'insensitive' as const } },
        { githubDescription: { contains: search, mode: 'insensitive' as const } },
        { githubRepo: { contains: search, mode: 'insensitive' as const } },
      ],
    };

    const [items, total] = await Promise.all([
      this.prisma.categoryItem.findMany({
        where,
        include: {
          category: {
            select: {
              id: true,
              name: true,
              slug: true,
              awesomeList: { select: { id: true, name: true, slug: true } },
            },
          },
          repo: { select: { stars7d: true, stars30d: true, stars90d: true } },
        },
        orderBy: { stars: { sort: 'desc', nulls: 'last' } },
        skip,
        take,
      }),
      this.prisma.categoryItem.count({ where }),
    ]);

    return new PaginatedResponse(items, total, params.page, params.per_page);
  }

  async findByGithubRepo(githubRepo: string) {
    return this.prisma.repo.findUnique({
      where: { githubRepo },
      include: {
        categoryItems: {
          include: {
            category: {
              include: {
                awesomeList: { select: { id: true, name: true, slug: true } },
              },
            },
          },
        },
        tags: {
          include: { tag: true },
        },
      },
    });
  }

  async findById(id: number) {
    return this.prisma.repo.findUnique({
      where: { id },
      include: {
        categoryItems: {
          include: {
            category: {
              include: {
                awesomeList: { select: { id: true, name: true, slug: true } },
              },
            },
          },
        },
        tags: {
          include: { tag: true },
        },
      },
    });
  }

  async getStarHistory(repoId: number) {
    return this.prisma.starSnapshot.findMany({
      where: { repoId },
      orderBy: { snapshotDate: 'asc' },
      select: { snapshotDate: true, stars: true },
    });
  }

  private getOrderBy(
    sort?: string,
  ): Prisma.CategoryItemOrderByWithRelationInput {
    switch (sort) {
      case 'trending_7d':
        return { repo: { stars7d: { sort: 'desc', nulls: 'last' } } };
      case 'trending_30d':
        return { repo: { stars30d: { sort: 'desc', nulls: 'last' } } };
      case 'trending_90d':
        return { repo: { stars90d: { sort: 'desc', nulls: 'last' } } };
      default:
        return { stars: { sort: 'desc', nulls: 'last' } };
    }
  }
}
