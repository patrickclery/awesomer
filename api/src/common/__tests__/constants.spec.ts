import { STALE_DAYS, MIN_STARS } from '../constants.js';

describe('constants', () => {
  it('D-10: STALE_DAYS is exported and equals 365', () => {
    expect(STALE_DAYS).toBe(365);
  });

  it('MIN_STARS is exported and equals 100 (sanity check for co-located constant)', () => {
    expect(MIN_STARS).toBe(100);
  });
});
