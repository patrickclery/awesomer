import { jest } from '@jest/globals';
import { MIN_STARS } from '../../common/constants.js';
import type { PrismaService } from '../../prisma/prisma.service.js';
import {
  computeTrophies,
  findHottestRepoPerList,
  type ListRef,
} from '../trophies.js';

const ALPHA: ListRef = { listSlug: 'alpha', listName: 'Awesome Alpha' };
const ZETA: ListRef = { listSlug: 'zeta', listName: 'Awesome Zeta' };

const ids = (stars: number | null, stars7d: number | null, lists?: ListRef[]) =>
  computeTrophies(
    { stars, stars7d },
    lists ? { hottestInLists: lists } : undefined,
  ).map((t) => t.id);

describe('computeTrophies', () => {
  describe('D-01 priority order', () => {
    it('D-01: sorts surge-10k, hottest-in-list (given order), fast-growing', () => {
      const out = computeTrophies(
        { stars: 50_000, stars7d: 12_000 },
        { hottestInLists: [ALPHA, ZETA] },
      );
      expect(out.map((t) => t.id)).toEqual([
        'surge-10k',
        'hottest-in-list',
        'hottest-in-list',
        'fast-growing',
      ]);
      expect(out[1]).toEqual({
        id: 'hottest-in-list',
        listSlug: 'alpha',
        listName: 'Awesome Alpha',
      });
      expect(out[2]).toEqual({
        id: 'hottest-in-list',
        listSlug: 'zeta',
        listName: 'Awesome Zeta',
      });
    });

    it('D-01: surge-1k comes after fast-growing', () => {
      expect(ids(4_000, 2_000)).toEqual(['fast-growing', 'surge-1k']);
    });
  });

  describe('D-02 exclusive surge tiers', () => {
    it('D-02: stars7d 10_000 gives surge-10k and no surge-1k', () => {
      expect(ids(1_000_000, 10_000)).toEqual(['surge-10k']);
    });

    it('D-02: stars7d 9_999 gives surge-1k and no surge-10k', () => {
      expect(ids(1_000_000, 9_999)).toEqual(['surge-1k']);
    });

    it('D-02: stars7d 1_000 gives surge-1k', () => {
      expect(ids(1_000_000, 1_000)).toEqual(['surge-1k']);
    });

    it('D-02: stars7d 999 gives no surge', () => {
      expect(ids(1_000_000, 999)).toEqual([]);
    });
  });

  describe('D-01 fast-growing boundary', () => {
    it('D-01: stars 1_250 / stars7d 250 (exactly 25% of the base) gives fast-growing', () => {
      expect(ids(1_250, 250)).toEqual(['fast-growing']);
    });

    it('D-01: stars 1_251 / stars7d 250 (just under 25%) gives nothing', () => {
      expect(ids(1_251, 250)).toEqual([]);
    });

    it('D-01: stars 999 / stars7d 500 (below the minimum stars) gives nothing', () => {
      expect(ids(999, 500)).toEqual([]);
    });
  });

  describe('D-08 missing data never earns a trophy', () => {
    it.each([null, 0, -5])(
      'D-08: stars7d %p gives [] even with hottestInLists',
      (d7) => {
        expect(ids(50_000, d7)).toEqual([]);
        expect(ids(50_000, d7, [ALPHA])).toEqual([]);
      },
    );

    it('D-08: stars null with stars7d 2_000 gives surge-1k only (no fast-growing)', () => {
      expect(ids(null, 2_000)).toEqual(['surge-1k']);
    });

    it('D-08: base of zero (stars 1_000 / stars7d 1_000) never divides', () => {
      expect(() =>
        computeTrophies({ stars: 1_000, stars7d: 1_000 }),
      ).not.toThrow();
      expect(ids(1_000, 1_000)).toEqual(['surge-1k']);
    });

    it('D-08: negative base (stars 1_500 / stars7d 2_000) never divides', () => {
      expect(() =>
        computeTrophies({ stars: 1_500, stars7d: 2_000 }),
      ).not.toThrow();
      expect(ids(1_500, 2_000)).toEqual(['surge-1k']);
    });
  });
});

describe('findHottestRepoPerList', () => {
  const stub = (rows: unknown[]) => {
    const $queryRaw = jest.fn(() => Promise.resolve(rows));
    return { $queryRaw, prisma: { $queryRaw } as unknown as PrismaService };
  };

  it('D-07: groups rows by Number(repo_id) and sorts each repo\'s lists by listName', async () => {
    const { prisma } = stub([
      { repo_id: 5, list_slug: 'zeta', list_name: 'Zeta list' },
      { repo_id: 5, list_slug: 'alpha', list_name: 'Alpha list' },
      { repo_id: '7', list_slug: 'go', list_name: 'awesome-go' },
    ]);
    const map = await findHottestRepoPerList(prisma);
    expect(map.get(5)).toEqual([
      { listSlug: 'alpha', listName: 'Alpha list' },
      { listSlug: 'zeta', listName: 'Zeta list' },
    ]);
    expect(map.get(7)).toEqual([{ listSlug: 'go', listName: 'awesome-go' }]);
    expect((map as Map<unknown, unknown>).has('7')).toBe(false);
    expect(map.size).toBe(2);
  });

  it('D-07: an empty result gives an empty Map', async () => {
    const { prisma } = stub([]);
    const map = await findHottestRepoPerList(prisma);
    expect(map.size).toBe(0);
  });

  it('D-07: runs exactly one query', async () => {
    const { prisma, $queryRaw } = stub([]);
    await findHottestRepoPerList(prisma);
    expect($queryRaw).toHaveBeenCalledTimes(1);
  });

  it('T-19-07: binds MIN_STARS as a parameter and mirrors the list-page filter and tiebreak', async () => {
    const { prisma, $queryRaw } = stub([]);
    await findHottestRepoPerList(prisma);
    const [strings, ...values] = $queryRaw.mock.calls[0] as unknown as [
      TemplateStringsArray,
      ...unknown[],
    ];
    const sql = strings.join('?');
    expect(sql).toMatch(/DISTINCT ON \(al\.id\)/);
    expect(sql).toMatch(/al\.archived = false/);
    expect(sql).toMatch(/r\.stars >= \?/);
    expect(sql).toMatch(/r\.stars_7d > 0/);
    expect(sql).toMatch(/r\.stars_7d DESC,\s*r\.id ASC/);
    expect(sql).not.toContain(String(MIN_STARS));
    expect(values).toEqual([MIN_STARS, null, null]);
  });

  it("WR-02: a repoId scopes the ranking to that repo's lists, bound as a parameter", async () => {
    const { prisma, $queryRaw } = stub([]);
    await findHottestRepoPerList(prisma, 42);
    expect($queryRaw).toHaveBeenCalledTimes(1);
    const [strings, ...values] = $queryRaw.mock.calls[0] as unknown as [
      TemplateStringsArray,
      ...unknown[],
    ];
    const sql = strings.join('?');
    // Same DISTINCT ON ranking; the scope only filters which lists come back.
    expect(sql).toMatch(/DISTINCT ON \(al\.id\)/);
    expect(sql).toMatch(/r\.stars_7d DESC,\s*r\.id ASC/);
    expect(sql).toMatch(/\?::integer IS NULL OR al\.id IN \(/);
    expect(sql).toMatch(/WHERE ci2\.repo_id = \?::integer/);
    expect(sql).not.toContain('42');
    expect(values).toEqual([MIN_STARS, 42, 42]);
  });
});
