import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

@Injectable()
export class FeaturedService {
  constructor(private readonly prisma: PrismaService) {}

  async findActive(awesomeListSlug?: string) {
    return this.prisma.featuredProfile.findMany({
      where: {
        isActive: true,
        ...(awesomeListSlug
          ? { awesomeList: { slug: awesomeListSlug } }
          : {}),
      },
      include: {
        awesomeList: { select: { id: true, name: true, slug: true } },
      },
      orderBy: { featuredDate: 'desc' },
    });
  }

  async findAll() {
    return this.prisma.featuredProfile.findMany({
      include: {
        awesomeList: { select: { id: true, name: true, slug: true } },
      },
      orderBy: { featuredDate: 'desc' },
    });
  }
}
