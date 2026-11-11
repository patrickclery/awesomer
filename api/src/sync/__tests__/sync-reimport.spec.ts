/**
 * SyncService.reimportAwesomeList(): the guarded, atomic clean re-import of one list.
 *
 * One stub object serves as both the Prisma client and the transaction client, so the
 * spec can assert which calls ran, in what order, and with which where clauses. The
 * README uses the current upstream format (numbered h2 sections, h4 categories,
 * trailing star badges).
 */

import { jest } from '@jest/globals';
import { SyncService } from '../sync.service.js';

const LIST_ID = 262;
const LIST_SLUG = 'opensource-ai';
const LIST_REPO = 'alvinreal/awesome-opensource-ai';

const README = `# Awesome Open Source AI

Awesome Open Source AI is a curated list of open-source projects for people building with AI.

## 1. Core Frameworks & Libraries

> Core libraries and frameworks used to build, train, and run AI and machine learning systems.

#### Deep Learning Frameworks

- [PyTorch](https://github.com/pytorch/pytorch) - Dynamic computation graphs, Pythonic API, dominant in research and production. The current standard for most frontier AI work. ![GitHub stars](https://img.shields.io/github/stars/pytorch/pytorch?style=social)
- [Keras](https://github.com/keras-team/keras) - Multi-backend deep learning API that runs on JAX, TensorFlow, and PyTorch with one codebase. ![GitHub stars](https://img.shields.io/github/stars/keras-team/keras?style=social)

## 14. Resources & Learning

#### Curated Resource Lists

- [Awesome Machine Learning](https://github.com/josephmisiti/awesome-machine-learning) - A curated list of machine learning frameworks, libraries and software. ![GitHub stars](https://img.shields.io/github/stars/josephmisiti/awesome-machine-learning?style=social)
`;

const HEADINGS_ONLY_README = `# Awesome Open Source AI

## 1. Core Frameworks & Libraries

#### Deep Learning Frameworks

Nothing here yet.
`;

type Fn = ReturnType<typeof jest.fn<(...args: any[]) => any>>;

interface Db {
  awesomeList: { findUnique: Fn; findFirst: Fn; findMany: Fn; update: Fn };
  category: { findMany: Fn; count: Fn; upsert: Fn; deleteMany: Fn };
  categoryItem: { count: Fn; findFirst: Fn; create: Fn; deleteMany: Fn };
  repo: { findUnique: Fn; upsert: Fn };
  $transaction: Fn;
  $executeRaw: Fn;
  tryAdvisoryLock: Fn;
  releaseLock: Fn;
}

function makeDb(storedItems = 3): Db {
  const list = {
    id: LIST_ID,
    slug: LIST_SLUG,
    githubRepo: LIST_REPO,
    parserType: 'opensource-ai',
  };
  let nextId = 1000;
  const releaseLock = jest.fn(() => Promise.resolve());
  const db: Db = {
    awesomeList: {
      findUnique: jest.fn(() => Promise.resolve(list)),
      findFirst: jest.fn(() => Promise.resolve({ githubRepo: LIST_REPO })),
      findMany: jest.fn(() =>
        Promise.resolve([
          { githubRepo: LIST_REPO },
          { githubRepo: 'josephmisiti/awesome-machine-learning' },
        ]),
      ),
      update: jest.fn(() => Promise.resolve(list)),
    },
    category: {
      findMany: jest.fn(() =>
        Promise.resolve([
          {
            name: 'Deep Learning Frameworks',
            _count: { categoryItems: storedItems },
          },
        ]),
      ),
      count: jest.fn(() => Promise.resolve(10)),
      upsert: jest.fn(() => Promise.resolve({ id: nextId++ })),
      deleteMany: jest.fn(() => Promise.resolve({ count: 1 })),
    },
    categoryItem: {
      count: jest.fn(
        (args: {
          where: { description?: unknown; OR?: unknown; stars?: unknown };
        }) =>
          Promise.resolve(
            args.where.description === null ||
              args.where.OR ||
              'stars' in args.where
              ? 0
              : storedItems,
          ),
      ),
      findFirst: jest.fn(() => Promise.resolve(null)),
      create: jest.fn(() => Promise.resolve({})),
      deleteMany: jest.fn(() => Promise.resolve({ count: storedItems })),
    },
    repo: {
      findUnique: jest.fn(() => Promise.resolve(null)),
      upsert: jest.fn(() => Promise.resolve({ id: nextId++ })),
    },
    $executeRaw: jest.fn(() => Promise.resolve(2)),
    $transaction: jest.fn(async (fn: (tx: unknown) => Promise<unknown>) =>
      fn(db),
    ),
    tryAdvisoryLock: jest.fn(() => Promise.resolve(releaseLock)),
    releaseLock,
  };
  return db;
}

function makeService(db: Db, readme: string | null = README) {
  const github = {
    fetchReadme: jest.fn(() => Promise.resolve(readme)),
    fetchFileContent: jest.fn(() => Promise.resolve(readme)),
  };
  const service = new SyncService(
    db as never,
    github as never,
    {} as never,
    {} as never,
    {} as never,
  );
  Object.assign(service, {
    logger: { log: jest.fn(), warn: jest.fn(), error: jest.fn() },
  });
  const hydrate = jest
    .spyOn(service, 'hydrateNewRepos')
    .mockResolvedValue(undefined);
  return { service, github, hydrate };
}

function expectNoWrites(db: Db) {
  expect(db.$transaction).not.toHaveBeenCalled();
  expect(db.awesomeList.update).not.toHaveBeenCalled();
  expect(db.category.deleteMany).not.toHaveBeenCalled();
  expect(db.categoryItem.deleteMany).not.toHaveBeenCalled();
  expect(db.category.upsert).not.toHaveBeenCalled();
  expect(db.categoryItem.create).not.toHaveBeenCalled();
  expect(db.repo.upsert).not.toHaveBeenCalled();
  expect(db.$executeRaw).not.toHaveBeenCalled();
}

describe('SyncService.reimportAwesomeList guards', () => {
  it('refuses a slug mismatch before any network call or write', async () => {
    const db = makeDb();
    const { service, github } = makeService(db);
    await expect(
      service.reimportAwesomeList(LIST_ID, 'not-this-list', false),
    ).rejects.toThrow(/Refusing.*slug is 'opensource-ai'/);
    expect(github.fetchReadme).not.toHaveBeenCalled();
    expect(github.fetchFileContent).not.toHaveBeenCalled();
    expectNoWrites(db);
  });

  it('refuses when the README parses to zero items', async () => {
    const db = makeDb();
    const { service } = makeService(db, HEADINGS_ONLY_README);
    await expect(
      service.reimportAwesomeList(LIST_ID, LIST_SLUG, true),
    ).rejects.toThrow(/Refusing/);
    expectNoWrites(db);
  });

  it('refuses when the parse holds fewer items than REIMPORT_MIN_RATIO of the stored count', async () => {
    const db = makeDb(100);
    const { service } = makeService(db);
    await expect(
      service.reimportAwesomeList(LIST_ID, LIST_SLUG, true),
    ).rejects.toThrow(/Refusing/);
    expectNoWrites(db);
  });

  it('refuses when the source cannot be fetched', async () => {
    const db = makeDb();
    const { service } = makeService(db, null);
    await expect(
      service.reimportAwesomeList(LIST_ID, LIST_SLUG, true),
    ).rejects.toThrow(/not found/);
    expectNoWrites(db);
  });
});

describe('SyncService.reimportAwesomeList dry run', () => {
  it('reports the parse and the stored counts without writing anything', async () => {
    const db = makeDb();
    const { service, hydrate } = makeService(db);
    const report = await service.reimportAwesomeList(LIST_ID, LIST_SLUG, false);
    expect(report.applied).toBe(false);
    expect(report.after).toBeNull();
    expect(report.otherListsAfter).toBeNull();
    expect(report.parsed.items).toBe(2);
    expect(report.parsed.categories).toBe(1);
    expect(report.parsed.badgeDescriptions).toBe(0);
    expect(report.parsed.numberedCategories).toBe(0);
    expect(report.parsed.emptyCategories).toBe(0);
    expect(report.before.items).toBe(3);
    expect(report.otherListsBefore).toEqual({ categories: 10, items: 3 });
    expectNoWrites(db);
    expect(hydrate).not.toHaveBeenCalled();
  });
});

describe('SyncService.reimportAwesomeList apply', () => {
  it('deletes only this list inside one transaction, before re-creating categories', async () => {
    const db = makeDb();
    const { service } = makeService(db);
    await service.reimportAwesomeList(LIST_ID, LIST_SLUG, true);

    expect(db.$transaction).toHaveBeenCalledTimes(1);
    expect(db.categoryItem.deleteMany).toHaveBeenCalledTimes(1);
    expect(db.categoryItem.deleteMany).toHaveBeenCalledWith({
      where: { category: { awesomeListId: LIST_ID } },
    });
    expect(db.category.deleteMany).toHaveBeenCalledTimes(1);
    expect(db.category.deleteMany).toHaveBeenCalledWith({
      where: { awesomeListId: LIST_ID },
    });

    const firstUpsert = db.category.upsert.mock.invocationCallOrder[0];
    expect(db.categoryItem.deleteMany.mock.invocationCallOrder[0]).toBeLessThan(
      firstUpsert,
    );
    expect(db.category.deleteMany.mock.invocationCallOrder[0]).toBeLessThan(
      firstUpsert,
    );
  });

  it('persists only categories that a filtered item uses', async () => {
    const db = makeDb();
    const { service } = makeService(db);
    await service.reimportAwesomeList(LIST_ID, LIST_SLUG, true);

    const names = db.category.upsert.mock.calls.map(
      (call) => (call[0] as { create: { name: string } }).create.name,
    );
    expect(names).toContain('Deep Learning Frameworks');
    expect(names).not.toContain('Curated Resource Lists');
  });

  it('writes clean descriptions and marks the list completed inside the transaction', async () => {
    const db = makeDb();
    const { service } = makeService(db);
    await service.reimportAwesomeList(LIST_ID, LIST_SLUG, true);

    const created = db.categoryItem.create.mock.calls.map(
      (call) =>
        (
          call[0] as {
            data: { githubRepo: string; description: string | null };
          }
        ).data,
    );
    expect(created.map((d) => d.githubRepo)).toEqual([
      'pytorch/pytorch',
      'keras-team/keras',
    ]);
    for (const data of created) {
      expect(data.description ?? '').not.toContain('![');
    }

    expect(db.awesomeList.update).toHaveBeenCalledTimes(1);
    const update = db.awesomeList.update.mock.calls[0][0] as {
      where: { id: number };
      data: { state: string };
    };
    expect(update.where).toEqual({ id: LIST_ID });
    expect(update.data.state).toBe('completed');
    const txStart = db.$transaction.mock.invocationCallOrder[0];
    expect(db.awesomeList.update.mock.invocationCallOrder[0]).toBeGreaterThan(
      txStart,
    );
  });

  it('copies repo-derived star data onto the re-created items of this list only, inside the transaction', async () => {
    const db = makeDb();
    const { service } = makeService(db);
    await service.reimportAwesomeList(LIST_ID, LIST_SLUG, true);

    expect(db.$executeRaw).toHaveBeenCalledTimes(1);
    const [strings, ...values] = db.$executeRaw.mock.calls[0] as [
      TemplateStringsArray,
      ...unknown[],
    ];
    const sql = strings.join('?');
    expect(sql).toMatch(/UPDATE category_items/);
    expect(sql).toMatch(/SET stars = r\.stars/);
    expect(sql).toMatch(/c\.awesome_list_id = \?/);
    expect(values).toEqual([LIST_ID]);
    const rawAt = db.$executeRaw.mock.invocationCallOrder[0];
    expect(rawAt).toBeGreaterThan(
      db.categoryItem.create.mock.invocationCallOrder.at(-1)!,
    );
    expect(rawAt).toBeLessThan(
      db.awesomeList.update.mock.invocationCallOrder[0],
    );
  });

  it('hydrates new repos after the transaction and returns the after counts', async () => {
    const db = makeDb();
    const { service, hydrate } = makeService(db);
    const report = await service.reimportAwesomeList(LIST_ID, LIST_SLUG, true);

    expect(hydrate).toHaveBeenCalledTimes(1);
    expect(hydrate.mock.calls[0][0].length).toBe(2);
    expect(hydrate.mock.invocationCallOrder[0]).toBeGreaterThan(
      db.$transaction.mock.invocationCallOrder[0],
    );
    expect(db.awesomeList.update.mock.invocationCallOrder[0]).toBeLessThan(
      hydrate.mock.invocationCallOrder[0],
    );
    expect(report.applied).toBe(true);
    expect(report.after).not.toBeNull();
    expect(report.otherListsAfter).not.toBeNull();
  });

  it('does not rethrow a hydration failure', async () => {
    const db = makeDb();
    const { service, hydrate } = makeService(db);
    hydrate.mockRejectedValue(new Error('graphql down'));
    const report = await service.reimportAwesomeList(LIST_ID, LIST_SLUG, true);
    expect(report.applied).toBe(true);
  });
});

describe('SyncService.reimportAwesomeList sync write lock', () => {
  it('refuses before any network call or write when another session holds the lock', async () => {
    const db = makeDb();
    db.tryAdvisoryLock.mockResolvedValue(null);
    const { service, github } = makeService(db);
    await expect(
      service.reimportAwesomeList(LIST_ID, LIST_SLUG, true),
    ).rejects.toThrow(/Refusing.*sync write lock/);
    expect(db.awesomeList.findUnique).not.toHaveBeenCalled();
    expect(github.fetchReadme).not.toHaveBeenCalled();
    expectNoWrites(db);
  });

  it('releases the lock after an apply and after a refusal', async () => {
    const db = makeDb();
    const { service } = makeService(db);
    await service.reimportAwesomeList(LIST_ID, LIST_SLUG, true);
    expect(db.releaseLock).toHaveBeenCalledTimes(1);
    await expect(
      service.reimportAwesomeList(LIST_ID, 'not-this-list', false),
    ).rejects.toThrow(/Refusing/);
    expect(db.releaseLock).toHaveBeenCalledTimes(2);
  });

  it('re-enters the lock it already holds, so the CLI can wrap the dry run and the apply', async () => {
    const db = makeDb();
    const { service } = makeService(db);
    await service.runExclusive('re-import list', async () => {
      await service.reimportAwesomeList(LIST_ID, LIST_SLUG, false);
      await service.reimportAwesomeList(LIST_ID, LIST_SLUG, true);
    });
    expect(db.tryAdvisoryLock).toHaveBeenCalledTimes(1);
    expect(db.releaseLock).toHaveBeenCalledTimes(1);
  });
});

describe('SyncService.persistParsedData', () => {
  it('upserts only categories an item uses, for every caller', async () => {
    const db = makeDb();
    const { service } = makeService(db);
    const persist = (
      service as unknown as {
        persistParsedData: (
          id: number,
          categories: Array<{ name: string; order: number }>,
          items: Array<{
            name: string;
            primaryUrl: string;
            githubRepo: string | null;
            description: string | null;
            categoryIndex: number;
          }>,
        ) => Promise<number[]>;
      }
    ).persistParsedData.bind(service);

    await persist(
      LIST_ID,
      [
        { name: 'Deep Learning Frameworks', order: 0 },
        { name: 'Curated Resource Lists', order: 1 },
      ],
      [
        {
          name: 'PyTorch',
          primaryUrl: 'https://github.com/pytorch/pytorch',
          githubRepo: 'pytorch/pytorch',
          description: null,
          categoryIndex: 0,
        },
      ],
    );

    const names = db.category.upsert.mock.calls.map(
      (call) => (call[0] as { create: { name: string } }).create.name,
    );
    expect(names).toEqual(['Deep Learning Frameworks']);
  });
});
