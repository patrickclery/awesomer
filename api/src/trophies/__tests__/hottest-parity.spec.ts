/**
 * D-07 parity: the list hero (Prisma findMany in getTrendingByAwesomeList) and the detail page
 * (raw SQL in findHottestRepoPerList) must pick the same #1 repo. They are two separate queries,
 * so this spec captures both and checks them against each other: change one filter or tiebreak
 * without the other and it fails (WR-03).
 */

import { jest } from '@jest/globals';
import { MIN_STARS } from '../../common/constants.js';
import type { PrismaService } from '../../prisma/prisma.service.js';
import { TrendingService } from '../../trending/trending.service.js';
import { findHottestRepoPerList } from '../trophies.js';

async function capturePrismaArgs() {
  const findMany = jest.fn<(args: unknown) => Promise<unknown[]>>(() =>
    Promise.resolve([]),
  );
  const stub = { repo: { findMany }, awesomeList: { findUnique: jest.fn() } };
  const service = new TrendingService(stub as unknown as PrismaService);
  await service.getTrendingByAwesomeList('go', '7d', 30);
  return findMany.mock.calls[0][0] as {
    where: { stars: unknown; stars7d: unknown };
    orderBy: unknown;
  };
}

async function captureSql() {
  const $queryRaw = jest.fn(() => Promise.resolve([]));
  await findHottestRepoPerList({ $queryRaw } as unknown as PrismaService);
  const [strings, ...values] = $queryRaw.mock.calls[0] as unknown as [
    TemplateStringsArray,
    ...unknown[],
  ];
  return { sql: strings.join('?'), values };
}

describe('D-07 hottest-in-list parity (list hero vs detail page)', () => {
  it('WR-03: both apply the same minimum-stars floor', async () => {
    const { where } = await capturePrismaArgs();
    const { sql, values } = await captureSql();

    expect(where.stars).toEqual({ gte: MIN_STARS });
    expect(sql).toMatch(/r\.stars >= \?/);
    // The first bound value is the stars floor; it must be the same number the list page uses.
    expect(values[0]).toBe((where.stars as { gte: number }).gte);
  });

  it('WR-03: both require a positive 7d gain', async () => {
    const { where } = await capturePrismaArgs();
    const { sql } = await captureSql();

    expect(where.stars7d).toEqual({ not: null, gt: 0 });
    expect(sql).toMatch(/r\.stars_7d > 0/);
  });

  it('WR-03: both rank by 7d gain desc, then id asc', async () => {
    const { orderBy } = await capturePrismaArgs();
    const { sql } = await captureSql();

    expect(orderBy).toEqual([{ stars7d: 'desc' }, { id: 'asc' }]);
    expect(sql).toMatch(/ORDER BY al\.id, r\.stars_7d DESC,\s*r\.id ASC/);
  });

  it('WR-03: the Prisma where has no extra repo filter the SQL lacks', async () => {
    const { where } = await capturePrismaArgs();

    // stars, stars7d and list membership are the only filters; anything new must be mirrored in SQL.
    expect(Object.keys(where).sort()).toEqual([
      'categoryItems',
      'stars',
      'stars7d',
    ]);
  });
});
