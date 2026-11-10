/**
 * Standalone static-site build script (build only).
 *
 * Builds web/out using the same rebuild step the nightly runs
 * (SyncService.rebuildStaticSite(): data export to web/data, .next clear,
 * `next build` with BASE_PATH, sanity checks). It never deploys and never
 * commits anything (D-08).
 *
 * Why a separate script: `run-daily-pipeline.js rebuild` routes through a step
 * runner that logs and swallows errors, so it exits 0 even when the build or
 * its sanity check fails. This script calls rebuildStaticSite() directly
 * (which rethrows) and exits 0 on success or 1 on failure.
 *
 * The listener binds 127.0.0.1 only, never every interface.
 *
 * Unlike run-daily-pipeline.js there is no fallback when PORT is already in
 * use: borrowing another API process would build against the wrong data, so
 * a bind failure is fatal.
 *
 * In-process crons: SyncModule imports ScheduleModule.forRoot(), so booting
 * AppModule arms the scheduled pipeline. Every registered cron job, interval
 * and timeout is stopped right after app.init() and before listen(), so this
 * process can never start the scheduled pipeline, however long the build runs.
 *
 * IMPORTANT: Imports from dist/ (compiled output) because NestJS decorator
 * metadata requires tsc's emitDecoratorMetadata.
 *
 * Prerequisites:
 *   cd api && npm run build   # must compile before running
 *
 * Usage:
 *   cd api
 *   node scripts/build-static-site.js
 */

import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SchedulerRegistry } from '@nestjs/schedule';
import { AppModule } from '../dist/src/app.module.js';
import { SyncService } from '../dist/src/sync/sync.service.js';

async function main() {
  const port = Number(process.env.PORT ?? 4000);

  console.log('Bootstrapping NestJS HTTP application for static build...');
  const app = await NestFactory.create(AppModule, {
    logger: ['log', 'error', 'warn'],
  });
  app.setGlobalPrefix('api');
  app.enableCors();
  app.useGlobalPipes(
    new ValidationPipe({ whitelist: true, transform: true, forbidNonWhitelisted: true }),
  );

  await app.init();

  // Disarm every scheduled job before the listener starts.
  const scheduler = app.get(SchedulerRegistry);
  let stopped = 0;
  for (const job of scheduler.getCronJobs().values()) {
    job.stop();
    stopped++;
  }
  for (const name of scheduler.getIntervals()) {
    scheduler.deleteInterval(name);
  }
  for (const name of scheduler.getTimeouts()) {
    scheduler.deleteTimeout(name);
  }
  console.log(`Stopped ${stopped} in-process cron job(s); this process never runs the scheduled pipeline`);

  // Loopback only: the build reaches the API at http://localhost:${PORT}/api,
  // and in the container this keeps the admin routes off the shared
  // awesomer_default network.
  await app.listen(port, '127.0.0.1');
  console.log(`API listening on 127.0.0.1:${port} for SSG build`);

  let code = 0;
  try {
    await app.get(SyncService).rebuildStaticSite();
  } catch (err) {
    console.error('Static build failed:', err);
    code = 1;
  }

  await app.close();
  return code;
}

main()
  .then((code) => process.exit(code))
  .catch((err) => {
    console.error('Fatal error:', err);
    process.exit(1);
  });
