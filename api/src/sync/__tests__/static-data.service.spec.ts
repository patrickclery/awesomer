/**
 * StaticDataService repo-detail exports carry trophies (D-07, D-12): the web/data/r/*.json
 * files the /r/[ownerName] page reads. The hottest-per-list query runs once per export.
 */

import { jest } from '@jest/globals';
import type { PrismaService } from '../../prisma/prisma.service.js';
import { StaticDataService } from '../static-data.service.js';

const row = (id: number, githubRepo: string, stars: number, stars7d: number) => ({
  id,
  githubRepo,
  description: null,
  stars,
  stars7d,
  stars30d: null,
  stars90d: null,
  lastCommitAt: null,
  starSnapshots: [],
  categoryItems: []
});

const HOT = row(1, 'a/hot', 50_000, 12_000);
const COLD = row(2, 'b/cold', 500, 0);
const HOTTEST_ROWS = [{ repo_id: 1, list_slug: 'go', list_name: 'awesome-go' }];

const makeStub = (single: unknown = null) => {
  const db = {
    categoryItem: {
      findMany: jest.fn(() => Promise.resolve([{ githubRepo: 'a/hot' }, { githubRepo: 'b/cold' }]))
    },
    awesomeList: { findMany: jest.fn(() => Promise.resolve([])) },
    repo: {
      findMany: jest.fn(() => Promise.resolve([HOT, COLD])),
      findUnique: jest.fn(() => Promise.resolve(single))
    },
    $queryRaw: jest.fn(() => Promise.resolve(HOTTEST_ROWS))
  };
  return { db, service: new StaticDataService(db as unknown as PrismaService) };
};

describe('StaticDataService.exportAllRepoDetails trophies', () => {
  it('D-07, D-12: the hot repo gets its trophies with the list it leads, the cold repo gets []', async () => {
    const { db, service } = makeStub();
    const out = await service.exportAllRepoDetails();

    const hot = out.find((e) => e.repoSlug === 'a~hot');
    const cold = out.find((e) => e.repoSlug === 'b~cold');
    expect(hot).toBeDefined();
    expect(cold).toBeDefined();
    expect(hot!.data.trophies.map((t) => t.id)).toEqual(['surge-10k', 'hottest-in-list', 'fast-growing']);
    expect(hot!.data.trophies[1]).toEqual({
      id: 'hottest-in-list',
      listSlug: 'go',
      listName: 'awesome-go'
    });
    expect(cold!.data.trophies).toEqual([]);
    expect(db.$queryRaw).toHaveBeenCalledTimes(1);
  });
});

describe('StaticDataService.exportRepoDetail trophies', () => {
  it('D-07: a hot repo gets the same three trophies', async () => {
    const { db, service } = makeStub(HOT);
    const d = await service.exportRepoDetail('a', 'hot');
    expect(d!.trophies.map((t) => t.id)).toEqual(['surge-10k', 'hottest-in-list', 'fast-growing']);
    expect(db.$queryRaw).toHaveBeenCalledTimes(1);
  });

  it('WR-02: the single-repo export scopes the hottest query to that repo', async () => {
    const { db, service } = makeStub(HOT);
    await service.exportRepoDetail('a', 'hot');
    const values = (db.$queryRaw.mock.calls[0] as unknown[]).slice(1);
    expect(values).toContain(HOT.id);
  });

  it('WR-02: the bulk export ranks every list (no repo scope)', async () => {
    const { db, service } = makeStub();
    await service.exportAllRepoDetails();
    const values = (db.$queryRaw.mock.calls[0] as unknown[]).slice(1);
    expect(values.slice(1)).toEqual([null, null]);
  });

  it('D-08, D-16: a repo with no 7d gain exports an empty trophies array', async () => {
    const { service } = makeStub(COLD);
    const d = await service.exportRepoDetail('b', 'cold');
    expect(d!.trophies).toEqual([]);
  });

  it('returns null for an unknown repo without querying hottest', async () => {
    const { db, service } = makeStub(null);
    expect(await service.exportRepoDetail('x', 'y')).toBeNull();
    expect(db.$queryRaw).not.toHaveBeenCalled();
  });
});

describe('StaticDataService.exportSearchIndex', () => {
  const LISTS = [
    { id: '10', name: 'awesome-go', slug: 'go' },
    { id: '20', name: 'awesome-mail', slug: 'mail' }
  ];
  const CATEGORIES = [
    { id: '100', name: 'Servers', slug: 'servers', awesomeListId: 20 },
    { id: '101', name: 'Clients', slug: null, awesomeListId: 20 },
    { id: '200', name: 'Web', slug: 'web', awesomeListId: 10 }
  ];
  const repo = (description: string | null, stars: number | null, stars7d: number | null, stars30d: number | null) => ({
    description,
    stars,
    stars7d,
    stars30d
  });
  const ITEMS = [
    { githubRepo: 'x/mailcow', name: 'mailcow', description: 'item desc', stars: 9, categoryId: 100, repo: repo('Mail server suite', 1000, 5, 30) },
    { githubRepo: 'x/mailcow', name: 'mailcow', description: null, stars: 9, categoryId: 101, repo: repo('Mail server suite', 1000, 5, 30) },
    { githubRepo: 'x/mailcow', name: 'mailcow', description: null, stars: 9, categoryId: 100, repo: repo('Mail server suite', 1000, 5, 30) },
    { githubRepo: 'a/archived', name: 'Archived Thing', description: '  ' + 'd'.repeat(300), stars: null, categoryId: 999, repo: null },
    { githubRepo: 'b/gin', name: 'Gin Web', description: 'fallback', stars: 7, categoryId: 200, repo: repo('', null, null, null) }
  ];

  const makeIndexStub = () => {
    const db = {
      awesomeList: { findMany: jest.fn(() => Promise.resolve(LISTS)) },
      category: { findMany: jest.fn(() => Promise.resolve(CATEGORIES)) },
      categoryItem: { findMany: jest.fn(() => Promise.resolve(ITEMS)) }
    };
    return { db, service: new StaticDataService(db as unknown as PrismaService) };
  };

  it('emits the tuple shape: lists, categories with null slugs as empty strings, repos sorted by githubRepo', async () => {
    const { service } = makeIndexStub();
    const index = await service.exportSearchIndex();

    expect(index.v).toBe(1);
    expect(index.lists).toEqual([
      ['go', 'awesome-go'],
      ['mail', 'awesome-mail']
    ]);
    expect(index.cats).toEqual([
      [1, 'Servers', 'servers'],
      [1, 'Clients', ''],
      [0, 'Web', 'web']
    ]);
    expect(index.repos.map((r) => r[0])).toEqual(['a/archived', 'b/gin', 'x/mailcow']);
  });

  it('collapses items of one repo into a single entry whose cats lists each category once', async () => {
    const { service } = makeIndexStub();
    const index = await service.exportSearchIndex();
    const mailcow = index.repos.find((r) => r[0] === 'x/mailcow')!;

    expect(index.repos.filter((r) => r[0] === 'x/mailcow')).toHaveLength(1);
    expect(mailcow).toEqual(['x/mailcow', null, 'Mail server suite', 1000, 5, 30, [0, 1]]);
  });

  it('keeps a repo whose categories are all outside the non-archived set, with cats []', async () => {
    const { service } = makeIndexStub();
    const index = await service.exportSearchIndex();
    const archived = index.repos.find((r) => r[0] === 'a/archived')!;

    expect(archived[6]).toEqual([]);
    expect(archived[1]).toBe('Archived Thing');
    expect(archived[2]).toBe('d'.repeat(200));
    expect(archived[3]).toBeNull();
    expect(archived[4]).toBeNull();
    expect(archived[5]).toBeNull();
  });

  it('falls back to the item description and item stars when the repo has none', async () => {
    const { service } = makeIndexStub();
    const index = await service.exportSearchIndex();

    expect(index.repos.find((r) => r[0] === 'b/gin')).toEqual(['b/gin', 'Gin Web', 'fallback', 7, null, null, [2]]);
  });

  it('selects explicit fields only and runs exactly three queries', async () => {
    const { db, service } = makeIndexStub();
    await service.exportSearchIndex();

    expect(db.awesomeList.findMany).toHaveBeenCalledTimes(1);
    expect(db.category.findMany).toHaveBeenCalledTimes(1);
    expect(db.categoryItem.findMany).toHaveBeenCalledTimes(1);
    const [itemArgs] = db.categoryItem.findMany.mock.calls[0] as unknown as [{ select: Record<string, unknown> }];
    expect(Object.keys(itemArgs.select).sort()).toEqual(['categoryId', 'description', 'githubRepo', 'name', 'repo', 'stars']);
  });
});
