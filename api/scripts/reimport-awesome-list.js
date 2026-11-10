/**
 * Operator CLI: guarded clean re-import of one awesome list.
 *
 * Replaces every category and category item of one list with what the current
 * parser reads from today's upstream source, through
 * SyncService.reimportAwesomeList(). Diff-sync keys on primaryUrl and never
 * corrects a stored row, so a parser fix alone repairs nothing already stored;
 * this script is how such a fix reaches the data.
 *
 * Safety:
 * - Dry run by default: prints what is stored and what the parse holds, and
 *   writes nothing. `--apply` is required to change data.
 * - Scope interlock: `--slug` must equal the list's stored slug, or the
 *   service refuses before any network call. Deletes filter on the list id.
 * - Wipe guards: the service refuses a parse with zero items, or fewer than
 *   REIMPORT_MIN_RATIO of the stored item count.
 * - Atomic: the delete and the re-insert run in one transaction; any error
 *   rolls back and leaves the list as it was.
 * - Backup: `--apply` first writes the list's categories and items as JSON
 *   (dir mode 0700, file mode 0600) to `--backup-dir`, default
 *   ~/backups/awesomer. The backup holds only public category and item rows.
 * - Nightly guard: `--apply` refuses unless awesomer-sync-snapshots.service is
 *   loaded and inactive or failed (fail closed, like docker/build.sh).
 * - In-process crons are disarmed right after boot, so this process never
 *   runs the scheduled pipeline.
 *
 * Why a script and not an admin route: a destructive re-import needs a local
 * shell and the DB credentials the operator already holds, so it adds no
 * network-reachable surface.
 *
 * Output: one `REIMPORT_REPORT <json>` line per report, and `REIMPORT_BACKUP
 * <path>` before an apply. Environment values are never printed.
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
 *   node --import dotenv/config scripts/reimport-awesome-list.js --list-id 262 --slug opensource-ai
 *   node --import dotenv/config scripts/reimport-awesome-list.js --list-id 262 --slug opensource-ai --apply
 */

import 'reflect-metadata';
import { execFileSync } from 'node:child_process';
import { chmodSync, mkdirSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';
import { parseArgs } from 'node:util';

const NIGHTLY_UNIT = 'awesomer-sync-snapshots.service';
const DEFAULT_BACKUP_DIR = join(homedir(), 'backups', 'awesomer');

const USAGE = `Usage: node --import dotenv/config scripts/reimport-awesome-list.js --list-id <id> --slug <slug> [--apply] [--backup-dir <dir>]

  --list-id     awesome_lists id to re-import (positive integer, required)
  --slug        the list's stored slug; must match or the re-import refuses (required)
  --apply       write: back up the list's rows, then replace them in one transaction
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
        slug: { type: 'string' },
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
  if (!raw || !/^[1-9]\d*$/.test(raw)) usage('--list-id must be a positive integer');
  const slug = values.slug?.trim();
  if (!slug) usage('--slug is required');
  const backupDir = values['backup-dir'];
  if (!backupDir) usage('--backup-dir must not be empty');
  return { listId: Number(raw), slug, apply: values.apply, backupDir };
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

function report(r) {
  console.log(`REIMPORT_REPORT ${JSON.stringify(r)}`);
}

async function writeBackup(prisma, listId, slug, backupDir) {
  const categories = await prisma.category.findMany({
    where: { awesomeListId: listId },
    include: { categoryItems: true },
    orderBy: { id: 'asc' },
  });
  const takenAt = new Date().toISOString();
  mkdirSync(backupDir, { recursive: true, mode: 0o700 });
  chmodSync(backupDir, 0o700);
  const file = join(backupDir, `reimport-list-${listId}-${takenAt.replace(/:/g, '-')}.json`);
  writeFileSync(file, JSON.stringify({ awesomeListId: listId, slug, takenAt, categories }, null, 2), {
    mode: 0o600,
    flag: 'wx',
  });
  chmodSync(file, 0o600);
  return file;
}

async function main() {
  const { listId, slug, apply, backupDir } = parseCli();

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
    report(await sync.reimportAwesomeList(listId, slug, false));

    if (apply) {
      const file = await writeBackup(app.get(PrismaService), listId, slug, backupDir);
      console.log(`REIMPORT_BACKUP ${file}`);
      report(await sync.reimportAwesomeList(listId, slug, true));
    }
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
