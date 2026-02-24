import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service.js';

interface ListmonkCampaign {
  id: number;
  name: string;
  subject: string;
  status: string;
}

@Injectable()
export class ListmonkService {
  private readonly logger = new Logger(ListmonkService.name);
  private readonly baseUrl: string;
  private readonly authHeader: string;

  constructor(
    private readonly config: ConfigService,
    private readonly prisma: PrismaService,
  ) {
    this.baseUrl =
      this.config.get<string>('LISTMONK_URL') || 'http://listmonk:9000';
    const user = this.config.get<string>('LISTMONK_USER') || 'admin';
    const pass = this.config.get<string>('LISTMONK_PASSWORD') || 'admin';
    this.authHeader = `Basic ${Buffer.from(`${user}:${pass}`).toString('base64')}`;
  }

  /**
   * Generate a weekly digest newsletter for an awesome list
   */
  async generateWeeklyDigest(awesomeListId: number): Promise<string> {
    const list = await this.prisma.awesomeList.findUnique({
      where: { id: awesomeListId },
    });
    if (!list) throw new Error(`Awesome list ${awesomeListId} not found`);

    // Get top 10 trending repos (7d)
    const trending7d = await this.prisma.repo.findMany({
      where: {
        stars7d: { gt: 0 },
        categoryItems: {
          some: { category: { awesomeListId } },
        },
      },
      orderBy: { stars7d: 'desc' },
      take: 10,
      select: {
        githubRepo: true,
        description: true,
        stars: true,
        stars7d: true,
        stars30d: true,
      },
    });

    // Get new repos added this week
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
    const newRepos = await this.prisma.categoryItem.findMany({
      where: {
        category: { awesomeListId },
        createdAt: { gte: oneWeekAgo },
      },
      take: 5,
      orderBy: { stars: { sort: 'desc', nulls: 'last' } },
      select: {
        name: true,
        primaryUrl: true,
        stars: true,
        githubDescription: true,
      },
    });

    // Build HTML newsletter
    const html = this.buildNewsletterHtml(list.name, trending7d, newRepos);
    return html;
  }

  /**
   * Push a campaign to Listmonk
   */
  async createCampaign(
    name: string,
    subject: string,
    body: string,
    listIds: number[],
  ): Promise<ListmonkCampaign | null> {
    try {
      const response = await fetch(`${this.baseUrl}/api/campaigns`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: this.authHeader,
        },
        body: JSON.stringify({
          name,
          subject,
          body,
          content_type: 'html',
          type: 'regular',
          lists: listIds,
        }),
      });

      if (!response.ok) {
        this.logger.error(
          `Failed to create Listmonk campaign: ${response.status}`,
        );
        return null;
      }

      const data = (await response.json()) as { data: ListmonkCampaign };
      this.logger.log(`Created Listmonk campaign: ${data.data.id}`);
      return data.data;
    } catch (error) {
      this.logger.error(`Listmonk API error: ${error}`);
      return null;
    }
  }

  private buildNewsletterHtml(
    listName: string,
    trending: Array<{
      githubRepo: string;
      description: string | null;
      stars: number | null;
      stars7d: number | null;
      stars30d: number | null;
    }>,
    newRepos: Array<{
      name: string | null;
      primaryUrl: string | null;
      stars: number | null;
      githubDescription: string | null;
    }>,
  ): string {
    const trendingRows = trending
      .map(
        (repo, i) => `
      <tr>
        <td style="padding: 8px; border-bottom: 1px solid #262626;">${i + 1}</td>
        <td style="padding: 8px; border-bottom: 1px solid #262626;">
          <a href="https://github.com/${repo.githubRepo}" style="color: #3b82f6; text-decoration: none;">
            ${repo.githubRepo}
          </a>
          ${repo.description ? `<br><span style="color: #737373; font-size: 12px;">${repo.description.substring(0, 100)}</span>` : ''}
        </td>
        <td style="padding: 8px; border-bottom: 1px solid #262626; text-align: right;">${repo.stars?.toLocaleString() ?? '-'}</td>
        <td style="padding: 8px; border-bottom: 1px solid #262626; text-align: right; color: #22c55e;">+${repo.stars7d ?? 0}</td>
      </tr>`,
      )
      .join('');

    const newReposList = newRepos
      .map(
        (repo) => `
      <li style="margin-bottom: 8px;">
        <a href="${repo.primaryUrl || '#'}" style="color: #3b82f6; text-decoration: none;">
          ${repo.name || 'Unknown'}
        </a>
        ${repo.stars ? ` (${repo.stars.toLocaleString()} stars)` : ''}
        ${repo.githubDescription ? `<br><span style="color: #737373; font-size: 12px;">${repo.githubDescription.substring(0, 120)}</span>` : ''}
      </li>`,
      )
      .join('');

    return `
<!DOCTYPE html>
<html>
<body style="background-color: #0a0a0a; color: #ededed; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; padding: 20px;">
  <div style="max-width: 600px; margin: 0 auto;">
    <h1 style="color: #ededed; border-bottom: 2px solid #3b82f6; padding-bottom: 12px;">
      ${listName} Weekly Digest
    </h1>

    <h2 style="color: #ededed; margin-top: 24px;">Top Trending This Week</h2>
    <table style="width: 100%; border-collapse: collapse; font-size: 14px;">
      <thead>
        <tr style="color: #737373;">
          <th style="padding: 8px; text-align: left;">#</th>
          <th style="padding: 8px; text-align: left;">Repository</th>
          <th style="padding: 8px; text-align: right;">Stars</th>
          <th style="padding: 8px; text-align: right;">+7d</th>
        </tr>
      </thead>
      <tbody>
        ${trendingRows}
      </tbody>
    </table>

    ${
      newRepos.length > 0
        ? `
    <h2 style="color: #ededed; margin-top: 24px;">New This Week</h2>
    <ul style="padding-left: 20px;">
      ${newReposList}
    </ul>`
        : ''
    }

    <hr style="border: none; border-top: 1px solid #262626; margin: 24px 0;" />
    <p style="color: #737373; font-size: 12px;">
      Powered by <a href="https://awesomer.dev" style="color: #3b82f6;">awesomer</a> — data-driven open source discovery.
      <br>
      <a href="{{ .UnsubscribeURL }}" style="color: #737373;">Unsubscribe</a>
    </p>
  </div>
</body>
</html>`;
  }
}
