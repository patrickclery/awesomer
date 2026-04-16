/**
 * Static data export script.
 *
 * Bootstraps a NestJS application context (no HTTP server needed) and exports
 * database data to JSON files in web/data/. These files are consumed by
 * Next.js generateStaticParams at build time, removing the need for a running
 * API server during static site generation.
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
 *   node scripts/export-static-data.js
 */

import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../dist/src/app.module.js';
import { StaticDataService } from '../dist/src/sync/static-data.service.js';
import { AwesomeListsService } from '../dist/src/awesome-lists/awesome-lists.service.js';
import fs from 'node:fs';
import path from 'node:path';

async function main() {
  console.log('Bootstrapping NestJS application context...');
  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ['log', 'error', 'warn'],
  });

  const staticData = app.get(StaticDataService);
  const awesomeListsService = app.get(AwesomeListsService);

  const outputDir = path.resolve(import.meta.dirname, '../../web/data');
  fs.mkdirSync(outputDir, { recursive: true });

  try {
    // Export lists.json -- wraps in { data: ... } to match API response shape
    const lists = await awesomeListsService.findAll();
    const listsPath = path.join(outputDir, 'lists.json');
    fs.writeFileSync(listsPath, JSON.stringify({ data: lists }, null, 2));
    console.log(`Wrote ${listsPath} (${lists.length} lists)`);

    // Export repo-slugs.json -- wraps in { data: ... } to match API response shape
    const repoSlugs = await staticData.exportRepoSlugs();
    const repoSlugsPath = path.join(outputDir, 'repo-slugs.json');
    fs.writeFileSync(repoSlugsPath, JSON.stringify({ data: repoSlugs }, null, 2));
    console.log(`Wrote ${repoSlugsPath} (${repoSlugs.length} repo slugs)`);

    console.log('Static data export completed successfully');
  } catch (error) {
    console.error('Static data export failed:', error);
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
