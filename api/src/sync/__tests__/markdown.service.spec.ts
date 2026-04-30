/**
 * Behavioral tests for MarkdownService — Phase 24 gaps D-01 through D-15.
 *
 * Strategy:
 *   1. Build a fixture representing two AwesomeLists (one archived), multiple
 *      categories with mixed null-repo and linked-repo items, some below
 *      MIN_STARS, some older than STALE_DAYS. One repo that should NOT qualify
 *      for a repo page (stars < 100). One repo older than 365 days.
 *   2. Mock prisma.awesomeList.findMany and prisma.repo.findMany to return
 *      curated subsets based on the where clause.
 *   3. Call service.generateAll(tmpDir) once and assert on file contents.
 */

import { mkdtempSync, rmSync, readFileSync, existsSync, writeFileSync, mkdirSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';
import { jest } from '@jest/globals';
import { MarkdownService } from '../markdown.service.js';
import { PrismaService } from '../../prisma/prisma.service.js';

// ---------------------------------------------------------------------------
// Fixture data
// ---------------------------------------------------------------------------

const NOW = new Date('2026-04-29T00:00:00Z');

// A repo with lots of recent stars — qualifies for repo page
const REPO_HOT = {
  id: 1,
  githubRepo: 'Cursor-AI/Cursor',
  description: 'AI-powered code editor',
  stars: 45230,
  stars7d: 3421,
  stars30d: 12500,
  stars90d: 38000,
  lastCommitAt: new Date('2026-04-20T00:00:00Z'),
  categoryItems: [] as any[],
};

// A repo with moderate stars, also qualifies
const REPO_MODERATE = {
  id: 2,
  githubRepo: 'owner2/tool-two',
  description: 'A moderate tool',
  stars: 500,
  stars7d: 100,
  stars30d: 300,
  stars90d: 900,
  lastCommitAt: new Date('2026-03-15T00:00:00Z'),
  categoryItems: [] as any[],
};

// A repo with too few stars — must NOT get a repo page (< MIN_STARS=100)
const REPO_LOW_STARS = {
  id: 3,
  githubRepo: 'owner3/tiny-tool',
  description: 'Too few stars',
  stars: 50,
  stars7d: 5,
  stars30d: 15,
  stars90d: 45,
  lastCommitAt: new Date('2026-04-01T00:00:00Z'),
  categoryItems: [] as any[],
};

// A repo with stale lastCommitAt — must NOT get a repo page (> 365 days old)
const REPO_STALE = {
  id: 4,
  githubRepo: 'owner4/old-tool',
  description: 'Very old project',
  stars: 1000,
  stars7d: 200,
  stars30d: 600,
  stars90d: 1800,
  lastCommitAt: new Date('2024-01-01T00:00:00Z'), // > 365 days before 2026-04-29
  categoryItems: [] as any[],
};

// A category item with no repo link (raw primaryUrl item)
const ITEM_NO_REPO = {
  id: 10,
  name: 'SomeWebTool',
  primaryUrl: 'https://example.com/tool',
  description: 'A web-only tool',
  githubDescription: null,
  stars: null,
  repoId: null,
  repo: null,
};

// A category item linked to REPO_HOT
const ITEM_HOT = {
  id: 11,
  name: 'Cursor',
  primaryUrl: 'https://github.com/Cursor-AI/Cursor',
  description: 'AI code editor',
  githubDescription: 'AI-powered code editor',
  stars: 45230,
  repoId: 1,
  repo: {
    githubRepo: 'Cursor-AI/Cursor',
    stars: 45230,
    stars7d: 3421,
    stars30d: 12500,
    stars90d: 38000,
    lastCommitAt: new Date('2026-04-20T00:00:00Z'),
    description: 'AI-powered code editor',
  },
};

// A category item linked to REPO_MODERATE — lower 7d than ITEM_HOT
const ITEM_MODERATE = {
  id: 12,
  name: 'ToolTwo',
  primaryUrl: 'https://github.com/owner2/tool-two',
  description: 'A moderate tool',
  githubDescription: 'A moderate tool',
  stars: 500,
  repoId: 2,
  repo: {
    githubRepo: 'owner2/tool-two',
    stars: 500,
    stars7d: 100,
    stars30d: 300,
    stars90d: 900,
    lastCommitAt: new Date('2026-03-15T00:00:00Z'),
    description: 'A moderate tool',
  },
};

// A category item linked to REPO_LOW_STARS (syncThreshold-like item — must NOT be filtered)
const ITEM_LOW_STARS = {
  id: 13,
  name: 'TinyTool',
  primaryUrl: 'https://github.com/owner3/tiny-tool',
  description: 'This has fewer than 100 stars but must still appear in category listing',
  githubDescription: null,
  stars: 50,
  repoId: 3,
  repo: {
    githubRepo: 'owner3/tiny-tool',
    stars: 50,
    stars7d: 5,
    stars30d: 15,
    stars90d: 45,
    lastCommitAt: new Date('2026-04-01T00:00:00Z'),
    description: 'A tiny tool',
  },
};

// Category for the active list
const CAT_AI = {
  id: 100,
  name: 'AI Assistants',
  awesomeListId: 1,
  categoryItems: [ITEM_HOT, ITEM_MODERATE, ITEM_NO_REPO, ITEM_LOW_STARS],
  awesomeList: { name: 'Claude Code Tools', slug: 'claude-code-tools' },
};

const CAT_CLI = {
  id: 101,
  name: 'CLI Tools',
  awesomeListId: 1,
  categoryItems: [ITEM_MODERATE],
  awesomeList: { name: 'Claude Code Tools', slug: 'claude-code-tools' },
};

// Active awesome list (non-archived)
const LIST_ACTIVE = {
  id: 1,
  name: 'Claude Code Tools',
  slug: 'claude-code-tools',
  githubRepo: 'owner/claude-code-tools',
  archived: false,
  syncThreshold: 10,
  repo: {
    description: 'Tools for Claude Code users',
    stars: 8900,
    stars7d: 500,
    stars30d: 1500,
    stars90d: 4500,
  },
  categories: [CAT_AI, CAT_CLI],
};

// Archived awesome list — must NOT appear in output
const LIST_ARCHIVED = {
  id: 2,
  name: 'Old List',
  slug: 'old-list',
  githubRepo: 'owner/old-list',
  archived: true,
  syncThreshold: 10,
  repo: null,
  categories: [],
};

// ---------------------------------------------------------------------------
// Wire up categoryItems' category references for "Found In"
// ---------------------------------------------------------------------------

REPO_HOT.categoryItems = [{
  id: 11,
  repoId: 1,
  category: {
    id: 100,
    name: 'AI Assistants',
    awesomeList: { name: 'Claude Code Tools', slug: 'claude-code-tools', archived: false },
  },
}];

REPO_MODERATE.categoryItems = [{
  id: 12,
  repoId: 2,
  category: {
    id: 100,
    name: 'AI Assistants',
    awesomeList: { name: 'Claude Code Tools', slug: 'claude-code-tools', archived: false },
  },
}, {
  id: 15,
  repoId: 2,
  category: {
    id: 101,
    name: 'CLI Tools',
    awesomeList: { name: 'Claude Code Tools', slug: 'claude-code-tools', archived: false },
  },
}];

// ---------------------------------------------------------------------------
// Mock Prisma client
// ---------------------------------------------------------------------------

function buildMockPrisma() {
  return {
    awesomeList: {
      findMany: jest.fn((args: any) => {
        const where = args?.where ?? {};
        let lists = [LIST_ACTIVE, LIST_ARCHIVED];

        // Filter archived
        if (where.archived === false) {
          lists = lists.filter((l) => !l.archived);
        }

        // Filter where repo.isNot null (hero section query)
        if (where.repo?.isNot === null) {
          lists = lists.filter((l) => l.repo !== null);
        }

        // Apply take
        if (args?.take) {
          lists = lists.slice(0, args.take);
        }

        return Promise.resolve(lists);
      }),
    },
    repo: {
      findMany: jest.fn((args: any) => {
        const where = args?.where ?? {};
        let repos = [REPO_HOT, REPO_MODERATE, REPO_LOW_STARS, REPO_STALE];

        // Filter stars >= MIN_STARS
        if (where.stars?.gte !== undefined) {
          repos = repos.filter((r) => (r.stars ?? 0) >= where.stars.gte);
        }

        // Filter lastCommitAt >= cutoffDate
        if (where.lastCommitAt?.gte !== undefined) {
          repos = repos.filter((r) => r.lastCommitAt && r.lastCommitAt >= where.lastCommitAt.gte);
        }

        // Filter stars7d > 0 and not null (top 10 query)
        if (where.stars7d?.gt !== undefined) {
          repos = repos.filter((r) => (r.stars7d ?? 0) > where.stars7d.gt);
        }

        // Apply take
        if (args?.take) {
          repos = repos.slice(0, args.take);
        }

        return Promise.resolve(repos);
      }),
    },
  };
}

// ---------------------------------------------------------------------------
// Test setup
// ---------------------------------------------------------------------------

let tmpDir: string;
let service: MarkdownService;
let mockPrisma: ReturnType<typeof buildMockPrisma>;

beforeEach(async () => {
  tmpDir = mkdtempSync(join(tmpdir(), 'markdown-service-test-'));
  mockPrisma = buildMockPrisma();
  service = new MarkdownService(mockPrisma as unknown as PrismaService);

  // Mock the GitHub API fetch that generateHomepage() tries to make so tests
  // are deterministic in offline environments
  global.fetch = jest
    .fn<() => Promise<{ ok: boolean }>>()
    .mockResolvedValue({ ok: false }) as unknown as typeof fetch;

  await service.generateAll(tmpDir);
});

afterEach(() => {
  rmSync(tmpDir, { recursive: true, force: true });
  jest.restoreAllMocks();
});

// ---------------------------------------------------------------------------
// D-11: l/ and r/ subdirectories exist
// ---------------------------------------------------------------------------

describe('D-11: generateAll creates l/ and r/ subdirectories', () => {
  it('creates l/ subdirectory under outputDir', () => {
    expect(existsSync(join(tmpDir, 'l'))).toBe(true);
  });

  it('creates r/ subdirectory under outputDir', () => {
    expect(existsSync(join(tmpDir, 'r'))).toBe(true);
  });
});

// ---------------------------------------------------------------------------
// README.md exists
// ---------------------------------------------------------------------------

describe('README.md is generated', () => {
  it('generates README.md at outputDir/README.md', () => {
    expect(existsSync(join(tmpDir, 'README.md'))).toBe(true);
  });
});

// ---------------------------------------------------------------------------
// D-01: README.md hero section
// ---------------------------------------------------------------------------

describe('D-01: README.md contains Hottest This Week hero section', () => {
  let readme: string;

  beforeEach(() => {
    readme = readFileSync(join(tmpDir, 'README.md'), 'utf-8');
  });

  it('contains "## Hottest This Week:" heading', () => {
    expect(readme).toContain('## Hottest This Week:');
  });

  it('links the hero list to l/{slug}.md', () => {
    // The active list has slug claude-code-tools
    expect(readme).toContain('l/claude-code-tools.md');
  });

  it('includes a stars table row for the hero list', () => {
    // Should have the stars column header
    expect(readme).toMatch(/\|\s*Stars\s*\|/);
  });
});

// ---------------------------------------------------------------------------
// D-02: README.md Top 10 Trending Repos table
// ---------------------------------------------------------------------------

describe('D-02: README.md contains Top 10 Trending Repos table', () => {
  let readme: string;

  beforeEach(() => {
    readme = readFileSync(join(tmpDir, 'README.md'), 'utf-8');
  });

  it('contains "## Top 10 Trending Repos" heading', () => {
    expect(readme).toContain('## Top 10 Trending Repos');
  });

  it('table uses stars >= MIN_STARS=100 filter (low-star repos excluded from top10)', () => {
    // REPO_LOW_STARS has only 50 stars — its name should NOT appear in the top10 table
    // (it may appear in list pages but not in the top 10 trending repos section)
    // We verify that the findMany for repos was called with stars: { gte: 100 }
    const repoFindManyCalls = mockPrisma.repo.findMany.mock.calls;
    const top10Call = repoFindManyCalls.find(
      (call: any[]) => call[0]?.where?.stars?.gte !== undefined,
    );
    expect(top10Call).toBeDefined();
    expect(top10Call![0].where.stars.gte).toBe(100);
  });

  it('repo link in top 10 uses relative r/{owner~repo}.md path from README (no ../ prefix)', () => {
    // From root, repo links should be r/... not ../r/...
    expect(readme).toMatch(/\]\(r\/cursor-ai~cursor\.md\)/);
  });

  it('list link in top 10 uses relative l/{slug}.md path from README (no ../ prefix)', () => {
    expect(readme).toMatch(/\]\(l\/claude-code-tools\.md\)/);
  });
});

// ---------------------------------------------------------------------------
// D-03: README.md All Awesome Lists table
// ---------------------------------------------------------------------------

describe('D-03: README.md contains all-lists table', () => {
  let readme: string;

  beforeEach(() => {
    readme = readFileSync(join(tmpDir, 'README.md'), 'utf-8');
  });

  it('contains "## All Awesome Lists" heading', () => {
    expect(readme).toContain('## All Awesome Lists');
  });

  it('includes active list in the table', () => {
    expect(readme).toContain('Claude Code Tools');
  });

  it('does NOT include the archived list in the table', () => {
    expect(readme).not.toContain('Old List');
  });

  it('links list to l/{slug}.md', () => {
    expect(readme).toMatch(/\[Claude Code Tools\]\(l\/claude-code-tools\.md\)/);
  });
});

// ---------------------------------------------------------------------------
// D-14: Footer in README.md
// ---------------------------------------------------------------------------

describe('D-14: README.md footer references LIVE_SITE_BASE', () => {
  it('footer contains https://patrickclery.com/awesomer', () => {
    const readme = readFileSync(join(tmpDir, 'README.md'), 'utf-8');
    expect(readme).toContain('https://patrickclery.com/awesomer');
  });
});

// ---------------------------------------------------------------------------
// D-04: Per-list page has Top 10 Trending section
// ---------------------------------------------------------------------------

describe('D-04: l/{slug}.md contains Top 10 Trending section', () => {
  let listPage: string;

  beforeEach(() => {
    listPage = readFileSync(join(tmpDir, 'l', 'claude-code-tools.md'), 'utf-8');
  });

  it('l/claude-code-tools.md is generated', () => {
    expect(existsSync(join(tmpDir, 'l', 'claude-code-tools.md'))).toBe(true);
  });

  it('contains "## Top 10 Trending" heading', () => {
    expect(listPage).toContain('## Top 10 Trending');
  });

  it('top 10 items are sorted by stars7d descending (ITEM_HOT before ITEM_MODERATE)', () => {
    const hotIdx = listPage.indexOf('Cursor');
    const modIdx = listPage.indexOf('ToolTwo');
    // ITEM_HOT has stars7d=3421, ITEM_MODERATE has stars7d=100 — hot must appear first
    expect(hotIdx).toBeGreaterThan(-1);
    expect(modIdx).toBeGreaterThan(-1);
    expect(hotIdx).toBeLessThan(modIdx);
  });
});

// ---------------------------------------------------------------------------
// D-05: Per-list page includes every category item (no per-category limit)
// ---------------------------------------------------------------------------

describe('D-05: l/{slug}.md includes every item with primaryUrl', () => {
  let listPage: string;

  beforeEach(() => {
    listPage = readFileSync(join(tmpDir, 'l', 'claude-code-tools.md'), 'utf-8');
  });

  it('includes ITEM_NO_REPO (item without a linked Repo)', () => {
    expect(listPage).toContain('SomeWebTool');
  });

  it('includes ITEM_LOW_STARS (item with stars below MIN_STARS — no per-category cutoff)', () => {
    expect(listPage).toContain('TinyTool');
  });

  it('includes ITEM_HOT', () => {
    expect(listPage).toContain('Cursor');
  });
});

// ---------------------------------------------------------------------------
// D-06: Category items sorted by stars7d desc, then name asc
// ---------------------------------------------------------------------------

describe('D-06: category items sorted by stars7d desc, name asc tiebreak', () => {
  it('in AI Assistants category, Cursor (stars7d=3421) appears before ToolTwo (stars7d=100)', () => {
    const listPage = readFileSync(join(tmpDir, 'l', 'claude-code-tools.md'), 'utf-8');

    // Find positions within the AI Assistants section
    const aiAssistantsIdx = listPage.indexOf('## AI Assistants');
    const afterSection = listPage.slice(aiAssistantsIdx);

    const cursorIdx = afterSection.indexOf('Cursor');
    const toolTwoIdx = afterSection.indexOf('ToolTwo');

    expect(cursorIdx).toBeGreaterThan(-1);
    expect(toolTwoIdx).toBeGreaterThan(-1);
    expect(cursorIdx).toBeLessThan(toolTwoIdx);
  });
});

// ---------------------------------------------------------------------------
// D-07: No syncThreshold filter — items below threshold remain in output
// ---------------------------------------------------------------------------

describe('D-07: no syncThreshold/threshold filter applied to category items', () => {
  it('ITEM_LOW_STARS (50 stars, below threshold of 10 but also below MIN_STARS) still appears in list page', () => {
    const listPage = readFileSync(join(tmpDir, 'l', 'claude-code-tools.md'), 'utf-8');
    // TinyTool has only 50 stars — the old code would filter by syncThreshold.
    // The new code must include it in the category listing.
    expect(listPage).toContain('TinyTool');
  });

  it('generateListPages query does NOT include a syncThreshold where clause', () => {
    // Verify mock was called without any syncThreshold filter
    const calls = mockPrisma.awesomeList.findMany.mock.calls as any[][];
    const listPageCall = calls.find((call) =>
      call[0]?.include?.categories?.include?.categoryItems !== undefined,
    );
    expect(listPageCall).toBeDefined();
    // The where clause on categoryItems must not reference syncThreshold
    const ciWhere = listPageCall![0].include.categories.include.categoryItems.where;
    if (ciWhere) {
      expect(ciWhere).not.toHaveProperty('stars');
      expect(ciWhere).not.toHaveProperty('syncThreshold');
    }
    // A null/undefined ciWhere is also acceptable (means no star filter)
  });
});

// ---------------------------------------------------------------------------
// D-08: Repo page has ## Stats and ## Found In sections
// ---------------------------------------------------------------------------

describe('D-08: r/{owner~repo}.md contains Stats and Found In sections', () => {
  let repoPage: string;

  beforeEach(() => {
    // REPO_HOT qualifies (stars=45230 >= 100, lastCommitAt recent, active list)
    repoPage = readFileSync(join(tmpDir, 'r', 'cursor-ai~cursor.md'), 'utf-8');
  });

  it('r/cursor-ai~cursor.md is generated for qualifying repo', () => {
    expect(existsSync(join(tmpDir, 'r', 'cursor-ai~cursor.md'))).toBe(true);
  });

  it('contains "## Stats" section', () => {
    expect(repoPage).toContain('## Stats');
  });

  it('Stats table includes star count', () => {
    expect(repoPage).toMatch(/\|\s*Stars\s*\|/);
  });

  it('contains "## Found In" section', () => {
    expect(repoPage).toContain('## Found In');
  });

  it('Found In links to the owning list page', () => {
    expect(repoPage).toContain('../l/claude-code-tools.md');
  });
});

// ---------------------------------------------------------------------------
// D-09: generateRepoPages filters stars >= MIN_STARS, lastCommitAt >= now-365d,
//        attached to non-archived list
// ---------------------------------------------------------------------------

describe('D-09: repo page query filters qualifying repos correctly', () => {
  it('repo page for REPO_LOW_STARS (50 stars) is NOT generated', () => {
    expect(existsSync(join(tmpDir, 'r', 'owner3~tiny-tool.md'))).toBe(false);
  });

  it('repo page for REPO_STALE (lastCommitAt > 365 days ago) is NOT generated', () => {
    expect(existsSync(join(tmpDir, 'r', 'owner4~old-tool.md'))).toBe(false);
  });

  it('repo page for REPO_HOT (stars=45230, recent commit) IS generated', () => {
    expect(existsSync(join(tmpDir, 'r', 'cursor-ai~cursor.md'))).toBe(true);
  });

  it('repo page for REPO_MODERATE (stars=500, recent commit) IS generated', () => {
    expect(existsSync(join(tmpDir, 'r', 'owner2~tool-two.md'))).toBe(true);
  });

  it('repo findMany was called with stars >= MIN_STARS (100)', () => {
    const calls = mockPrisma.repo.findMany.mock.calls as any[][];
    const repoPageCall = calls.find((call) =>
      call[0]?.where?.lastCommitAt !== undefined,
    );
    expect(repoPageCall).toBeDefined();
    expect(repoPageCall![0].where.stars.gte).toBe(100);
  });

  it('repo findMany was called with lastCommitAt >= cutoffDate (approx 365 days ago)', () => {
    const calls = mockPrisma.repo.findMany.mock.calls as any[][];
    const repoPageCall = calls.find((call) =>
      call[0]?.where?.lastCommitAt !== undefined,
    );
    expect(repoPageCall).toBeDefined();
    const cutoffDate = repoPageCall![0].where.lastCommitAt.gte as Date;
    const now = new Date();
    const diffDays = (now.getTime() - cutoffDate.getTime()) / (1000 * 60 * 60 * 24);
    // Allow a 2-day tolerance around the exact 365 cutoff
    expect(diffDays).toBeGreaterThanOrEqual(363);
    expect(diffDays).toBeLessThanOrEqual(367);
  });
});

// ---------------------------------------------------------------------------
// D-12: cleanupOldFiles removes only flat .md files in root, not subdirs or README.md
// ---------------------------------------------------------------------------

describe('D-12: cleanupOldFiles preserves README.md and subdirectories', () => {
  it('README.md is preserved after generateAll()', () => {
    expect(existsSync(join(tmpDir, 'README.md'))).toBe(true);
  });

  it('old flat .md files in root are removed (but README.md is kept)', async () => {
    // Set up a separate tmp dir with a pre-existing old flat .md file
    const cleanupTmpDir = mkdtempSync(join(tmpdir(), 'cleanup-test-'));
    try {
      // Write a stale flat .md file that should be cleaned up
      writeFileSync(join(cleanupTmpDir, 'awesome-go.md'), '# Old', 'utf-8');
      writeFileSync(join(cleanupTmpDir, 'README.md'), '# Home', 'utf-8');
      mkdirSync(join(cleanupTmpDir, 'l'), { recursive: true });
      mkdirSync(join(cleanupTmpDir, 'r'), { recursive: true });

      // Run generateAll against this dir
      const freshMockPrisma = buildMockPrisma();
      const freshService = new MarkdownService(freshMockPrisma as unknown as PrismaService);

      global.fetch = jest
        .fn<() => Promise<{ ok: boolean }>>()
        .mockResolvedValue({ ok: false }) as unknown as typeof fetch;
      await freshService.generateAll(cleanupTmpDir);

      // awesome-go.md should be removed
      expect(existsSync(join(cleanupTmpDir, 'awesome-go.md'))).toBe(false);
      // README.md should still exist
      expect(existsSync(join(cleanupTmpDir, 'README.md'))).toBe(true);
      // l/ and r/ subdirectories are not touched
      expect(existsSync(join(cleanupTmpDir, 'l'))).toBe(true);
      expect(existsSync(join(cleanupTmpDir, 'r'))).toBe(true);
    } finally {
      rmSync(cleanupTmpDir, { recursive: true, force: true });
    }
  });
});

// ---------------------------------------------------------------------------
// D-13: Cross-links use relative paths
// ---------------------------------------------------------------------------

describe('D-13: cross-links use relative paths', () => {
  it('README.md uses l/{slug}.md (no ../ prefix — from root)', () => {
    const readme = readFileSync(join(tmpDir, 'README.md'), 'utf-8');
    expect(readme).toMatch(/\]\(l\/claude-code-tools\.md\)/);
    // Must NOT use ../l/ from root
    expect(readme).not.toMatch(/\]\(\.\.\/l\//);
  });

  it('README.md uses r/{owner~repo}.md (no ../ prefix — from root)', () => {
    const readme = readFileSync(join(tmpDir, 'README.md'), 'utf-8');
    expect(readme).toMatch(/\]\(r\/cursor-ai~cursor\.md\)/);
    expect(readme).not.toMatch(/\]\(\.\.\/r\//);
  });

  it('l/{slug}.md uses ../README.md for home link (from subdir)', () => {
    const listPage = readFileSync(join(tmpDir, 'l', 'claude-code-tools.md'), 'utf-8');
    expect(listPage).toContain('../README.md');
  });

  it('l/{slug}.md uses ../r/{owner~repo}.md for repo links (from subdir)', () => {
    const listPage = readFileSync(join(tmpDir, 'l', 'claude-code-tools.md'), 'utf-8');
    expect(listPage).toMatch(/\]\(\.\.\/r\/cursor-ai~cursor\.md\)/);
  });

  it('r/{owner~repo}.md uses ../README.md for home link (from subdir)', () => {
    const repoPage = readFileSync(join(tmpDir, 'r', 'cursor-ai~cursor.md'), 'utf-8');
    expect(repoPage).toContain('../README.md');
  });

  it('r/{owner~repo}.md uses ../l/{slug}.md for found-in links (from subdir)', () => {
    const repoPage = readFileSync(join(tmpDir, 'r', 'cursor-ai~cursor.md'), 'utf-8');
    expect(repoPage).toContain('../l/claude-code-tools.md');
  });
});

// ---------------------------------------------------------------------------
// D-14: Footer of every page references LIVE_SITE_BASE
// ---------------------------------------------------------------------------

describe('D-14: every page footer references live site URL', () => {
  it('list page footer has https://patrickclery.com/awesomer', () => {
    const listPage = readFileSync(join(tmpDir, 'l', 'claude-code-tools.md'), 'utf-8');
    expect(listPage).toContain('https://patrickclery.com/awesomer');
  });

  it('repo page footer has https://patrickclery.com/awesomer', () => {
    const repoPage = readFileSync(join(tmpDir, 'r', 'cursor-ai~cursor.md'), 'utf-8');
    expect(repoPage).toContain('https://patrickclery.com/awesomer');
  });
});

// ---------------------------------------------------------------------------
// D-15: Repo page header uses original-case githubRepo for "View on GitHub"
//        but filename slug uses lowercased owner~repo
// ---------------------------------------------------------------------------

describe('D-15: repo page header uses original-case githubRepo, filename uses lowercase slug', () => {
  it('filename for Cursor-AI/Cursor is cursor-ai~cursor.md (lowercased)', () => {
    // File should be at the lowercased path
    expect(existsSync(join(tmpDir, 'r', 'cursor-ai~cursor.md'))).toBe(true);
    // And NOT at the original-case path
    expect(existsSync(join(tmpDir, 'r', 'Cursor-AI~Cursor.md'))).toBe(false);
  });

  it('View on GitHub link inside r/cursor-ai~cursor.md uses original-case Cursor-AI/Cursor', () => {
    const repoPage = readFileSync(join(tmpDir, 'r', 'cursor-ai~cursor.md'), 'utf-8');
    // The "View on GitHub" link must point to the original-case repo URL
    expect(repoPage).toContain('https://github.com/Cursor-AI/Cursor');
    // And the live site link uses the lowercased slug
    expect(repoPage).toContain('https://patrickclery.com/awesomer/r/cursor-ai~cursor/');
  });
});
