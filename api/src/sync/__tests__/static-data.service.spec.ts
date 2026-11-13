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
