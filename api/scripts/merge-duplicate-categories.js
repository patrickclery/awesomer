/**
 * Operator CLI: one-off merge of duplicate categories.
 *
 * Feb-2026 legacy category slugs (`containers`, `c-1`) never match the
 * `${awesomeListId}-${name}` slug that persistParsedData upserts on, so later
 * imports created a second row for the same heading. This script folds every
 * (awesome_list_id, trimmed name) group with more than one row into its lowest
 * id, which keeps the legacy slug and its `#category-<slug>` anchors. Matching
 * is exact on the trimmed name, with no case-folding.
 *
 * For each group, a loser item that matches a survivor item (same primary_url,
 * or same non-null github_repo) is deleted and the survivor's copy kept. Every
 * other loser item moves to the survivor. The emptied loser rows are deleted.
 * No other category is touched.
 *
 * Safety:
 * - Dry run by default: prints the merge plan and writes nothing. `--apply` is
 *   required to change data.
 * - Backup (forensic, public data): `--apply` first writes JSON (dir mode 0700,
 *   file mode 0600, never overwritten) to `--backup-dir`, default
 *   ~/backups/awesomer. It holds the plan (ids only) and every affected
 *   category row with all its items. There is no restore mode: a hand restore
 *   re-inserts the deleted loser categories and items with explicit ids, moves
 *   the moved items back to their loser category ids, and fixes the sequences,
 *   in one transaction.
 * - Atomic: every delete, move and rename runs in one transaction. Each count
 *   is checked against the plan, and after the last group the transaction
 *   re-checks that no duplicate group remains in scope and that the whole-table
 *   category and item counts fell by exactly the planned amounts. Any mismatch
 *   throws `Merge invariant failed: ...` and rolls everything back. Item deletes
 *   also filter on the loser ids, so a survivor item cannot be deleted, and the
 *   RESTRICT FK blocks deleting a loser that still holds an item.
 * - Sync write lock: the plan, the backup and the apply run under the Postgres
 *   advisory lock (SyncService.runExclusive('merge duplicate categories', ...))
 *   that the daily pipeline, the legacy sync, imports, diff-syncs and the
 *   re-import CLI also take. The script refuses when another process holds it.
 * - Nightly fast-fail: `--apply` also refuses up front unless
 *   awesomer-sync-snapshots.service is loaded and inactive or failed (fail
 *   closed), before Nest boots.
 * - In-process crons are disarmed right after boot, so this process never runs
 *   the scheduled pipeline.
 * - A re-run with nothing left to merge prints the dry-run report only and
 *   writes no backup.
 *
 * Why a script and not an admin route: a destructive one-off merge needs a
 * local shell and the DB credentials the operator already holds, so it adds no
 * network-reachable surface.
 *
 * Output: one `MERGE_REPORT <json>` line per report (the dry run, then the
 * applied result), and `MERGE_BACKUP <path>` before an apply. Environment
 * values are never printed.
 *
 * Exit codes: 0 ok, 1 refused or failed, 2 usage.
 *
 * IMPORTANT: Imports from dist/ (compiled output) because NestJS decorator
 * metadata requires tsc's emitDecoratorMetadata.
 *
 * Prerequisites:
 *   cd api && npx nest build   # must compile before running
 *
 * Usage:
 *   cd api
 *   node --import dotenv/config scripts/merge-duplicate-categories.js
 *   node --import dotenv/config scripts/merge-duplicate-categories.js --list-id 187
 *   node --import dotenv/config scripts/merge-duplicate-categories.js --list-id 187 --apply
 *   node --import dotenv/config scripts/merge-duplicate-categories.js --apply
 */

import 'reflect-metadata';
import { execFileSync } from 'node:child_process';
import { chmodSync, mkdirSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';
import { parseArgs } from 'node:util';

const NIGHTLY_UNIT = 'awesomer-sync-snapshots.service';
const DEFAULT_BACKUP_DIR = join(homedir(), 'backups', 'awesomer');

const USAGE = `Usage: node --import dotenv/config scripts/merge-duplicate-categories.js [--list-id <id>] [--apply] [--backup-dir <dir>]

  --list-id     limit the merge to one awesome_lists id (positive integer; default all lists)
  --apply       write: back up the affected rows, then merge them in one transaction
                (default is a dry run that writes nothing)
  --backup-dir  where --apply writes the backup JSON (default ${DEFAULT_BACKUP_DIR})`;

function usage(message) {
  if (message) console.error(message);
  console.error(USAGE);
  process.exit(2);
}

function parseCli() {
  let values;
  try {
    ({ values } = parseArgs({
      options: {
        'list-id': { type: 'string' },
        apply: { type: 'boolean', default: false },
        'backup-dir': { type: 'string', default: DEFAULT_BACKUP_DIR },
      },
      strict: true,
      allowPositionals: false,
    }));
  } catch (err) {
    usage(err.message);
  }
  const raw = values['list-id'];
  if (raw !== undefined && !/^[1-9]\d*$/.test(raw)) usage('--list-id must be a positive integer');
  const backupDir = values['backup-dir'];
  if (!backupDir) usage('--backup-dir must not be empty');
  return { listId: raw === undefined ? null : Number(raw), apply: values.apply, backupDir };
}

function systemctlValue(property) {
  return execFileSync('systemctl', ['show', '-p', property, '--value', NIGHTLY_UNIT], {
    encoding: 'utf-8',
    stdio: ['ignore', 'pipe', 'pipe'],
  }).trim();
}

/** Returns a refusal reason when the nightly may be running, else null. Fails closed. */
function nightlyBusyReason() {
  let load;
  let state;
  try {
    load = systemctlValue('LoadState');
    if (load !== 'loaded') return `${NIGHTLY_UNIT} not found (LoadState=${load || 'empty'})`;
    state = systemctlValue('ActiveState');
  } catch {
    return `the state of ${NIGHTLY_UNIT} could not be read`;
  }
  if (state === 'inactive' || state === 'failed') return null;
  return `${NIGHTLY_UNIT} is running (ActiveState=${state})`;
}

function writePrivateJson(file, data) {
  writeFileSync(file, JSON.stringify(data, null, 2), { mode: 0o600, flag: 'wx' });
  chmodSync(file, 0o600);
}

function scopeWhere(listId) {
  return listId ? { awesomeListId: listId } : {};
}

/** Groups categories by (awesomeListId, trimmed name) and returns the groups with 2+ rows, ids ascending. */
function duplicateGroups(categories) {
  const byKey = new Map();
  for (const cat of categories) {
    const key = `${cat.awesomeListId}\u0000${cat.name.trim()}`;
    const rows = byKey.get(key);
    if (rows) rows.push(cat);
    else byKey.set(key, [cat]);
  }
  return [...byKey.values()].filter((rows) => rows.length > 1).map((rows) => rows.sort((a, b) => a.id - b.id));
}

/** Read only: works out which rows survive, which items move and which are dropped as duplicates. */
async function buildMergePlan(prisma, listId) {
  const categories = await prisma.category.findMany({
    where: scopeWhere(listId),
    select: { id: true, awesomeListId: true, name: true, slug: true },
    orderBy: { id: 'asc' },
  });
  const rawGroups = duplicateGroups(categories);
  const affectedIds = rawGroups.flatMap((rows) => rows.map((r) => r.id));

  const items = affectedIds.length
    ? await prisma.categoryItem.findMany({
        where: { categoryId: { in: affectedIds } },
        select: { id: true, categoryId: true, primaryUrl: true, githubRepo: true },
        orderBy: { id: 'asc' },
      })
    : [];
  const itemsByCategory = new Map();
  for (const item of items) {
    const list = itemsByCategory.get(item.categoryId);
    if (list) list.push(item);
    else itemsByCategory.set(item.categoryId, [item]);
  }

  const groups = rawGroups.map(([survivor, ...losers]) => {
    const name = survivor.name.trim();
    const urls = new Set();
    const repos = new Set();
    const remember = (item) => {
      if (item.primaryUrl != null) urls.add(item.primaryUrl);
      if (item.githubRepo != null) repos.add(item.githubRepo);
    };
    for (const item of itemsByCategory.get(survivor.id) ?? []) remember(item);

    const moveItemIds = [];
    const deleteItemIds = [];
    for (const loser of losers) {
      for (const item of itemsByCategory.get(loser.id) ?? []) {
        const dup =
          (item.primaryUrl != null && urls.has(item.primaryUrl)) ||
          (item.githubRepo != null && repos.has(item.githubRepo));
        if (dup) {
          deleteItemIds.push(item.id);
        } else {
          moveItemIds.push(item.id);
          remember(item);
        }
      }
    }

    return {
      awesomeListId: survivor.awesomeListId,
      name,
      survivorId: survivor.id,
      survivorSlug: survivor.slug,
      loserIds: losers.map((l) => l.id),
      loserSlugs: losers.map((l) => l.slug),
      moveItemIds,
      deleteItemIds,
      renameTo: survivor.name !== name ? name : null,
    };
  });

  return { groups, affectedIds };
}

function summarize(plan, scope, before, applyResult) {
  const perListMap = new Map();
  let losers = 0;
  let itemsMoved = 0;
  let itemsDeletedAsDuplicate = 0;
  for (const g of plan.groups) {
    losers += g.loserIds.length;
    itemsMoved += g.moveItemIds.length;
    itemsDeletedAsDuplicate += g.deleteItemIds.length;
    const row = perListMap.get(g.awesomeListId) ?? {
      awesomeListId: g.awesomeListId,
      groups: 0,
      losers: 0,
      itemsMoved: 0,
      itemsDeletedAsDuplicate: 0,
    };
    row.groups += 1;
    row.losers += g.loserIds.length;
    row.itemsMoved += g.moveItemIds.length;
    row.itemsDeletedAsDuplicate += g.deleteItemIds.length;
    perListMap.set(g.awesomeListId, row);
  }
  const perList = [...perListMap.values()].sort((a, b) => a.awesomeListId - b.awesomeListId);
  return {
    applied: Boolean(applyResult),
    scope,
    groups: plan.groups.length,
    lists: perList.length,
    losers,
    loserItems: itemsMoved + itemsDeletedAsDuplicate,
    itemsMoved,
    itemsDeletedAsDuplicate,
    categoriesDeleted: losers,
    before,
    after: applyResult ? applyResult.after : null,
    remainingDuplicateGroups: applyResult ? applyResult.remainingDuplicateGroups : null,
    perList,
  };
}

function report(r) {
  console.log(`MERGE_REPORT ${JSON.stringify(r)}`);
}

async function writeBackup(prisma, plan, scope, backupDir) {
  const categories = await prisma.category.findMany({
    where: { id: { in: plan.affectedIds } },
    include: { categoryItems: true },
    orderBy: { id: 'asc' },
  });
  const takenAt = new Date().toISOString();
  mkdirSync(backupDir, { recursive: true, mode: 0o700 });
  chmodSync(backupDir, 0o700);
  const label = scope === 'all' ? 'all' : `list-${scope}`;
  const file = join(backupDir, `merge-categories-${label}-${takenAt.replace(/:/g, '-')}.json`);
  writePrivateJson(file, { scope, takenAt, groups: plan.groups, categories });
  return file;
}

function expectCount(what, actual, planned) {
  if (actual !== planned) throw new Error(`Merge invariant failed: ${what} affected ${actual} rows, planned ${planned}`);
}

/** Applies the plan in one transaction and re-checks the invariants before it commits. */
async function applyPlan(prisma, plan, listId) {
  const losers = plan.groups.reduce((n, g) => n + g.loserIds.length, 0);
  const deleted = plan.groups.reduce((n, g) => n + g.deleteItemIds.length, 0);

  return prisma.$transaction(
    async (tx) => {
      const before = { categories: await tx.category.count(), items: await tx.categoryItem.count() };

      for (const g of plan.groups) {
        const where = `list ${g.awesomeListId} "${g.name}"`;
        if (g.deleteItemIds.length) {
          const res = await tx.categoryItem.deleteMany({
            where: { id: { in: g.deleteItemIds }, categoryId: { in: g.loserIds } },
          });
          expectCount(`duplicate item delete for ${where}`, res.count, g.deleteItemIds.length);
        }
        if (g.moveItemIds.length) {
          const res = await tx.categoryItem.updateMany({
            where: { id: { in: g.moveItemIds }, categoryId: { in: g.loserIds } },
            data: { categoryId: g.survivorId },
          });
          expectCount(`item move for ${where}`, res.count, g.moveItemIds.length);
        }
        if (g.renameTo) {
          await tx.category.update({ where: { id: g.survivorId }, data: { name: g.renameTo } });
        }
        if (g.loserIds.length) {
          const res = await tx.category.deleteMany({ where: { id: { in: g.loserIds } } });
          expectCount(`loser category delete for ${where}`, res.count, g.loserIds.length);
        }
      }

      const remaining = await tx.category.findMany({
        where: scopeWhere(listId),
        select: { id: true, awesomeListId: true, name: true },
      });
      const remainingDuplicateGroups = duplicateGroups(remaining).length;
      if (remainingDuplicateGroups !== 0) {
        throw new Error(`Merge invariant failed: ${remainingDuplicateGroups} duplicate groups remain`);
      }
      const after = { categories: await tx.category.count(), items: await tx.categoryItem.count() };
      if (after.categories !== before.categories - losers) {
        throw new Error(
          `Merge invariant failed: ${after.categories} categories, expected ${before.categories - losers}`,
        );
      }
      if (after.items !== before.items - deleted) {
        throw new Error(`Merge invariant failed: ${after.items} items, expected ${before.items - deleted}`);
      }
      return { before, after, remainingDuplicateGroups };
    },
    { maxWait: 10_000, timeout: 600_000 },
  );
}

async function main() {
  const { listId, apply, backupDir } = parseCli();
  const scope = listId ?? 'all';

  if (apply) {
    const busy = nightlyBusyReason();
    if (busy) {
      console.error(`Refusing to apply: ${busy}`);
      return 1;
    }
  }

  const { NestFactory } = await import('@nestjs/core');
  const { SchedulerRegistry } = await import('@nestjs/schedule');
  const { AppModule } = await import('../dist/src/app.module.js');
  const { SyncService } = await import('../dist/src/sync/sync.service.js');
  const { PrismaService } = await import('../dist/src/prisma/prisma.service.js');

  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ['log', 'error', 'warn'],
  });

  let code = 0;
  try {
    // Disarm every scheduled job before any work.
    const scheduler = app.get(SchedulerRegistry);
    for (const job of scheduler.getCronJobs().values()) job.stop();
    for (const name of scheduler.getIntervals()) scheduler.deleteInterval(name);
    for (const name of scheduler.getTimeouts()) scheduler.deleteTimeout(name);

    const sync = app.get(SyncService);
    const prisma = app.get(PrismaService);
    // Hold the sync write lock across the plan, the backup and the apply, so no other
    // writer can change these rows between what is reported and what is applied.
    await sync.runExclusive('merge duplicate categories', async () => {
      const plan = await buildMergePlan(prisma, listId);
      const before = { categories: await prisma.category.count(), items: await prisma.categoryItem.count() };
      report(summarize(plan, scope, before, null));

      if (apply && plan.groups.length > 0) {
        const file = await writeBackup(prisma, plan, scope, backupDir);
        console.log(`MERGE_BACKUP ${file}`);
        const result = await applyPlan(prisma, plan, listId);
        report(summarize(plan, scope, result.before, result));
      }
    });
  } catch (err) {
    console.error(err instanceof Error ? err.message : String(err));
    code = 1;
  } finally {
    await app.close();
  }
  return code;
}

main()
  .then((code) => process.exit(code))
  .catch((err) => {
    console.error(err instanceof Error ? err.message : String(err));
    process.exit(1);
  });
