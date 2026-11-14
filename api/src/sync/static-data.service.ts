import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import {
  computeTrophies,
  findHottestRepoPerList,
  type Trophy,
} from '../trophies/trophies.js';

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
  trophies: Trophy[];
}

/** Longest description kept per repo in the public search index. */
export const SEARCH_DESCRIPTION_MAX = 200;

/**
 * Compact client-side search index, published as search-index.json.
 * Twin: web/src/lib/search.ts (SearchIndex) — change both together.
 */
export interface StaticSearchIndex {
  v: 1;
  /** Non-archived lists, ordered by name: [slug, name]. */
  lists: Array<[slug: string, name: string]>;
  /** Categories of non-archived lists: [index into lists, name, slug ('' when null)]. */
  cats: Array<[listIdx: number, name: string, slug: string]>;
  /** One row per distinct githubRepo, sorted by githubRepo; cats are indices into cats. */
  repos: Array<
    [
      githubRepo: string,
      name: string | null,
      description: string | null,
      stars: number | null,
      stars7d: number | null,
      stars30d: number | null,
      cats: number[],
    ]
  >;
}

@Injectable()
export class StaticDataService {
  constructor(private readonly prisma: PrismaService) {}

  async exportAllLists(): Promise<StaticListData[]> {
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      orderBy: { name: 'asc' },
      include: {
        repo: {
          select: { description: true },
        },
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
        description: list.repo?.description ?? null,
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

  async exportRepoSlugs(): Promise<Array<{ repoSlug: string }>> {
    const items = await this.prisma.categoryItem.findMany({
      where: { githubRepo: { not: null } },
      select: { githubRepo: true },
      distinct: ['githubRepo'],
    });
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      select: { githubRepo: true },
    });

    const slugs = new Set<string>();
    for (const i of items) slugs.add(i.githubRepo!.replace('/', '~'));
    for (const l of lists) slugs.add(l.githubRepo.replace('/', '~'));

    return Array.from(slugs).map((repoSlug) => ({ repoSlug }));
  }

  /** Builds the public search index from three queries (no per-repo queries). */
  async exportSearchIndex(): Promise<StaticSearchIndex> {
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      orderBy: { name: 'asc' },
      select: { id: true, name: true, slug: true },
    });
    const categories = await this.prisma.category.findMany({
      where: { awesomeList: { archived: false } },
      orderBy: [{ awesomeListId: 'asc' }, { name: 'asc' }],
      select: { id: true, name: true, slug: true, awesomeListId: true },
    });
    const items = await this.prisma.categoryItem.findMany({
      where: { githubRepo: { not: null } },
      orderBy: { id: 'asc' },
      select: {
        githubRepo: true,
        name: true,
        description: true,
        stars: true,
        categoryId: true,
        repo: { select: { description: true, stars: true, stars7d: true, stars30d: true } },
      },
    });

    // pg returns PKs as strings and FKs as numbers, so key every map by Number(id).
    const listIdx = new Map<number, number>();
    const outLists: StaticSearchIndex['lists'] = [];
    for (const l of lists) {
      listIdx.set(Number(l.id), outLists.length);
      outLists.push([l.slug, l.name]);
    }

    const catIdx = new Map<number, number>();
    const outCats: StaticSearchIndex['cats'] = [];
    for (const c of categories) {
      const li = listIdx.get(Number(c.awesomeListId));
      if (li === undefined) continue;
      catIdx.set(Number(c.id), outCats.length);
      outCats.push([li, c.name, c.slug ?? '']);
    }

    const groups = new Map<string, typeof items>();
    for (const item of items) {
      const key = item.githubRepo!;
      const group = groups.get(key);
      if (group) group.push(item);
      else groups.set(key, [item]);
    }

    const nonEmpty = (v: string | null | undefined): string | null => {
      const t = v?.trim();
      return t ? t : null;
    };

    const repos: StaticSearchIndex['repos'] = [];
    for (const [githubRepo, group] of groups) {
      const segment = githubRepo.split('/')[1] ?? githubRepo;
      const rawName = group.map((i) => nonEmpty(i.name)).find((n) => n !== null) ?? null;
      const name = rawName === null || rawName === segment ? null : rawName;
      const repo = group.find((i) => i.repo)?.repo ?? null;
      const desc =
        nonEmpty(repo?.description) ?? group.map((i) => nonEmpty(i.description)).find((d) => d !== null) ?? null;
      const description = desc === null ? null : desc.slice(0, SEARCH_DESCRIPTION_MAX).trim();
      const stars = repo?.stars ?? group.find((i) => i.stars !== null)?.stars ?? null;
      const cats: number[] = [];
      for (const i of group) {
        const ci = catIdx.get(Number(i.categoryId));
        if (ci !== undefined && !cats.includes(ci)) cats.push(ci);
      }
      repos.push([githubRepo, name, description, stars, repo?.stars7d ?? null, repo?.stars30d ?? null, cats]);
    }
    repos.sort((a, b) => (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));

    return { v: 1, lists: outLists, cats: outCats, repos };
  }

  async exportAllRepoDetails(): Promise<Array<{ repoSlug: string; data: StaticRepoPage }>> {
    // Filter to the same set exportRepoSlugs() returns, so generateStaticParams
    // and on-disk JSON files stay 1:1 (no orphans, no missing pages).
    const items = await this.prisma.categoryItem.findMany({
      where: { githubRepo: { not: null } },
      select: { githubRepo: true },
      distinct: ['githubRepo'],
    });
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      select: { githubRepo: true },
    });
    const wanted = new Set<string>();
    for (const i of items) wanted.add(i.githubRepo!);
    for (const l of lists) wanted.add(l.githubRepo);

    const repos = await this.prisma.repo.findMany({
      where: { githubRepo: { in: Array.from(wanted) } },
      include: {
        starSnapshots: {
          orderBy: { snapshotDate: 'asc' },
          select: { snapshotDate: true, stars: true },
        },
        categoryItems: {
          include: {
            category: {
              include: {
                awesomeList: { select: { name: true, slug: true, archived: true } },
              },
            },
          },
        },
      },
    });

    // One query per export, not per repo (T-19-09)
    const hottest = await findHottestRepoPerList(this.prisma);

    return repos.map((repo) => ({
      repoSlug: repo.githubRepo.replace('/', '~'),
      data: {
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
        foundIn: repo.categoryItems
          .filter((ci) => !ci.category.awesomeList.archived)
          .map((ci) => ({
            categoryName: ci.category.name,
            categorySlug: ci.category.slug ?? '',
            listName: ci.category.awesomeList.name,
            listSlug: ci.category.awesomeList.slug,
          })),
        trophies: computeTrophies(repo, {
          hottestInLists: hottest.get(repo.id) ?? [],
        }),
      },
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
                awesomeList: { select: { name: true, slug: true, archived: true } },
              },
            },
          },
        },
      },
    });

    if (!repo) return null;

    // Scoped to this repo's lists: the endpoint is public, so it must not rank every list (WR-02).
    const hottest = await findHottestRepoPerList(this.prisma, repo.id);

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
      foundIn: repo.categoryItems
        .filter((ci) => !ci.category.awesomeList.archived)
        .map((ci) => ({
          categoryName: ci.category.name,
          categorySlug: ci.category.slug ?? '',
          listName: ci.category.awesomeList.name,
          listSlug: ci.category.awesomeList.slug,
        })),
      trophies: computeTrophies(repo, {
        hottestInLists: hottest.get(repo.id) ?? [],
      }),
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
      description: r.description ?? r.categoryItems[0]?.githubDescription ?? null,
      stars: r.stars,
      stars7d: r.stars7d,
      stars30d: r.stars30d,
      stars90d: r.stars90d,
      lastCommitAt: r.lastCommitAt?.toISOString() ?? null,
      categoryName: r.categoryItems[0]?.category.name ?? null,
      listSlug: r.categoryItems[0]?.category.awesomeList.slug ?? null,
    }));
  }

  async getLastSnapshotDate(): Promise<string | null> {
    const latest = await this.prisma.starSnapshot.findFirst({
      orderBy: { snapshotDate: 'desc' },
      select: { snapshotDate: true },
    });
    return latest?.snapshotDate.toISOString().split('T')[0] ?? null;
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
      description: r.description ?? r.categoryItems[0]?.githubDescription ?? null,
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
