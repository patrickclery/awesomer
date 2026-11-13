import {
  STALE_DAYS,
  MIN_STARS,
  TROPHY_SURGE_HIGH,
  TROPHY_SURGE_LOW,
  TROPHY_FAST_GROWTH_RATIO,
  TROPHY_FAST_GROWTH_MIN_STARS,
} from '../constants.js';

describe('constants', () => {
  it('D-10: STALE_DAYS is exported and equals 365', () => {
    expect(STALE_DAYS).toBe(365);
  });

  it('MIN_STARS is exported and equals 100 (sanity check for co-located constant)', () => {
    expect(MIN_STARS).toBe(100);
  });

  // If one of these changes, update the matching copy in web/src/lib/trophies.ts ("10k+", "1,000+", "25%+").
  it('D-03: TROPHY_SURGE_HIGH equals 10_000 (update web/src/lib/trophies.ts copy when it changes)', () => {
    expect(TROPHY_SURGE_HIGH).toBe(10_000);
  });

  it('D-03: TROPHY_SURGE_LOW equals 1_000 (update web/src/lib/trophies.ts copy when it changes)', () => {
    expect(TROPHY_SURGE_LOW).toBe(1_000);
  });

  it('D-03: TROPHY_FAST_GROWTH_RATIO equals 0.25 (update web/src/lib/trophies.ts copy when it changes)', () => {
    expect(TROPHY_FAST_GROWTH_RATIO).toBe(0.25);
  });

  it('D-03: TROPHY_FAST_GROWTH_MIN_STARS equals 1_000 (update web/src/lib/trophies.ts copy when it changes)', () => {
    expect(TROPHY_FAST_GROWTH_MIN_STARS).toBe(1_000);
  });
});
