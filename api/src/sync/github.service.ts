import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Octokit } from 'octokit';
import { throttling } from '@octokit/plugin-throttling';

interface RepoStats {
  stars: number;
  description: string | null;
  lastCommitAt: Date | null;
}

interface GraphQLRepoResult {
  stargazerCount: number;
  pushedAt: string | null;
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
        `repo${i}: repository(owner: "${r.owner}", name: "${r.name}") { stargazerCount pushedAt }`,
    );

    const query = `query { ${queryParts.join('\n')} }`;

    try {
      const result: { repository?: Record<string, GraphQLRepoResult> } =
        await this.octokit.graphql(query);

      const results = new Map<number, GraphQLRepoResult>();

      repos.forEach((repo, i) => {
        const data = (result as Record<string, GraphQLRepoResult | null>)[
          `repo${i}`
        ];
        if (data) {
          results.set(repo.id, data);
        }
      });

      return results;
    } catch (error) {
      this.logger.error(`GraphQL batch fetch failed: ${error}`);
      return new Map();
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
   * Parse "owner/repo" from a GitHub URL
   */
  static parseGithubRepo(
    url: string,
  ): { owner: string; name: string } | null {
    const match = url.match(
      /^https?:\/\/github\.com\/(?<owner>[^/]+)\/(?<repo>[^/#?]+?)(?:\.git|#[^/]*|\?[^/]*|\/?)$/,
    );
    if (!match?.groups) return null;

    // Reject URLs with path segments (blob, tree, releases, etc.)
    const excludedPaths = [
      '/tree/',
      '/blob/',
      '/releases/',
      '/issues/',
      '/pull/',
      '/wiki/',
      '/actions/',
      '/projects/',
      '/security/',
      '/pulse/',
      '/graphs/',
      '/settings/',
      '/commit/',
      '/commits/',
      '/branches/',
      '/tags/',
      '/compare/',
      '/network/',
      '/insights/',
    ];
    if (excludedPaths.some((p) => url.includes(p))) return null;

    return { owner: match.groups.owner, name: match.groups.repo };
  }
}
