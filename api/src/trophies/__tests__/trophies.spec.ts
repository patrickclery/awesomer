import { computeTrophies, type ListRef } from '../trophies.js';

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
