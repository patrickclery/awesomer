/**
 * D-13: the nightly mirror publishes the directory the same run generated.
 *
 * Drives the real runDailyPipeline(), deployStaticSite() and commitReadmeToMain()
 * with real git against a bare fixture origin. Only the generator and the earlier
 * pipeline steps are stubbed.
 *
 * Jest gives test code a copy of process.env, and child_process reads the real one,
 * so a git config set from a test never reaches the service's execSync calls. The
 * execSync wrapper below passes the test's environment explicitly, which keeps the
 * user's global core.hooksPath and identity out of the fixture. It also refuses any
 * command that runs outside the fixture, so nothing can reach the real origin.
 */

import { randomUUID } from 'crypto';
import { chmodSync, existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, symlinkSync, writeFileSync } from 'fs';
import { tmpdir } from 'os';
import { dirname, join } from 'path';
import { jest } from '@jest/globals';
import type { ExecSyncOptions } from 'child_process';

const realChildProcess = jest.requireActual<typeof import('child_process')>('child_process');

let fixtureRoot = '';

function guardedExecSync(command: string, options: ExecSyncOptions = {}): Buffer {
  const cwd = String(options.cwd ?? '');
  // rsync runs with no cwd, so its paths are what must sit inside the fixture.
  const inFixture = fixtureRoot && (cwd ? cwd.startsWith(`${fixtureRoot}/`) : command.includes(`${fixtureRoot}/`));
  if (!inFixture) {
    throw new Error(`Refusing to run outside the fixture: ${command} (cwd: ${cwd})`);
  }
  return realChildProcess.execSync(command, { ...options, env: process.env, stdio: 'pipe' }) as Buffer;
}

jest.unstable_mockModule('child_process', () => ({
  ...realChildProcess,
  default: { ...realChildProcess, execSync: guardedExecSync },
  execSync: guardedExecSync,
}));

const { SyncService } = await import('../sync.service.js');
type SyncServiceInstance = InstanceType<typeof SyncService>;

jest.setTimeout(60_000);

const API_ROOT = process.cwd();

const SEED_FILES = ['README.md', 'docs/hero.png', 'l/claude.md', 'r/keep~me.md', 'r/gone~page.md'];
const ENV_SENTINEL = 'ENV_SENTINEL_MUST_NOT_PUBLISH';
const LIVE = 'https://patrickclery.com/awesomer';

interface Fixture {
  origin: string;
  clone: string;
  deployDir: string;
  worktreeDir: string;
  service: SyncServiceInstance;
  warn: jest.Mock;
  /** Pages the generator stub writes, by path relative to the output directory. */
  pages: Map<string, string>;
}

function write(path: string, content: string): void {
  mkdirSync(dirname(path), { recursive: true });
  writeFileSync(path, content);
}

function git(cwd: string, ...args: string[]): string {
  return realChildProcess
    .execFileSync('git', args, { cwd, env: process.env, stdio: 'pipe', maxBuffer: 64 * 1024 * 1024 })
    .toString()
    .trim();
}

/** Isolate git from the user's config. Returns a function that restores the environment. */
function isolateGit(root: string): () => void {
  const saved = ['GIT_CONFIG_GLOBAL', 'GIT_CONFIG_NOSYSTEM', 'GIT_CONFIG'].map(
    (name) => [name, process.env[name]] as const,
  );
  const config = join(root, 'gitconfig');
  writeFileSync(config, '[user]\n\tname = Fixture\n\temail = fixture@example.invalid\n[init]\n\tdefaultBranch = main\n');
  process.env.GIT_CONFIG_GLOBAL = config;
  process.env.GIT_CONFIG_NOSYSTEM = '1';
  delete process.env.GIT_CONFIG;
  return () => {
    for (const [name, value] of saved) {
      if (value === undefined) delete process.env[name];
      else process.env[name] = value;
    }
  };
}

function buildFixture(root: string): Fixture {
  const origin = join(root, 'origin.git');
  const clone = join(root, 'clone');
  git(root, 'init', '--bare', origin);
  git(root, 'clone', origin, clone);

  for (const file of SEED_FILES) write(join(clone, file), `seed ${file}\n`);
  git(clone, 'add', '-A');
  git(clone, 'commit', '-m', 'seed');
  git(clone, 'push', 'origin', 'HEAD:main');

  // Left untracked: a secret, the stale staging tree, and built output.
  write(join(clone, '.env'), `SECRET=${ENV_SENTINEL}\n`);
  write(join(clone, 'static/awesomer/README.md'), 'stale decoy\n');
  write(join(clone, 'static/awesomer/l/claude.md'), 'stale decoy\n');
  write(join(clone, 'static/awesomer/r/decoy~stale.md'), 'stale decoy\n');
  write(join(clone, 'web/out/index.html'), '<html></html>\n');
  write(join(clone, 'web/out/r/Owner~Repo/index.html'), '<html></html>\n');
  write(join(clone, 'web/out/r/foo~bar.md/index.html'), '<html></html>\n');
  write(join(clone, 'web/out/l/claude/index.html'), '<html></html>\n');
  mkdirSync(join(clone, 'api'), { recursive: true });

  jest.spyOn(process, 'cwd').mockReturnValue(join(clone, 'api'));

  const markdownStub = {
    generateAll: async (dir: string) => {
      for (const [page, content] of fixture.pages) write(join(dir, page), content);
      return [...fixture.pages.keys()];
    },
  };
  const prismaStub = { awesomeList: { findMany: async () => [] } };
  const service = new SyncService(prismaStub as never, {} as never, {} as never, {} as never, markdownStub as never);

  const warn = jest.fn();
  Object.assign(service, { logger: { log: jest.fn(), warn, error: jest.fn() } });

  const fixture: Fixture = {
    origin,
    clone,
    deployDir: join(root, 'deploy'),
    worktreeDir: join(root, 'mirror-worktree'),
    service,
    warn,
    pages: new Map(),
  };
  return fixture;
}

/** Wire the real pipeline to the fixture directories, keeping its own markdownDir argument. */
function wirePipeline(fx: Fixture): void {
  const service = fx.service;
  const realDeploy = service.deployStaticSite.bind(service);
  const realMirror = service.commitReadmeToMain.bind(service);
  jest.spyOn(service, 'takeStarSnapshots').mockResolvedValue(undefined as never);
  jest.spyOn(service, 'computeTrending').mockResolvedValue(undefined as never);
  jest.spyOn(service, 'rebuildStaticSite').mockResolvedValue(undefined as never);
  jest.spyOn(service, 'deployStaticSite').mockImplementation(() => realDeploy(fx.deployDir));
  jest
    .spyOn(service, 'commitReadmeToMain')
    .mockImplementation((markdownDir: string) => realMirror(markdownDir, fx.worktreeDir));
}

function generatorPages(token: string): Map<string, string> {
  return new Map([
    ['README.md', `# Home ${token}\n[Claude](l/claude.md) [Repo](r/owner~repo.md)\n`],
    ['l/claude.md', `# Claude ${token}\n[Home](../README.md) [Repo](../r/owner~repo.md)\n${LIVE}/l/claude/\n`],
    ['r/owner~repo.md', `# Owner/Repo ${token}\n[Claude](../l/claude.md) [Live](${LIVE}/r/Owner~Repo/)\n`],
    ['r/keep~me.md', `# Keep ${token}\n`],
  ]);
}

function mainTree(fx: Fixture): string[] {
  return git(fx.origin, 'ls-tree', '-r', '--name-only', 'main').split('\n').sort();
}

describe('D-13: the daily pipeline mirrors the directory it just generated', () => {
  let root: string;
  let restoreGit: () => void;
  let fx: Fixture;

  beforeEach(() => {
    root = mkdtempSync(join(tmpdir(), 'markdown-mirror-'));
    fixtureRoot = root;
    restoreGit = isolateGit(root);
    fx = buildFixture(root);
    // The fixture must never talk to anything but its own bare origin.
    expect(git(fx.clone, 'remote', 'get-url', 'origin')).toBe(fx.origin);
  });

  afterEach(() => {
    jest.restoreAllMocks();
    restoreGit();
    fixtureRoot = '';
    rmSync(root, { recursive: true, force: true });
  });

  describe('a full runDailyPipeline() run', () => {
    let token: string;
    let seedSha: string;
    let cloneStatus: string;
    let cloneHead: string;
    let cloneReadme: string;

    beforeEach(async () => {
      token = `run-${randomUUID()}`;
      fx.pages = generatorPages(token);
      seedSha = git(fx.origin, 'rev-parse', 'main');
      cloneStatus = git(fx.clone, 'status', '--short');
      cloneHead = git(fx.clone, 'rev-parse', 'HEAD');
      cloneReadme = readFileSync(join(fx.clone, 'README.md'), 'utf-8');

      wirePipeline(fx);
      await fx.service.runDailyPipeline();
    });

    it('publishes the same per-run token to origin main and origin gh-pages', () => {
      for (const page of ['README.md', 'l/claude.md', 'r/owner~repo.md', 'r/keep~me.md']) {
        expect(git(fx.origin, 'show', `main:${page}`)).toContain(token);
        expect(git(fx.origin, 'rev-parse', `main:${page}`)).toBe(git(fx.origin, 'rev-parse', `gh-pages:${page}`));
      }
    });

    it('leaves main with exactly the generated pages and the untouched seed path', () => {
      expect(mainTree(fx)).toEqual(['README.md', 'docs/hero.png', 'l/claude.md', 'r/keep~me.md', 'r/owner~repo.md']);
    });

    it('keeps the secret, the staging decoy and all built output off main', () => {
      const tree = mainTree(fx);
      expect(tree).not.toContain('r/gone~page.md');
      expect(tree).not.toContain('r/decoy~stale.md');
      expect(tree).not.toContain('.env');
      expect(tree.filter((path) => path.endsWith('index.html'))).toEqual([]);
      expect(tree.filter((path) => path.startsWith('r/foo~bar.md'))).toEqual([]);
      for (const path of tree) expect(git(fx.origin, 'show', `main:${path}`)).not.toContain(ENV_SENTINEL);
    });

    it('adds one commit on top of main instead of rewriting it', () => {
      expect(git(fx.origin, 'rev-parse', 'main~1')).toBe(seedSha);
    });

    it('leaves the working tree of the clone unchanged', () => {
      expect(git(fx.clone, 'status', '--short')).toBe(cloneStatus);
      expect(git(fx.clone, 'rev-parse', 'HEAD')).toBe(cloneHead);
      expect(readFileSync(join(fx.clone, 'README.md'), 'utf-8')).toBe(cloneReadme);
      expect(git(fx.clone, 'worktree', 'list').split('\n')).toHaveLength(1);
      expect(existsSync(fx.worktreeDir)).toBe(false);
    });
  });

  describe('commitReadmeToMain() safety rules', () => {
    let generatedDir: string;

    /** Replace the generated directory with a README, l/ pages and r/ pages. */
    function generate(lPages: string[], rPages: string[], options: { readme?: boolean } = {}): void {
      rmSync(generatedDir, { recursive: true, force: true });
      mkdirSync(join(generatedDir, 'l'), { recursive: true });
      mkdirSync(join(generatedDir, 'r'), { recursive: true });
      if (options.readme !== false) write(join(generatedDir, 'README.md'), `# Home ${randomUUID()}\n`);
      for (const page of lPages) write(join(generatedDir, 'l', page), `# ${page}\n`);
      for (const page of rPages) write(join(generatedDir, 'r', page), `# ${page}\n`);
    }

    function pushToMain(change: () => void): void {
      change();
      git(fx.clone, 'add', '-A', 'README.md', 'l', 'r', 'docs');
      git(fx.clone, 'commit', '-m', 'seed change');
      git(fx.clone, 'push', 'origin', 'HEAD:main');
    }

    function mainSha(): string {
      return git(fx.origin, 'rev-parse', 'main');
    }

    function mirror(): Promise<void> {
      return fx.service.commitReadmeToMain(generatedDir, fx.worktreeDir);
    }

    beforeEach(() => {
      generatedDir = join(root, 'generated');
      // Four pages in r/ on main, so exactly half is two.
      pushToMain(() => {
        write(join(fx.clone, 'r/third~page.md'), 'seed\n');
        write(join(fx.clone, 'r/fourth~page.md'), 'seed\n');
      });
    });

    it('commits when exactly half of the pages in a tree are retained', async () => {
      const before = mainSha();
      generate(['claude.md'], ['keep~me.md', 'third~page.md']);

      await mirror();

      expect(git(fx.origin, 'rev-parse', 'main~1')).toBe(before);
      expect(mainTree(fx)).toEqual(['README.md', 'docs/hero.png', 'l/claude.md', 'r/keep~me.md', 'r/third~page.md']);
    });

    it('stops when one fewer than half is retained, and names the tree and both counts', async () => {
      const before = mainSha();
      generate(['claude.md'], ['keep~me.md']);

      await mirror();

      expect(mainSha()).toBe(before);
      expect(fx.warn).toHaveBeenCalledTimes(1);
      expect(fx.warn.mock.calls[0][0]).toMatch(/r\/ generated 1 pages, main has 4/);
      expect(git(fx.clone, 'worktree', 'list').split('\n')).toHaveLength(1);
    });

    it.each([
      ['no pages in r/', ['claude.md'], [], {}],
      ['no pages in l/', [], ['keep~me.md', 'third~page.md'], {}],
      ['no README.md', ['claude.md'], ['keep~me.md', 'third~page.md'], { readme: false }],
    ])('stops when the generated directory has %s', async (_label, lPages, rPages, options) => {
      const before = mainSha();
      generate(lPages as string[], rPages as string[], options as { readme?: boolean });

      await mirror();

      expect(mainSha()).toBe(before);
      expect(fx.warn).toHaveBeenCalledTimes(1);
      expect(fx.warn.mock.calls[0][0]).toMatch(/Markdown mirror skipped/);
    });

    it('proceeds on a first mirror, with no trees on main yet', async () => {
      pushToMain(() => {
        rmSync(join(fx.clone, 'l'), { recursive: true });
        rmSync(join(fx.clone, 'r'), { recursive: true });
      });
      generate(['claude.md'], ['owner~repo.md']);

      await mirror();

      expect(mainTree(fx)).toEqual(['README.md', 'docs/hero.png', 'l/claude.md', 'r/owner~repo.md']);
      expect(fx.warn).not.toHaveBeenCalled();
    });

    it('creates no new commit when re-run with identical content', async () => {
      generate(['claude.md'], ['keep~me.md', 'third~page.md']);
      await mirror();
      const after = mainSha();

      await mirror();

      expect(mainSha()).toBe(after);
      expect(fx.warn).not.toHaveBeenCalled();
    });

    it('does not publish a symlink, even one named like a page', async () => {
      generate(['claude.md'], ['keep~me.md', 'third~page.md']);
      symlinkSync(join(fx.clone, '.env'), join(generatedDir, 'r', 'leak~env.md'));

      await mirror();

      expect(mainTree(fx)).not.toContain('r/leak~env.md');
      expect(mainTree(fx)).toContain('r/keep~me.md');
    });

    it('survives a rejected push and retries from a fresh fetch on the next run', async () => {
      const hook = join(fx.origin, 'hooks', 'pre-receive');
      write(hook, '#!/bin/sh\nexit 1\n');
      chmodSync(hook, 0o755);
      const before = mainSha();
      const cloneHead = git(fx.clone, 'rev-parse', 'HEAD');
      generate(['claude.md'], ['keep~me.md', 'third~page.md']);

      await expect(mirror()).resolves.toBeUndefined();

      expect(mainSha()).toBe(before);
      expect(git(fx.clone, 'rev-parse', 'HEAD')).toBe(cloneHead);
      expect(git(fx.clone, 'worktree', 'list').split('\n')).toHaveLength(1);
      expect(fx.warn.mock.calls[0][0]).toMatch(/non-fatal/);

      rmSync(hook);
      await mirror();

      expect(git(fx.origin, 'rev-parse', 'main~1')).toBe(before);
    });

    it('recovers from an interrupted run that left its worktree registered', async () => {
      git(fx.clone, 'worktree', 'add', '--detach', fx.worktreeDir, 'origin/main');
      write(join(fx.worktreeDir, 'r/half-written.md'), 'interrupted\n');
      const before = mainSha();
      generate(['claude.md'], ['keep~me.md', 'third~page.md']);

      await mirror();

      expect(git(fx.origin, 'rev-parse', 'main~1')).toBe(before);
      expect(mainTree(fx)).not.toContain('r/half-written.md');
      expect(git(fx.clone, 'worktree', 'list').split('\n')).toHaveLength(1);
    });
  });

  describe('verify-markdown-mirror.mjs', () => {
    function runChecker(): { status: number | null; report: Record<string, number> } {
      git(fx.clone, 'fetch', 'origin', 'main', 'gh-pages');
      const result = realChildProcess.spawnSync(
        process.execPath,
        [join(API_ROOT, 'scripts/verify-markdown-mirror.mjs')],
        { cwd: fx.clone, env: process.env, encoding: 'utf-8' },
      );
      return { status: result.status, report: JSON.parse(result.stdout) as Record<string, number> };
    }

    beforeEach(() => {
      fx.pages = generatorPages(`run-${randomUUID()}`);
      wirePipeline(fx);
    });

    it('exits 0 with no violations after a pipeline run', async () => {
      const refsBefore = git(fx.clone, 'for-each-ref');
      await fx.service.runDailyPipeline();
      git(fx.clone, 'fetch', 'origin', 'main', 'gh-pages');
      const refsAfterFetch = git(fx.clone, 'for-each-ref');
      expect(refsAfterFetch).not.toBe(refsBefore);

      const { status, report } = runChecker();

      expect(report.violations).toBe(0);
      expect(status).toBe(0);
      // The checker itself moved no ref and left nothing in the clone.
      expect(git(fx.clone, 'for-each-ref')).toBe(refsAfterFetch);
      expect(git(fx.clone, 'worktree', 'list').split('\n')).toHaveLength(1);
    });

    it('exits 1 when main was left unsynced', async () => {
      await fx.service.deployStaticSite(fx.deployDir);

      const { status, report } = runChecker();

      expect(status).toBe(1);
      expect(report.violations).toBeGreaterThan(0);
      expect(report.r_stale_on_main).toBe(1);
      expect(report.r_missing_on_main).toBe(1);
      expect(report.r_content_differs).toBe(1);
      expect(report.l_content_differs).toBe(1);
      expect(report.readme_differs).toBe(1);
    });

    it('reports dead links and non-markdown paths on an otherwise exact mirror', async () => {
      fx.pages.set('r/owner~repo.md', `[Gone](../l/missing.md) [Live](${LIVE}/r/owner~repo/) [Up](${LIVE}/l/claude/)\n`);
      await fx.service.runDailyPipeline();
      git(fx.clone, 'fetch', 'origin', 'main');
      git(fx.clone, 'switch', '--detach', 'origin/main');
      write(join(fx.clone, 'r/notes.txt'), 'not a page\n');
      git(fx.clone, 'add', 'r/notes.txt');
      git(fx.clone, 'commit', '-m', 'stray file');
      git(fx.clone, 'push', 'origin', 'HEAD:main');

      const { status, report } = runChecker();

      expect(status).toBe(1);
      expect(report).toMatchObject({
        dead_relative_links: 1,
        dead_live_links: 1,
        pages_with_dead_live_links: 1,
        non_md_on_main: 1,
        r_stale_on_main: 0,
        r_missing_on_main: 0,
        r_content_differs: 0,
        readme_differs: 0,
        violations: 3,
      });
    });
  });
});
