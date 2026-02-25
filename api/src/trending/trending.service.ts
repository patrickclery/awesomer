import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

type TrendingPeriod = '7d' | '30d' | '90d';

@Injectable()
export class TrendingService {
  constructor(private readonly prisma: PrismaService) {}

  async getGlobalTrending(period: TrendingPeriod = '7d', limit: number = 10) {
    const orderByField = this.getOrderByField(period);

    const repos = await this.prisma.repo.findMany({
      where: {
        [orderByField]: { not: null, gt: 0 },
      },
      orderBy: { [orderByField]: 'desc' },
      take: limit,
      include: {
        categoryItems: {
          take: 1,
          include: {
            category: {
              include: {
                awesomeList: {
                  select: { id: true, name: true, slug: true },
                },
              },
            },
          },
        },
      },
    });

    return repos.map((r) => ({
      ...r,
      description: r.description ?? r.categoryItems[0]?.githubDescription ?? null,
    }));
  }

  async getTrendingByAwesomeList(
    slug: string,
    period: TrendingPeriod = '7d',
    limit: number = 10,
  ) {
    const orderByField = this.getOrderByField(period);

    const repos = await this.prisma.repo.findMany({
      where: {
        [orderByField]: { not: null, gt: 0 },
        categoryItems: {
          some: {
            category: {
              awesomeList: { slug },
            },
          },
        },
      },
      orderBy: { [orderByField]: 'desc' },
      take: limit,
      include: {
        categoryItems: {
          where: {
            category: {
              awesomeList: { slug },
            },
          },
          take: 1,
          include: {
            category: { select: { id: true, name: true, slug: true } },
          },
        },
      },
    });

    return repos.map((r) => ({
      ...r,
      description: r.description ?? r.categoryItems[0]?.githubDescription ?? null,
    }));
  }

  private getOrderByField(period: TrendingPeriod): string {
    switch (period) {
      case '7d':
        return 'stars7d';
      case '30d':
        return 'stars30d';
      case '90d':
        return 'stars90d';
    }
  }
}
