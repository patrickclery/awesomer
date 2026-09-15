import { DefaultReadmeParser } from '../default-readme-parser.js';

const MOCK_README = `# Awesome Test List

Some intro text.

## Contents

- [Category A](#category-a)
- [Category B](#category-b)

## Category A

- [RepoOne](https://github.com/owner1/repo-one) - A great tool for testing
- \u{1F499} [RepoTwo](https://github.com/owner2/repo-two) - Emoji prefix item
- [NonGitHub](https://example.com/some-tool) - This should be skipped
- [BlobRef](https://github.com/owner3/repo-three/blob/main/README.md) - Skip blob URL
- [TreeRef](https://github.com/owner4/repo-four/tree/main/docs) - Skip tree URL
- [NoDesc](https://github.com/owner5/repo-five)

## Contributing

Please read CONTRIBUTING.md

## License

MIT

### Category B

- [RepoSix](https://github.com/owner6/repo-six) - Another tool
- [![badge][img]](https://github.com/owner7/badge-repo) [BadgeName](https://homepage.com) - Badge item
- <img src="https://img.shields.io/github/stars/owner8/img-repo?style=social"/> [ImgName](https://github.com/owner8/img-repo) - Img prefix item
- ![stars](https://img.shields.io/github/stars/owner9/md-badge-repo?style=flat) [MdBadgeName](https://github.com/owner9/md-badge-repo) - Markdown badge item
`;

describe('DefaultReadmeParser', () => {
  const parser = new DefaultReadmeParser();

  it('parses a standard item with name, URL, and description', () => {
    const result = parser.parse(MOCK_README);
    const repoOne = result.items.find((i) => i.name === 'RepoOne');
    expect(repoOne).toBeDefined();
    expect(repoOne!.primaryUrl).toBe('https://github.com/owner1/repo-one');
    expect(repoOne!.githubRepo).toBe('owner1/repo-one');
    expect(repoOne!.description).toBe('A great tool for testing');
  });

  it('parses an item with emoji prefix', () => {
    const result = parser.parse(MOCK_README);
    const repoTwo = result.items.find((i) => i.name === 'RepoTwo');
    expect(repoTwo).toBeDefined();
    expect(repoTwo!.primaryUrl).toBe('https://github.com/owner2/repo-two');
    expect(repoTwo!.githubRepo).toBe('owner2/repo-two');
    expect(repoTwo!.description).toBe('Emoji prefix item');
  });

  it('skips non-GitHub URLs', () => {
    const result = parser.parse(MOCK_README);
    const nonGitHub = result.items.find((i) => i.name === 'NonGitHub');
    expect(nonGitHub).toBeUndefined();
  });

  it('skips blob/tree URLs via SKIP_URL', () => {
    const result = parser.parse(MOCK_README);
    const blobRef = result.items.find((i) => i.name === 'BlobRef');
    const treeRef = result.items.find((i) => i.name === 'TreeRef');
    expect(blobRef).toBeUndefined();
    expect(treeRef).toBeUndefined();
  });

  it('skips Contents, Contributing, and License headers', () => {
    const result = parser.parse(MOCK_README);
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).not.toContain('Contents');
    expect(categoryNames).not.toContain('Contributing');
    expect(categoryNames).not.toContain('License');
  });

  it('creates categories from non-skip headers', () => {
    const result = parser.parse(MOCK_README);
    const categoryNames = result.categories.map((c) => c.name);
    expect(categoryNames).toContain('Category A');
    expect(categoryNames).toContain('Category B');
  });

  it('assigns sequential order to categories', () => {
    const result = parser.parse(MOCK_README);
    const catA = result.categories.find((c) => c.name === 'Category A');
    const catB = result.categories.find((c) => c.name === 'Category B');
    expect(catA).toBeDefined();
    expect(catB).toBeDefined();
    // The title header creates category index 0
    expect(catA!.order).toBeLessThan(catB!.order);
  });

  it('assigns correct categoryIndex to items', () => {
    const result = parser.parse(MOCK_README);
    const catAIndex = result.categories.findIndex((c) => c.name === 'Category A');
    const catBIndex = result.categories.findIndex((c) => c.name === 'Category B');
    const repoOne = result.items.find((i) => i.name === 'RepoOne');
    const repoSix = result.items.find((i) => i.name === 'RepoSix');
    expect(repoOne!.categoryIndex).toBe(catAIndex);
    expect(repoSix!.categoryIndex).toBe(catBIndex);
  });

  it('parses badge-prefix items', () => {
    const result = parser.parse(MOCK_README);
    const badge = result.items.find((i) => i.name === 'BadgeName');
    expect(badge).toBeDefined();
    expect(badge!.primaryUrl).toBe('https://github.com/owner7/badge-repo');
    expect(badge!.githubRepo).toBe('owner7/badge-repo');
    expect(badge!.description).toBe('Badge item');
  });

  it('parses shields-image-prefix items', () => {
    const result = parser.parse(MOCK_README);
    const img = result.items.find((i) => i.name === 'ImgName');
    expect(img).toBeDefined();
    expect(img!.primaryUrl).toBe('https://github.com/owner8/img-repo');
    expect(img!.githubRepo).toBe('owner8/img-repo');
    expect(img!.description).toBe('Img prefix item');
  });

  it('parses markdown-image badge-prefix items (captures the repo, not the badge)', () => {
    const result = parser.parse(MOCK_README);
    // Regression guard: ITEM_RE's `[^[\n]*?` prefix cannot span the `[` that
    // opens the image alt-text, so it used to capture the shields.io badge URL
    // and drop the whole item when parseGithubRepo() rejected it.
    const mdBadge = result.items.find((i) => i.name === 'MdBadgeName');
    expect(mdBadge).toBeDefined();
    expect(mdBadge!.primaryUrl).toBe('https://github.com/owner9/md-badge-repo');
    expect(mdBadge!.githubRepo).toBe('owner9/md-badge-repo');
    expect(mdBadge!.description).toBe('Markdown badge item');
    expect(result.items.some((i) => i.name === 'stars')).toBe(false);
  });

  it('sets description to null when no description is present', () => {
    const result = parser.parse(MOCK_README);
    const noDesc = result.items.find((i) => i.name === 'NoDesc');
    expect(noDesc).toBeDefined();
    expect(noDesc!.description).toBeNull();
  });

  it('creates multiple categories with correct item counts', () => {
    const result = parser.parse(MOCK_README);
    const catAIndex = result.categories.findIndex((c) => c.name === 'Category A');
    const catBIndex = result.categories.findIndex((c) => c.name === 'Category B');
    const catAItems = result.items.filter((i) => i.categoryIndex === catAIndex);
    const catBItems = result.items.filter((i) => i.categoryIndex === catBIndex);
    // Category A: RepoOne, RepoTwo, NoDesc (NonGitHub, BlobRef, TreeRef skipped)
    expect(catAItems).toHaveLength(3);
    // Category B: RepoSix, BadgeName, ImgName, MdBadgeName
    expect(catBItems).toHaveLength(4);
  });
});
