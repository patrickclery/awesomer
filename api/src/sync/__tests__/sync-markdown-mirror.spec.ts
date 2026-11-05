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
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'fs';
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

const SEED_FILES = ['README.md', 'docs/hero.png', 'l/claude.md', 'r/keep~me.md', 'r/gone~page.md'];
const ENV_SENTINEL = 'ENV_SENTINEL_MUST_NOT_PUBLISH';

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
    ['README.md', `# Home ${token}\n`],
    ['l/claude.md', `# Claude ${token}\n`],
    ['r/owner~repo.md', `# Owner/Repo ${token}\n`],
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
});
