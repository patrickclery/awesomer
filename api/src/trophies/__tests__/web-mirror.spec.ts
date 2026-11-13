/**
 * The web keeps a hand-written mirror of the trophy ids and the threshold copy ("10k+", "1,000+",
 * "25%+") because it cannot import from api/. This spec reads those web files as text (no
 * cross-package import, so neither build is affected) and checks them against the API, so a
 * threshold or id change that misses the web fails here (IN-02). Run from api/, like the other specs.
 */

import { readFileSync } from 'fs';
import { resolve } from 'path';
import {
  TROPHY_FAST_GROWTH_RATIO,
  TROPHY_SURGE_HIGH,
  TROPHY_SURGE_LOW,
} from '../../common/constants.js';

const read = (rel: string) =>
  readFileSync(resolve(process.cwd(), rel), 'utf-8');

const apiTrophies = read('src/trophies/trophies.ts');
const webApi = read('../web/src/lib/api.ts');
const webTrophies = read('../web/src/lib/trophies.ts');

/** The quoted members of `export type TrophyId = ...;`, sorted. */
function trophyIds(src: string): string[] {
  const m = /export type TrophyId\s*=([^;]+);/.exec(src);
  if (!m) throw new Error('TrophyId union not found');
  return [...m[1].matchAll(/'([^']+)'/g)].map((x) => x[1]).sort();
}

/** The body of one TROPHY_META entry, from its key up to the next entry. */
function metaEntry(id: string): string {
  const start = webTrophies.indexOf(`'${id}': {`);
  if (start < 0) throw new Error(`TROPHY_META has no '${id}' entry`);
  const next = webTrophies.indexOf("variant: 'trophy--", start);
  return webTrophies.slice(start, next);
}

const thousands = (n: number) => n.toLocaleString('en-US');
const kilo = (n: number) => `${n / 1_000}k`;

describe('web trophy mirror matches the API (IN-02)', () => {
  it('IN-02: web TrophyId union has the same ids as the API', () => {
    expect(trophyIds(webApi)).toEqual(trophyIds(apiTrophies));
  });

  it('IN-02: TROPHY_META has an entry for every API trophy id', () => {
    for (const id of trophyIds(apiTrophies))
      expect(() => metaEntry(id)).not.toThrow();
  });

  it('IN-02: surge-10k copy names TROPHY_SURGE_HIGH', () => {
    const entry = metaEntry('surge-10k');
    expect(entry).toContain(`'${kilo(TROPHY_SURGE_HIGH)}+ this week'`);
    expect(entry).toContain(`Gained ${thousands(TROPHY_SURGE_HIGH)}+ stars`);
  });

  it('IN-02: surge-1k copy names TROPHY_SURGE_LOW', () => {
    const entry = metaEntry('surge-1k');
    expect(entry).toContain(`'${kilo(TROPHY_SURGE_LOW)}+ this week'`);
    expect(entry).toContain(`Gained ${thousands(TROPHY_SURGE_LOW)}+ stars`);
  });

  it('IN-02: fast-growing copy names TROPHY_FAST_GROWTH_RATIO', () => {
    expect(metaEntry('fast-growing')).toContain(
      `${TROPHY_FAST_GROWTH_RATIO * 100}%+`,
    );
  });
});
