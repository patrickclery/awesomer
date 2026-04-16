import { GithubService } from '../github.service.js';

describe('Jest ESM smoke test', () => {
  it('imports ESM modules with .js extension', () => {
    const result = GithubService.parseGithubRepo('https://github.com/HumanSignal/Adala');
    expect(result).toEqual({ owner: 'HumanSignal', name: 'Adala' });
  });

  it('rejects non-root GitHub URLs', () => {
    const result = GithubService.parseGithubRepo('https://github.com/foo/bar/tree/main/docs');
    expect(result).toBeNull();
  });
});
