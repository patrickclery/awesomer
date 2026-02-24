import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

@Injectable()
export class NewsletterService {
  constructor(private readonly prisma: PrismaService) {}

  async subscribe(email: string, awesomeListId: number) {
    const existing = await this.prisma.newsletterSubscriber.findFirst({
      where: { email, awesomeListId },
    });

    if (existing && !existing.unsubscribedAt) {
      throw new ConflictException('Already subscribed');
    }

    if (existing) {
      return this.prisma.newsletterSubscriber.update({
        where: { id: existing.id },
        data: { unsubscribedAt: null, confirmed: true },
      });
    }

    return this.prisma.newsletterSubscriber.create({
      data: {
        email,
        awesomeListId,
        confirmed: true,
      },
    });
  }

  async unsubscribe(email: string, awesomeListId: number) {
    const existing = await this.prisma.newsletterSubscriber.findFirst({
      where: { email, awesomeListId },
    });

    if (!existing || existing.unsubscribedAt) {
      return { unsubscribed: true };
    }

    await this.prisma.newsletterSubscriber.update({
      where: { id: existing.id },
      data: { unsubscribedAt: new Date() },
    });

    return { unsubscribed: true };
  }

  async getIssues(awesomeListSlug: string) {
    return this.prisma.newsletterIssue.findMany({
      where: {
        awesomeList: { slug: awesomeListSlug },
        sentAt: { not: null },
      },
      orderBy: { sentAt: 'desc' },
      select: {
        id: true,
        subject: true,
        sentAt: true,
        issueNumber: true,
      },
    });
  }
}
