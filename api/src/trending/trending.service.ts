import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { MIN_STARS } from '../common/constants.js';

type TrendingPeriod = '7d' | '30d' | '90d';

@Injectable()
export class TrendingService {
  constructor(private readonly prisma: PrismaService) {}

  async getGlobalTrending(period: TrendingPeriod = '7d', limit: number = 10) {
    const orderByField = this.getOrderByField(period);

    const repos = await this.prisma.repo.findMany({
      where: {
        [orderByField]: { not: null, gt: 0 },
        stars: { gte: MIN_STARS },
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
        stars: { gte: MIN_STARS },
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

  async getTrendingLists() {
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      select: {
        id: true,
        name: true,
        slug: true,
        githubRepo: true,
        repo: {
          select: { stars: true, stars7d: true, description: true, lastCommitAt: true },
        },
      },
    });

    // For each list, count member repos
    const stats = await Promise.all(
      lists.map(async (list) => {
        const repoCount = await this.prisma.repo.count({
          where: {
            stars: { gte: MIN_STARS },
            categoryItems: {
              some: {
                category: { awesomeListId: list.id },
              },
            },
          },
        });

        return {
          ...list,
          description: list.repo?.description ?? null,
          lastCommitAt: list.repo?.lastCommitAt ?? null,
          totalStars: list.repo?.stars ?? 0,
          stars7d: list.repo?.stars7d ?? 0,
          repoCount,
        };
      }),
    );

    // Sort by 7d delta descending
    return stats.sort((a, b) => b.stars7d - a.stars7d);
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
