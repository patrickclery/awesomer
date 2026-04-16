import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

@Injectable()
export class CategoriesService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll() {
    return this.prisma.category.findMany({
      include: {
        awesomeList: { select: { id: true, name: true, slug: true } },
        _count: { select: { categoryItems: true } },
      },
      orderBy: { name: 'asc' },
    });
  }

  async findBySlug(slug: string) {
    return this.prisma.category.findUnique({
      where: { slug },
      include: {
        awesomeList: { select: { id: true, name: true, slug: true } },
        categoryItems: {
          include: {
            repo: {
              select: { stars7d: true, stars30d: true, stars90d: true },
            },
          },
          orderBy: { stars: { sort: 'desc', nulls: 'last' } },
        },
      },
    });
  }
}
