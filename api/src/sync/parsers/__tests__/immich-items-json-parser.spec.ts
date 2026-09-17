import { ImmichItemsJsonParser } from '../immich-items-json-parser.js';

// Mirrors the upstream key set of apps/awesome.immich.app/src/data/items.json
// (top level is an array of categories; each project carries
// title / description / websiteUrl / sourceCodeUrl, and optionally tags).
const MOCK_ITEMS_JSON = JSON.stringify([
  {
    name: 'Client apps',
    id: 'client-apps',
    types: ['app'],
    projects: [
      {
        title: 'ImmichFrame',
        description: 'Run an Immich slideshow in a photo frame.',
        websiteUrl: 'https://immichframe.dev',
        sourceCodeUrl: 'https://github.com/immichFrame/ImmichFrame/',
        tags: ['Official'],
      },
      {
        title: 'Immich Setup Guide',
        description: 'A written walkthrough with no source repository.',
        websiteUrl: 'https://example.com/guide',
      },
      {
        title: 'Vexcited Client',
        description: 'Hosted on a non-GitHub forge.',
        websiteUrl: 'https://example.com/vexcited',
        sourceCodeUrl: 'https://code.vexcited.com/immich/immich-client',
      },
      {
        title: 'Deep Linked Doc',
        description: 'Points at a file inside a repo, not the repo root.',
        websiteUrl: 'https://example.com/deep',
        sourceCodeUrl: 'https://github.com/immich-app/immich/blob/main/README.md',
      },
      {
        title: '<b>Bold App</b>',
        description: 'A <script>alert(1)</script>markup-carrying description.',
        websiteUrl: 'https://example.com/bold',
        sourceCodeUrl: 'https://github.com/acme/bold-app',
      },
      {
        title: 'Immich Kiosk',
        description: 'A kiosk display for Immich.',
        websiteUrl: 'https://example.com/kiosk',
        sourceCodeUrl: 'https://github.com/damongolding/immich-kiosk.git',
      },
    ],
  },
  {
    name: 'Tools',
    id: 'tools',
    projects: [
      {
        title: 'ImmichFrame',
        description: 'The same repo, listed again under a second category.',
        websiteUrl: 'https://immichframe.dev',
        sourceCodeUrl: 'https://github.com/immichFrame/ImmichFrame',
      },
    ],
  },
]);

describe('ImmichItemsJsonParser', () => {
  const parser = new ImmichItemsJsonParser();
  const result = parser.parse(MOCK_ITEMS_JSON);

  it('declares the upstream data file as its source path', () => {
    expect(parser.sourcePath).toBe('apps/awesome.immich.app/src/data/items.json');
  });

  it('emits one category per upstream entry with order matching array position', () => {
    expect(result.categories).toEqual([
      { name: 'Client apps', order: 0 },
      { name: 'Tools', order: 1 },
    ]);
  });

  it('drops an entry that has no sourceCodeUrl', () => {
    expect(result.items.find((i) => i.name === 'Immich Setup Guide')).toBeUndefined();
  });

  it('drops an entry hosted on a non-GitHub forge', () => {
    expect(result.items.find((i) => i.name === 'Vexcited Client')).toBeUndefined();
    expect(result.items.some((i) => i.primaryUrl.includes('vexcited'))).toBe(false);
  });

  it('drops an entry whose sourceCodeUrl is a GitHub deep link', () => {
    expect(result.items.find((i) => i.name === 'Deep Linked Doc')).toBeUndefined();
    expect(result.items.some((i) => i.primaryUrl.includes('/blob/'))).toBe(false);
  });

  it('rebuilds primaryUrl and githubRepo from owner/name despite a trailing slash', () => {
    const frame = result.items.find((i) => i.name === 'ImmichFrame');
    expect(frame).toBeDefined();
    expect(frame!.primaryUrl).toBe('https://github.com/immichFrame/ImmichFrame');
    expect(frame!.githubRepo).toBe('immichFrame/ImmichFrame');
  });

  it('rebuilds primaryUrl and githubRepo from owner/name despite a .git suffix', () => {
    const kiosk = result.items.find((i) => i.name === 'Immich Kiosk');
    expect(kiosk).toBeDefined();
    expect(kiosk!.primaryUrl).toBe('https://github.com/damongolding/immich-kiosk');
    expect(kiosk!.githubRepo).toBe('damongolding/immich-kiosk');
  });

  it('emits one item per category when the same repo appears twice', () => {
    const frames = result.items.filter((i) => i.githubRepo === 'immichFrame/ImmichFrame');
    expect(frames).toHaveLength(2);
    expect(frames.map((i) => i.categoryIndex)).toEqual([0, 1]);
  });

  it('strips HTML markup from the item name and description', () => {
    const bold = result.items.find((i) => i.githubRepo === 'acme/bold-app');
    expect(bold).toBeDefined();
    expect(bold!.name).toBe('Bold App');
    expect(bold!.description).toBe('A alert(1)markup-carrying description.');
    for (const item of result.items) {
      expect(item.name).not.toContain('<');
      expect(item.description ?? '').not.toContain('<');
    }
  });

  it('returns an empty result rather than throwing on malformed JSON', () => {
    const empty = parser.parse('[{"name": "Client apps", ');
    expect(empty.categories).toEqual([]);
    expect(empty.items).toEqual([]);
  });

  it('returns an empty result rather than throwing on well-formed JSON that is not an array', () => {
    const empty = parser.parse('{"categories": [{"name": "Client apps"}]}');
    expect(empty.categories).toEqual([]);
    expect(empty.items).toEqual([]);
  });
});
