/**
 * Backfill script: Link existing AwesomeLists to Repo records via repoId FK.
 *
 * For each list where repoId IS NULL, upserts a Repo record for the list's own
 * GitHub repo and updates the list's repoId. Then runs the full hydration chain
 * (stats → snapshots → backfill → trending) so star data is populated immediately.
 *
 * Usage:
 *   cd api
 *   DATABASE_URL="postgresql://awesomer:awesomer@localhost:5432/awesomer_platform" npx tsx scripts/backfill-list-repos.ts
 */

import { NestFactory } from '@nestjs/core';
import { AppModule } from '../src/app.module.js';
import { PrismaService } from '../src/prisma/prisma.service.js';
import { SyncService } from '../src/sync/sync.service.js';
import { BackfillService } from '../src/sync/backfill.service.js';

async function main() {
  const app = await NestFactory.createApplicationContext(AppModule);
  const prisma = app.get(PrismaService);
  const sync = app.get(SyncService);
  const backfill = app.get(BackfillService);

  // Find lists without a linked repo
  const lists = await prisma.awesomeList.findMany({
    where: { repoId: null, archived: false },
  });

  console.log(`Found ${lists.length} lists without a linked repo`);

  const repoIds: number[] = [];

  for (const list of lists) {
    const repo = await prisma.repo.upsert({
      where: { githubRepo: list.githubRepo },
      update: {},
      create: { githubRepo: list.githubRepo },
    });

    await prisma.awesomeList.update({
      where: { id: list.id },
      data: { repoId: repo.id },
    });

    repoIds.push(repo.id);
    console.log(`Linked ${list.name} → repo ${repo.id} (${list.githubRepo})`);
  }

  // Also find lists that have a linked repo but are missing star history
  const listsWithRepo = await prisma.awesomeList.findMany({
    where: { repoId: { not: null }, archived: false },
    include: { repo: { select: { id: true, stars7d: true } } },
  });
  for (const list of listsWithRepo) {
    if (list.repo && list.repo.stars7d === null && !repoIds.includes(list.repo.id)) {
      repoIds.push(list.repo.id);
      console.log(`Will backfill ${list.name} → repo ${list.repo.id} (missing star history)`);
    }
  }

  if (repoIds.length > 0) {
    console.log(`\nHydrating ${repoIds.length} list repos (stats → snapshots → backfill → trending)...`);

    await sync.syncGithubStatsForRepos(repoIds);
    console.log('Stats complete');

    const repos = await prisma.repo.findMany({
      where: { id: { in: repoIds }, githubRepo: { not: '' } },
      select: { id: true, githubRepo: true },
    });
    await sync.takeStarSnapshotsForRepos(repos);
    console.log('Snapshots complete');

    await backfill.backfillStarSnapshotsForRepos(repoIds);
    console.log('Backfill complete');

    await sync.computeTrendingForRepos(repoIds);
    console.log('Trending complete');
  }

  console.log('\nDone!');
  await app.close();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
