import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Octokit } from 'octokit';
import { throttling } from '@octokit/plugin-throttling';
import { MAX_STARGAZER_PAGES, STARGAZER_BACKFILL_DAYS } from '../common/constants.js';

interface RepoStats {
  stars: number;
  description: string | null;
  lastCommitAt: Date | null;
}

interface GraphQLRepoResult {
  stargazerCount: number;
  description: string | null;
  pushedAt: string | null;
}

export interface StargazersHistoryResult {
  /** Map of date (YYYY-MM-DD) to cumulative star count on that date */
  dailyCumulativeCounts: Map<string, number>;
  /** Total stargazers returned by the API */
  totalStargazers: number;
  /** True if the repo hit the 400-page limit (history is truncated) */
  truncated: boolean;
}

const ThrottledOctokit = Octokit.plugin(throttling);

@Injectable()
export class GithubService {
  private readonly logger = new Logger(GithubService.name);
  private readonly octokit: InstanceType<typeof ThrottledOctokit>;

  constructor(private readonly config: ConfigService) {
    const token = this.config.get<string>('GITHUB_API_KEY');
    if (!token) {
      this.logger.warn('GITHUB_API_KEY not set — GitHub API calls will fail');
    }

    this.octokit = new ThrottledOctokit({
      auth: token,
      throttle: {
        onRateLimit: (retryAfter, options, _octokit, retryCount) => {
          this.logger.warn(
            `Rate limit hit for ${options.method} ${options.url}. Retrying after ${retryAfter}s (attempt ${retryCount + 1})`,
          );
          return retryCount < 2;
        },
        onSecondaryRateLimit: (retryAfter, options, _octokit, retryCount) => {
          this.logger.warn(
            `Secondary rate limit hit for ${options.method} ${options.url}. Retrying after ${retryAfter}s`,
          );
          return retryCount < 1;
        },
      },
    });
  }

  /**
   * Fetch stats for a single repository via REST API
   */
  async fetchRepoStats(
    owner: string,
    repo: string,
  ): Promise<RepoStats | null> {
    try {
      const { data } = await this.octokit.rest.repos.get({ owner, repo });
      return {
        stars: data.stargazers_count,
        description: data.description,
        lastCommitAt: data.pushed_at ? new Date(data.pushed_at) : null,
      };
    } catch (error: unknown) {
      const status =
        error instanceof Error && 'status' in error
          ? (error as { status: number }).status
          : undefined;
      if (status === 404) {
        this.logger.debug(`Repo not found: ${owner}/${repo}`);
        return null;
      }
      this.logger.error(`Failed to fetch ${owner}/${repo}: ${error}`);
      return null;
    }
  }

  /**
   * Batch-fetch star counts for up to 100 repos via GraphQL
   */
  async batchFetchStars(
    repos: Array<{ owner: string; name: string; id: number }>,
  ): Promise<Map<number, GraphQLRepoResult>> {
    if (repos.length === 0) return new Map();

    const queryParts = repos.map(
      (r, i) =>
        `repo${i}: repository(owner: "${r.owner}", name: "${r.name}") { stargazerCount description pushedAt }`,
    );

    const query = `query { ${queryParts.join('\n')} }`;

    try {
      const result: Record<string, GraphQLRepoResult | null> =
        await this.octokit.graphql(query);

      return this.extractGraphQLResults(repos, result);
    } catch (error: unknown) {
      // GraphQL returns partial data alongside errors (e.g. deleted repos)
      const data = (error as { data?: Record<string, GraphQLRepoResult | null> }).data;
      if (data) {
        const errorCount = (error as { errors?: unknown[] }).errors?.length ?? 0;
        this.logger.warn(`GraphQL batch had ${errorCount} errors, extracting partial results`);
        return this.extractGraphQLResults(repos, data);
      }
      this.logger.error(`GraphQL batch fetch failed: ${error}`);
      return new Map();
    }
  }

  private extractGraphQLResults(
    repos: Array<{ owner: string; name: string; id: number }>,
    data: Record<string, GraphQLRepoResult | null>,
  ): Map<number, GraphQLRepoResult> {
    const results = new Map<number, GraphQLRepoResult>();
    repos.forEach((repo, i) => {
      const repoData = data[`repo${i}`];
      if (repoData) {
        results.set(repo.id, repoData);
      }
    });
    return results;
  }

  /**
   * Fetch stargazer history via GraphQL with `orderBy: STARRED_AT DESC`,
   * paginating newest-first until the oldest stargazer in the batch crosses
   * STARGAZER_BACKFILL_DAYS.
   *
   * Why GraphQL instead of REST: GitHub's REST stargazers endpoint hard-caps
   * at 400 pages (40,000 stargazers). pages 401+ return HTTP 422 and
   * `Link: rel="last"` reports 400 even for repos with millions of
   * stargazers, so the oldest 40k is the only data REST exposes — useless
   * for recent-window trending on big repos. GraphQL with DESC ordering
   * lets us walk newest→oldest and stop once we've covered the trending
   * window, which works uniformly for repos of every size.
   *
   * Cumulative anchoring: we compute cumulative counts so the newest date
   * in the result equals the live `totalCount`, which keeps trending deltas
   * accurate even when older history is missing.
   */
  async fetchStargazersHistory(
    owner: string,
    name: string,
  ): Promise<StargazersHistoryResult | null> {
    const dailyDeltas = new Map<string, number>();
    let totalStargazers = 0;
    let totalCount = 0;
    let cursor: string | null = null;
    let oldestDate: string | null = null;
    let pagesFetched = 0;

    const stopBefore = new Date();
    stopBefore.setUTCDate(stopBefore.getUTCDate() - STARGAZER_BACKFILL_DAYS);
    const stopBeforeISO = stopBefore.toISOString().slice(0, 10);

    try {
      while (pagesFetched < MAX_STARGAZER_PAGES) {
        const after = cursor ? `, after: "${cursor}"` : '';
        const query = `query {
          repository(owner: "${owner}", name: "${name}") {
            stargazers(first: 100${after}, orderBy: { field: STARRED_AT, direction: DESC }) {
              totalCount
              edges { starredAt }
              pageInfo { hasNextPage endCursor }
            }
          }
        }`;

        const result: {
          repository: {
            stargazers: {
              totalCount: number;
              edges: Array<{ starredAt: string }>;
              pageInfo: { hasNextPage: boolean; endCursor: string | null };
            };
          } | null;
        } = await this.octokit.graphql(query);

        if (!result.repository) return null;

        const sg = result.repository.stargazers;
        totalCount = sg.totalCount;
        pagesFetched++;

        if (sg.edges.length === 0) break;

        for (const edge of sg.edges) {
          const date = edge.starredAt.slice(0, 10);
          dailyDeltas.set(date, (dailyDeltas.get(date) ?? 0) + 1);
          totalStargazers++;
          oldestDate = date;
        }

        // Stop once we've covered the trending window
        if (oldestDate && oldestDate < stopBeforeISO) break;
        if (!sg.pageInfo.hasNextPage) break;
        cursor = sg.pageInfo.endCursor;
      }

      if (totalStargazers === 0) return null;

      const truncated = totalStargazers < totalCount && pagesFetched >= MAX_STARGAZER_PAGES;

      if (truncated) {
        this.logger.warn(
          `${owner}/${name}: hit ${MAX_STARGAZER_PAGES}-page cap after ${totalStargazers}/${totalCount} stargazers. Oldest fetched: ${oldestDate}.`,
        );
      }

      // Build cumulative counts. Anchor the newest date to totalCount so
      // trending against the live snapshot stays accurate.
      const sortedDates = [...dailyDeltas.keys()].sort();
      const dailyCumulativeCounts = new Map<string, number>();
      let cumulative = totalCount - totalStargazers;

      for (const date of sortedDates) {
        cumulative += dailyDeltas.get(date)!;
        dailyCumulativeCounts.set(date, cumulative);
      }

      this.logger.debug(
        `${owner}/${name}: ${totalStargazers}/${totalCount} stargazers across ${dailyCumulativeCounts.size} days (${pagesFetched} GraphQL pages, oldest=${oldestDate})`,
      );

      return { dailyCumulativeCounts, totalStargazers, truncated };
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : String(error);
      // GraphQL 404 surfaces as a "Could not resolve to a Repository" error
      if (/Could not resolve to a Repository|NOT_FOUND/i.test(message)) {
        this.logger.debug(`Repo not found: ${owner}/${name}`);
        return null;
      }
      this.logger.error(`Failed to fetch stargazers for ${owner}/${name}: ${message}`);
      return null;
    }
  }

  /**
   * Fetch README content for a repository
   */
  async fetchReadme(owner: string, repo: string): Promise<string | null> {
    try {
      const { data } = await this.octokit.rest.repos.getReadme({
        owner,
        repo,
        mediaType: { format: 'raw' },
      });
      return data as unknown as string;
    } catch (error: unknown) {
      const status =
        error instanceof Error && 'status' in error
          ? (error as { status: number }).status
          : undefined;
      if (status === 404) {
        this.logger.debug(`README not found: ${owner}/${repo}`);
        return null;
      }
      this.logger.error(`Failed to fetch README for ${owner}/${repo}: ${error}`);
      return null;
    }
  }

  /**
   * Parse "owner/repo" from a GitHub URL.
   * Only matches root repo URLs — rejects any URL with path segments
   * like /blob/, /tree/, /releases/, etc.
   */
  static parseGithubRepo(
    url: string,
  ): { owner: string; name: string } | null {
    const match = url.match(
      /^https?:\/\/github\.com\/(?<owner>[^/]+)\/(?<repo>[^/#?]+?)(?:\.git|#[^/]*|\?[^/]*|\/?)$/,
    );
    if (!match?.groups) return null;

    // Reject any URL with path segments beyond owner/repo
    if (/\/(?:blob|tree|raw|releases|issues|pull|wiki|actions|commit|commits|compare|network|insights|projects|security|pulse|graphs|settings|branches|tags)\//.test(url)) {
      return null;
    }

    return { owner: match.groups.owner, name: match.groups.repo };
  }
}
