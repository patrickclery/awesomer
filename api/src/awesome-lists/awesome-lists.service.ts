import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

@Injectable()
export class AwesomeListsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll() {
    return this.prisma.awesomeList.findMany({
      where: { archived: false },
      include: {
        _count: {
          select: { categories: true },
        },
      },
      orderBy: { name: 'asc' },
    });
  }

  async findBySlug(slug: string) {
    return this.prisma.awesomeList.findUnique({
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
      },
    });
  }
}
