/**
 * Standalone daily sync pipeline script.
 *
 * Bootstraps a NestJS application context (no HTTP server needed) and runs
 * SyncService.runDailyPipeline(). Designed to be called by systemd timer or
 * cron -- does NOT depend on the API server running on port 4000.
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

  console.log('Bootstrapping NestJS application context...');
  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ['log', 'error', 'warn'],
  });

  const sync = app.get(SyncService);

  try {
    if (args.length > 0) {
      // Run specific steps
      console.log(`Running sync pipeline with steps: ${args.join(', ')}`);
      await sync.runDailySync(args);
    } else {
      // Run the full daily pipeline (includes diff-sync, snapshots, trending, markdown, rebuild)
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
  console.log('Done');
}

main().catch((err) => {
  console.error('Fatal error:', err);
  process.exit(1);
});
