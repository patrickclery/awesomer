import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

@Injectable()
export class AwesomeListsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll() {
    const lists = await this.prisma.awesomeList.findMany({
      where: { archived: false },
      include: {
        _count: {
          select: { categories: true },
        },
        repo: {
          select: { description: true, lastCommitAt: true },
        },
      },
      orderBy: { name: 'asc' },
    });

    return lists.map((list) => ({
      ...list,
      description: list.repo?.description ?? null,
      lastCommitAt: list.repo?.lastCommitAt ?? null,
    }));
  }

  async findBySlug(slug: string) {
    const list = await this.prisma.awesomeList.findUnique({
      where: { slug },
      include: {
        categories: {
          orderBy: { name: 'asc' },
          include: {
            _count: {
              select: { categoryItems: true },
            },
          },
        },
        repo: {
          select: { stars: true, description: true, lastCommitAt: true },
        },
      },
    });

    if (!list) return null;

    // Count all CategoryItems belonging to this list's categories (per D-01: "total repos tracked")
    // Reference pattern: trending.service.ts L103-112 uses `categoryItems: { some: { category: { awesomeListId } } }`
    // Here we count CategoryItems directly via category.awesomeListId.
    const categoryItemCount = await this.prisma.categoryItem.count({
      where: { category: { awesomeListId: list.id } },
    });

    return {
      ...list,
      description: list.repo?.description ?? null,
      lastCommitAt: list.repo?.lastCommitAt ?? null,
      _count: {
        categoryItems: categoryItemCount,
      },
    };
  }
}
