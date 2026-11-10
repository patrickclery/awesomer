import { NUMBERED_NAME_RE, summarizeParseResult } from '../parse-summary.js';
import type { ParseResult } from '../readme-parser.interface.js';

describe('summarizeParseResult', () => {
  const result: ParseResult = {
    categories: [
      { name: 'Deep Learning Frameworks', order: 0 },
      { name: '🧬 1. Core Frameworks & Libraries', order: 1 },
      { name: 'Unreferenced', order: 2 },
    ],
    items: [
      {
        name: 'A',
        primaryUrl: 'https://github.com/a/a',
        githubRepo: 'a/a',
        description: null,
        categoryIndex: 0,
      },
      {
        name: 'B',
        primaryUrl: 'https://github.com/a/b',
        githubRepo: 'a/b',
        description:
          '![GitHub stars](https://img.shields.io/github/stars/a/b?style=social)',
        categoryIndex: 0,
      },
      {
        name: 'C',
        primaryUrl: 'https://github.com/a/c',
        githubRepo: 'a/c',
        description: 'A clean description.',
        categoryIndex: 1,
      },
      {
        name: 'C again',
        primaryUrl: 'https://github.com/a/c',
        githubRepo: 'a/c',
        description: 'Same repo listed twice.',
        categoryIndex: 1,
      },
    ],
  };

  it('counts totals, unique URLs, null and badge descriptions, numbered and empty categories', () => {
    expect(summarizeParseResult(result)).toEqual({
      categories: 3,
      items: 4,
      uniqueUrls: 3,
      nullDescriptions: 1,
      badgeDescriptions: 1,
      numberedCategories: 1,
      emptyCategories: 1,
    });
  });

  it('reports zeros for an empty result', () => {
    expect(summarizeParseResult({ categories: [], items: [] })).toEqual({
      categories: 0,
      items: 0,
      uniqueUrls: 0,
      nullDescriptions: 0,
      badgeDescriptions: 0,
      numberedCategories: 0,
      emptyCategories: 0,
    });
  });
});

describe('NUMBERED_NAME_RE', () => {
  it.each([
    '1. Core Frameworks & Libraries',
    '🖥️ 12. User Interfaces & Self-hosted Platforms',
  ])('matches %s', (name) => {
    expect(NUMBERED_NAME_RE.test(name)).toBe(true);
  });

  it.each(['3D Generation', 'Deep Learning Frameworks'])(
    'does not match %s',
    (name) => {
      expect(NUMBERED_NAME_RE.test(name)).toBe(false);
    },
  );
});
