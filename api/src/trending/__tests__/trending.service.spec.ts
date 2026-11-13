import { jest } from '@jest/globals';
import { TrendingService } from '../trending.service.js';
import { PrismaService } from '../../prisma/prisma.service.js';

interface Row {
  id: number;
  stars: number | null;
  stars7d: number | null;
  description: string | null;
  categoryItems: Array<{ githubDescription: string | null }>;
}

const row = (id: number, stars: number, stars7d: number): Row => ({
  id,
  stars,
  stars7d,
  description: `repo ${id}`,
  categoryItems: [],
});

const ROWS: Row[] = [
  row(1, 50_000, 12_000),
  row(2, 40_000, 2_000),
  row(3, 5_000, 300),
];

function build(
  rows: Row[],
  list: { slug: string; name: string; archived: boolean } | null,
) {
  const findMany = jest.fn<(args: unknown) => Promise<Row[]>>(() =>
    Promise.resolve(rows),
  );
  const findUnique = jest.fn<(args: unknown) => Promise<typeof list>>(() =>
    Promise.resolve(list),
  );
  const stub = { repo: { findMany }, awesomeList: { findUnique } };
  const service = new TrendingService(stub as unknown as PrismaService);
  return { service, findMany, findUnique };
}

const hottest = (r: { trophies: Array<{ id: string }> }) =>
  r.trophies.filter((t) => t.id === 'hottest-in-list');

const GO = { slug: 'go', name: 'awesome-go', archived: false };

describe('TrendingService trophies', () => {
  it('D-07: 7d list payload puts hottest-in-list on index 0 only, naming the list', async () => {
    const { service } = build(ROWS, GO);
    const out = await service.getTrendingByAwesomeList('go', '7d', 30);

    expect(hottest(out[0])).toEqual([
      { id: 'hottest-in-list', listSlug: 'go', listName: 'awesome-go' },
    ]);
    expect(hottest(out[1])).toEqual([]);
    expect(hottest(out[2])).toEqual([]);
    expect(out[0].trophies.map((t) => t.id)).toEqual([
      'surge-10k',
      'hottest-in-list',
      'fast-growing',
    ]);
    expect(out.every((r) => Array.isArray(r.trophies))).toBe(true);
  });

  it('D-07: list query orders by the period column desc, then id asc (tiebreak)', async () => {
    const { service, findMany } = build(ROWS, GO);
    await service.getTrendingByAwesomeList('go', '7d', 30);

    const args = findMany.mock.calls[0][0] as { orderBy: unknown };
    expect(args.orderBy).toEqual([{ stars7d: 'desc' }, { id: 'asc' }]);
  });

  it('D-07: 30d list payload carries no hottest-in-list and skips the list lookup', async () => {
    const { service, findUnique, findMany } = build(ROWS, GO);
    const out = await service.getTrendingByAwesomeList('go', '30d', 30);

    expect(out.some((r) => hottest(r).length > 0)).toBe(false);
    expect(findUnique).not.toHaveBeenCalled();
    // absolute trophies still attach on every period
    expect(out[0].trophies.map((t) => t.id)).toEqual([
      'surge-10k',
      'fast-growing',
    ]);
    const args = findMany.mock.calls[0][0] as { orderBy: unknown };
    expect(args.orderBy).toEqual([{ stars30d: 'desc' }, { id: 'asc' }]);
  });

  it('D-07: an archived list gives no hottest-in-list', async () => {
    const { service } = build(ROWS, { ...GO, archived: true });
    const out = await service.getTrendingByAwesomeList('go', '7d', 30);

    expect(out.some((r) => hottest(r).length > 0)).toBe(false);
  });

  it('D-07: an unknown list gives no hottest-in-list', async () => {
    const { service } = build(ROWS, null);
    const out = await service.getTrendingByAwesomeList('nope', '7d', 30);

    expect(out.some((r) => hottest(r).length > 0)).toBe(false);
  });

  it('D-07: zero rows skips the list lookup', async () => {
    const { service, findUnique } = build([], GO);
    const out = await service.getTrendingByAwesomeList('go', '7d', 30);

    expect(out).toEqual([]);
    expect(findUnique).not.toHaveBeenCalled();
  });

  it.each([-3, 0, Number.NaN])(
    'WR-01: list query never sends a non-positive take (limit %p)',
    async (limit) => {
      const { service, findMany } = build(ROWS, GO);
      await service.getTrendingByAwesomeList('go', '7d', limit);

      const args = findMany.mock.calls[0][0] as { take: number };
      expect(args.take).toBe(1);
    },
  );

  it('D-07: global payload attaches absolute trophies and never hottest-in-list', async () => {
    const { service, findUnique } = build(ROWS, GO);
    const out = await service.getGlobalTrending('7d', 10);

    expect(out[0].trophies.map((t) => t.id)).toEqual([
      'surge-10k',
      'fast-growing',
    ]);
    expect(out.some((r) => hottest(r).length > 0)).toBe(false);
    expect(findUnique).not.toHaveBeenCalled();
  });
});
