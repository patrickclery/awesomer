/**
 * What the nightly run publishes: a gh-pages tree without Next.js payload files,
 * and a commit to main that changes README.md and nothing else.
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
import {
  chmodSync,
  existsSync,
  mkdirSync,
  mkdtempSync,
  readdirSync,
  readFileSync,
  rmSync,
  symlinkSync,
  writeFileSync,
} from 'fs';
import { tmpdir } from 'os';
import { basename, dirname, join } from 'path';
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
const { readmeForMain } = await import('../markdown.service.js');
type SyncServiceInstance = InstanceType<typeof SyncService>;

jest.setTimeout(60_000);

const API_ROOT = process.cwd();

const SEED_FILES = ['README.md', 'docs/hero.png', 'l/claude.md', 'r/gone~page.md', 'r/keep~me.md'];
const ENV_SENTINEL = 'ENV_SENTINEL_MUST_NOT_PUBLISH';
const LIVE = 'https://patrickclery.com/awesomer';
const GH_PAGES_BLOB = 'https://github.com/patrickclery/awesomer/blob/gh-pages';
const RSC_PAYLOAD = /^(__next\..*\.txt|index\.txt)$/;
// The directory name ends in a byte-order mark, which git quotes unless core.quotePath is off.
const BOM_DIR = 'r/karpathy~neuraltalk﻿';

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
  write(join(clone, `web/out/${BOM_DIR}/index.html`), '<html></html>\n');
  write(join(clone, 'web/out/r/stray.html'), '<html></html>\n');
  write(join(clone, 'web/out/_next/static/chunks/a.js'), 'built\n');
  // Real text files that must publish.
  write(join(clone, 'web/out/l/stray.txt'), 'built\n');
  write(join(clone, 'web/out/robots.txt'), 'built\n');
  write(join(clone, 'web/out/llms.txt'), 'built\n');
  // Next.js payload files that must not.
  write(join(clone, 'web/out/index.txt'), 'payload\n');
  write(join(clone, 'web/out/__next._full.txt'), 'payload\n');
  write(join(clone, 'web/out/l/claude/index.txt'), 'payload\n');
  write(join(clone, 'web/out/l/claude/__next.l.$d$slug.__PAGE__.txt'), 'payload\n');
  write(join(clone, 'web/out/r/Owner~Repo/__next._tree.txt'), 'payload\n');
  write(join(clone, `web/out/${BOM_DIR}/__next._full.txt`), 'payload\n');
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
    worktreeDir: join(root, 'readme-worktree'),
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
  const realCommit = service.commitReadmeToMain.bind(service);
  jest.spyOn(service, 'takeStarSnapshots').mockResolvedValue(undefined as never);
  jest.spyOn(service, 'computeTrending').mockResolvedValue(undefined as never);
  jest.spyOn(service, 'rebuildStaticSite').mockResolvedValue(undefined as never);
  jest.spyOn(service, 'deployStaticSite').mockImplementation(() => realDeploy(fx.deployDir));
  jest
    .spyOn(service, 'commitReadmeToMain')
    .mockImplementation((markdownDir: string) => realCommit(markdownDir, fx.worktreeDir));
}

function generatorPages(token: string): Map<string, string> {
  return new Map([
    ['README.md', `# Home ${token}\n![Hero](docs/hero.png)\n[Claude](l/claude.md) [Repo](r/owner~repo.md)\n`],
    ['l/claude.md', `# Claude ${token}\n[Home](../README.md) [Repo](../r/owner~repo.md)\n${LIVE}/l/claude/\n`],
    ['r/owner~repo.md', `# Owner/Repo ${token}\n[Claude](../l/claude.md) [Live](${LIVE}/r/Owner~Repo/)\n`],
    ['r/keep~me.md', `# Keep ${token}\n`],
  ]);
}

function mainTree(fx: Fixture): string[] {
  return git(fx.origin, 'ls-tree', '-r', '--name-only', 'main').split('\n').sort();
}

/** The gh-pages tree with real file names: quotePath off, so a non-ASCII path is not quoted. */
function pagesTree(fx: Fixture): string[] {
  return git(fx.origin, '-c', 'core.quotePath=false', 'ls-tree', '-r', '--name-only', 'gh-pages').split('\n');
}

describe('readmeForMain()', () => {
  it('points list and repo page links at the gh-pages blob URLs', () => {
    expect(readmeForMain('[A](l/a.md) and [B](r/owner~b.md)\n')).toBe(
      `[A](${GH_PAGES_BLOB}/l/a.md) and [B](${GH_PAGES_BLOB}/r/owner~b.md)\n`,
    );
  });

  it('rewrites a page name that holds a byte-order mark', () => {
    expect(readmeForMain('[N](r/karpathy~neuraltalk﻿.md)')).toBe(
      `[N](${GH_PAGES_BLOB}/r/karpathy~neuraltalk﻿.md)`,
    );
  });

  it('leaves everything that is not a list or repo page link alone', () => {
    const untouched = [
      '<img src="docs/hero.png" />',
      '![Hero](docs/hero.png)',
      '[Docs](docs/l/a.md)',
      '[Up](../l/a.md)',
      '[Text](l/a.txt)',
      `[Live](${LIVE}/l/a/)`,
      `[Done](${GH_PAGES_BLOB}/l/a.md)`,
      'plain text about l/a.md and r/b.md',
    ].join('\n');

    expect(readmeForMain(untouched)).toBe(untouched);
  });
});

describe('the daily pipeline publishes a stripped gh-pages tree and a README-only commit to main', () => {
  let root: string;
  let restoreGit: () => void;
  let fx: Fixture;

  beforeEach(() => {
    root = mkdtempSync(join(tmpdir(), 'sync-publish-'));
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
      // A payload left in the staging directory by an earlier run.
      write(join(fx.deployDir, '__next._full.txt'), 'stale payload\n');

      wirePipeline(fx);
      await fx.service.runDailyPipeline();
    });

    describe('gh-pages', () => {
      it('holds no Next.js payload file at any depth, including under a non-ASCII directory', () => {
        const tree = pagesTree(fx);

        expect(tree.filter((path) => RSC_PAYLOAD.test(basename(path)))).toEqual([]);
        expect(tree).toContain(`${BOM_DIR}/index.html`);
      });

      it('keeps real text files, every page, and the framework assets', () => {
        const tree = pagesTree(fx);

        for (const path of ['robots.txt', 'llms.txt', 'l/stray.txt', '_next/static/chunks/a.js']) {
          expect(tree).toContain(path);
        }
        expect(tree.filter((path) => path.endsWith('index.html')).sort()).toEqual(
          [
            'index.html',
            'l/claude/index.html',
            'r/Owner~Repo/index.html',
            'r/foo~bar.md/index.html',
            `${BOM_DIR}/index.html`,
          ].sort(),
        );
      });

      it('keeps the generated list and repo pages', () => {
        const tree = pagesTree(fx);

        for (const page of ['l/claude.md', 'r/owner~repo.md', 'r/keep~me.md']) {
          expect(tree).toContain(page);
          expect(git(fx.origin, 'show', `gh-pages:${page}`)).toContain(token);
        }
      });

      it('does not carry over a stale payload from the staging directory', () => {
        expect(existsSync(join(fx.deployDir, '__next._full.txt'))).toBe(false);
        expect(pagesTree(fx)).not.toContain('__next._full.txt');
      });

      it('gets the generated README byte for byte, with relative links', () => {
        const published = realChildProcess
          .execFileSync('git', ['show', 'gh-pages:README.md'], { cwd: fx.origin, env: process.env, stdio: 'pipe' })
          .toString();

        expect(published).toBe(fx.pages.get('README.md'));
      });
    });

    describe('main', () => {
      it('gets a commit that changes README.md and nothing else', () => {
        expect(git(fx.origin, 'diff', '--name-only', 'main~1', 'main')).toBe('README.md');
      });

      it('adds one commit on top of main instead of rewriting it', () => {
        expect(git(fx.origin, 'rev-parse', 'main~1')).toBe(seedSha);
      });

      it('leaves the seeded pages on their seed blobs', () => {
        for (const page of ['l/claude.md', 'r/keep~me.md', 'r/gone~page.md']) {
          expect(git(fx.origin, 'rev-parse', `main:${page}`)).toBe(git(fx.origin, 'rev-parse', `${seedSha}:${page}`));
        }
      });

      it('receives no generated page, secret, staging decoy or built output', () => {
        const tree = mainTree(fx);

        expect(tree).toEqual([...SEED_FILES].sort());
        for (const path of tree) expect(git(fx.origin, 'show', `main:${path}`)).not.toContain(ENV_SENTINEL);
      });

      it('carries this run in a README whose page links target gh-pages', () => {
        const readme = git(fx.origin, 'show', 'main:README.md');

        expect(readme).toContain(token);
        expect(readme).toContain(`[Claude](${GH_PAGES_BLOB}/l/claude.md)`);
        expect(readme).toContain(`[Repo](${GH_PAGES_BLOB}/r/owner~repo.md)`);
        expect(readme).not.toMatch(/\]\((?:l|r)\//);
        expect(readme).toContain('![Hero](docs/hero.png)');
      });
    });

    it('leaves the working tree of the clone unchanged', () => {
      expect(git(fx.clone, 'status', '--short')).toBe(cloneStatus);
      expect(git(fx.clone, 'rev-parse', 'HEAD')).toBe(cloneHead);
      expect(readFileSync(join(fx.clone, 'README.md'), 'utf-8')).toBe(cloneReadme);
      expect(git(fx.clone, 'worktree', 'list').split('\n')).toHaveLength(1);
      expect(existsSync(fx.worktreeDir)).toBe(false);
    });
  });

  it('no file in web/public collides with the payload names', () => {
    const publicDir = join(API_ROOT, '..', 'web', 'public');
    const names = (readdirSync(publicDir, { recursive: true }) as string[]).map((path) => basename(path));

    expect(names.length).toBeGreaterThan(0);
    expect(names.filter((name) => RSC_PAYLOAD.test(name))).toEqual([]);
  });

  describe('commitReadmeToMain() safety rules', () => {
    let generatedDir: string;

    function generateReadme(): void {
      write(join(generatedDir, 'README.md'), `# Home ${randomUUID()}\n[Claude](l/claude.md)\n`);
    }

    function mainSha(): string {
      return git(fx.origin, 'rev-parse', 'main');
    }

    function commitReadme(): Promise<void> {
      return fx.service.commitReadmeToMain(generatedDir, fx.worktreeDir);
    }

    beforeEach(() => {
      generatedDir = join(root, 'generated');
      mkdirSync(generatedDir, { recursive: true });
    });

    it('commits the README even when the directory holds no pages', async () => {
      const before = mainSha();
      generateReadme();

      await commitReadme();

      expect(git(fx.origin, 'rev-parse', 'main~1')).toBe(before);
      expect(mainTree(fx)).toEqual([...SEED_FILES].sort());
      expect(fx.warn).not.toHaveBeenCalled();
    });

    it('makes no commit and warns when the directory has no README.md', async () => {
      const before = mainSha();
      write(join(generatedDir, 'l/claude.md'), '# Page\n');

      await commitReadme();

      expect(mainSha()).toBe(before);
      expect(fx.warn).toHaveBeenCalledTimes(1);
      expect(fx.warn.mock.calls[0][0]).toMatch(/no README\.md/);
      expect(git(fx.clone, 'worktree', 'list').split('\n')).toHaveLength(1);
    });

    it('treats a symlinked README.md as absent', async () => {
      const before = mainSha();
      symlinkSync(join(fx.clone, '.env'), join(generatedDir, 'README.md'));

      await commitReadme();

      expect(mainSha()).toBe(before);
      expect(fx.warn).toHaveBeenCalledTimes(1);
      expect(fx.warn.mock.calls[0][0]).toMatch(/no README\.md/);
    });

    it('creates no new commit when re-run with identical content', async () => {
      generateReadme();
      await commitReadme();
      const after = mainSha();

      await commitReadme();

      expect(mainSha()).toBe(after);
      expect(fx.warn).not.toHaveBeenCalled();
    });

    it('survives a rejected push and retries from a fresh fetch on the next run', async () => {
      const hook = join(fx.origin, 'hooks', 'pre-receive');
      write(hook, '#!/bin/sh\nexit 1\n');
      chmodSync(hook, 0o755);
      const before = mainSha();
      const cloneHead = git(fx.clone, 'rev-parse', 'HEAD');
      generateReadme();

      await expect(commitReadme()).resolves.toBeUndefined();

      expect(mainSha()).toBe(before);
      expect(git(fx.clone, 'rev-parse', 'HEAD')).toBe(cloneHead);
      expect(git(fx.clone, 'worktree', 'list').split('\n')).toHaveLength(1);
      expect(fx.warn.mock.calls[0][0]).toMatch(/non-fatal/);

      rmSync(hook);
      await commitReadme();

      expect(git(fx.origin, 'rev-parse', 'main~1')).toBe(before);
    });

    it('recovers from an interrupted run that left its worktree registered', async () => {
      git(fx.clone, 'worktree', 'add', '--detach', fx.worktreeDir, 'origin/main');
      write(join(fx.worktreeDir, 'r/half-written.md'), 'interrupted\n');
      const before = mainSha();
      generateReadme();

      await commitReadme();

      expect(git(fx.origin, 'rev-parse', 'main~1')).toBe(before);
      expect(mainTree(fx)).not.toContain('r/half-written.md');
      expect(git(fx.clone, 'worktree', 'list').split('\n')).toHaveLength(1);
    });
  });
});
