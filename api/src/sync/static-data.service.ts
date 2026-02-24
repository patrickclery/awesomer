import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

export interface StaticListData {
  slug: string;
  name: string;
  description: string | null;
  githubRepo: string;
  categoryCount: number;
  categories: Array<{
    id: number;
    name: string;
    slug: string;
    itemCount: number;
  }>;
  trending7d: StaticTrendingRepo[];
  trending30d: StaticTrendingRepo[];
  trending90d: StaticTrendingRepo[];
}

export interface StaticTrendingRepo {
  githubRepo: string;
  description: string | null;
  stars: number | null;
  stars7d: number | null;
  stars30d: number | null;
  stars90d: number | null;
  lastCommitAt: string | null;
  categoryName: string | null;
  listSlug: string | null;
}

export interface StaticRepoPage {
  githubRepo: string;
  description: string | null;
  stars: number | null;
  stars7d: number | null;
  stars30d: number | null;
  stars90d: number | null;
  lastCommitAt: string | null;
  starHistory: Array<{ snapshotDate: string; stars: number }>;
  foundIn: Array<{
    categoryName: string;
    categorySlug: string;
    listName: string;
    listSlug: string;
  }>;
}

@Injectable()
export class StaticDataService {
  constructor(private readonly prisma: PrismaService) {}

  async exportAllLists(): Promise<StaticListData[]> {
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      orderBy: { name: 'asc' },
      include: {
        categories: {
          orderBy: { name: 'asc' },
          include: { _count: { select: { categoryItems: true } } },
        },
      },
    });

    const result: StaticListData[] = [];

    for (const list of lists) {
      const [t7, t30, t90] = await Promise.all([
        this.getTrendingForList(list.id, 'stars7d', 10),
        this.getTrendingForList(list.id, 'stars30d', 10),
        this.getTrendingForList(list.id, 'stars90d', 10),
      ]);

      result.push({
        slug: list.slug,
        name: list.name,
        description: list.description,
        githubRepo: list.githubRepo,
        categoryCount: list.categories.length,
        categories: list.categories.map((c) => ({
          id: c.id,
          name: c.name,
          slug: c.slug ?? '',
          itemCount: c._count.categoryItems,
        })),
        trending7d: t7,
        trending30d: t30,
        trending90d: t90,
      });
    }

    return result;
  }

  async exportGlobalTrending(): Promise<{
    '7d': StaticTrendingRepo[];
    '30d': StaticTrendingRepo[];
    '90d': StaticTrendingRepo[];
  }> {
    const [t7, t30, t90] = await Promise.all([
      this.getGlobalTrending('stars7d', 25),
      this.getGlobalTrending('stars30d', 25),
      this.getGlobalTrending('stars90d', 25),
    ]);
    return { '7d': t7, '30d': t30, '90d': t90 };
  }

  async exportRepoSlugs(): Promise<Array<{ listSlug: string; repoSlug: string }>> {
    const items = await this.prisma.categoryItem.findMany({
      where: { githubRepo: { not: null } },
      select: {
        githubRepo: true,
        category: {
          select: {
            awesomeList: { select: { slug: true } },
          },
        },
      },
      distinct: ['githubRepo'],
    });

    return items
      .filter((i) => i.category.awesomeList.slug)
      .map((i) => ({
        listSlug: i.category.awesomeList.slug,
        repoSlug: i.githubRepo!.replace('/', '-'),
      }));
  }

  async exportRepoDetail(owner: string, name: string): Promise<StaticRepoPage | null> {
    const githubRepo = `${owner}/${name}`;
    const repo = await this.prisma.repo.findUnique({
      where: { githubRepo },
      include: {
        starSnapshots: {
          orderBy: { snapshotDate: 'asc' },
          select: { snapshotDate: true, stars: true },
        },
        categoryItems: {
          include: {
            category: {
              include: {
                awesomeList: { select: { name: true, slug: true } },
              },
            },
          },
        },
      },
    });

    if (!repo) return null;

    return {
      githubRepo: repo.githubRepo,
      description: repo.description,
      stars: repo.stars,
      stars7d: repo.stars7d,
      stars30d: repo.stars30d,
      stars90d: repo.stars90d,
      lastCommitAt: repo.lastCommitAt?.toISOString() ?? null,
      starHistory: repo.starSnapshots.map((s) => ({
        snapshotDate: s.snapshotDate.toISOString().split('T')[0],
        stars: s.stars,
      })),
      foundIn: repo.categoryItems.map((ci) => ({
        categoryName: ci.category.name,
        categorySlug: ci.category.slug ?? '',
        listName: ci.category.awesomeList.name,
        listSlug: ci.category.awesomeList.slug,
      })),
    };
  }

  private async getTrendingForList(
    listId: number,
    column: 'stars7d' | 'stars30d' | 'stars90d',
    limit: number,
  ): Promise<StaticTrendingRepo[]> {
    const repos = await this.prisma.repo.findMany({
      where: {
        [column]: { gt: 0 },
        categoryItems: {
          some: { category: { awesomeListId: listId } },
        },
      },
      orderBy: { [column]: 'desc' },
      take: limit,
      include: {
        categoryItems: {
          take: 1,
          include: {
            category: {
              include: { awesomeList: { select: { slug: true } } },
            },
          },
        },
      },
    });

    return repos.map((r) => ({
      githubRepo: r.githubRepo,
      description: r.description,
      stars: r.stars,
      stars7d: r.stars7d,
      stars30d: r.stars30d,
      stars90d: r.stars90d,
      lastCommitAt: r.lastCommitAt?.toISOString() ?? null,
      categoryName: r.categoryItems[0]?.category.name ?? null,
      listSlug: r.categoryItems[0]?.category.awesomeList.slug ?? null,
    }));
  }

  private async getGlobalTrending(
    column: 'stars7d' | 'stars30d' | 'stars90d',
    limit: number,
  ): Promise<StaticTrendingRepo[]> {
    const repos = await this.prisma.repo.findMany({
      where: { [column]: { gt: 0 } },
      orderBy: { [column]: 'desc' },
      take: limit,
      include: {
        categoryItems: {
          take: 1,
          include: {
            category: {
              include: { awesomeList: { select: { slug: true } } },
            },
          },
        },
      },
    });

    return repos.map((r) => ({
      githubRepo: r.githubRepo,
      description: r.description,
      stars: r.stars,
      stars7d: r.stars7d,
      stars30d: r.stars30d,
      stars90d: r.stars90d,
      lastCommitAt: r.lastCommitAt?.toISOString() ?? null,
      categoryName: r.categoryItems[0]?.category.name ?? null,
      listSlug: r.categoryItems[0]?.category.awesomeList.slug ?? null,
    }));
  }
}
