/**
 * Standalone daily sync pipeline script.
 *
 * Bootstraps a full NestJS HTTP application (not just an injection context)
 * and runs SyncService.runDailyPipeline(). The HTTP listener is required
 * because rebuildStaticSite() spawns `npm run build` in web/, and the
 * Next.js SSG build calls localhost:${PORT}/api/* during page generation.
 * Without a listener every page falls back to 404 and the build sanity
 * check refuses to deploy. The listener shuts down with app.close() when
 * the pipeline finishes, so the API isn't left running between syncs.
 *
 * If port ${PORT} is already in use (e.g. dev API is up), we skip our own
 * listener and rely on the existing server to handle the build's fetches.
 *
 * IMPORTANT: Imports from dist/ (compiled output) because NestJS decorator
 * metadata requires tsc's emitDecoratorMetadata. Running TypeScript source
 * via tsx/SWC loses this metadata and breaks dependency injection.
 *
 * Prerequisites:
 *   cd api && npm run build   # must compile before running
 *
 * Usage:
 *   cd api
 *   node scripts/run-daily-pipeline.js
 *
 * Optional: pass specific steps to run only part of the pipeline:
 *   node scripts/run-daily-pipeline.js snapshots trending
 *
 * Valid steps: diff, stats, snapshots, trending, markdown, rebuild, deploy
 * Default (no args): runs the full daily pipeline (diff + snapshots + trending + markdown + rebuild + deploy)
 */

import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from '../dist/src/app.module.js';
import { SyncService } from '../dist/src/sync/sync.service.js';

const VALID_STEPS = ['diff', 'stats', 'snapshots', 'trending', 'markdown', 'rebuild', 'deploy'];

async function main() {
  const args = process.argv.slice(2);

  // Validate step arguments if provided
  if (args.length > 0) {
    for (const arg of args) {
      if (!VALID_STEPS.includes(arg)) {
        console.error(`Invalid step: "${arg}". Valid steps: ${VALID_STEPS.join(', ')}`);
        process.exit(1);
      }
    }
  }

  const port = Number(process.env.PORT ?? 4000);

  console.log('Bootstrapping NestJS HTTP application...');
  const app = await NestFactory.create(AppModule, {
    logger: ['log', 'error', 'warn'],
  });
  app.setGlobalPrefix('api');
  app.enableCors();
  app.useGlobalPipes(
    new ValidationPipe({ whitelist: true, transform: true, forbidNonWhitelisted: true }),
  );

  let listenerStarted = false;
  try {
    await app.listen(port);
    listenerStarted = true;
    console.log(`API listening on port ${port} for SSG build`);
  } catch (err) {
    if (err && err.code === 'EADDRINUSE') {
      console.log(`Port ${port} already in use — relying on existing API server`);
    } else {
      await app.close();
      throw err;
    }
  }

  const sync = app.get(SyncService);

  try {
    if (args.length > 0) {
      console.log(`Running sync pipeline with steps: ${args.join(', ')}`);
      await sync.runDailySync(args);
    } else {
      console.log('Running full daily pipeline...');
      await sync.runDailyPipeline();
    }

    console.log('Pipeline completed successfully');
  } catch (error) {
    console.error('Pipeline failed:', error);
    await app.close();
    process.exit(1);
  }

  await app.close();
  console.log(listenerStarted ? 'Done (listener stopped)' : 'Done');
}

main().catch((err) => {
  console.error('Fatal error:', err);
  process.exit(1);
});
