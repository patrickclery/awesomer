/**
 * Data Migration Script: Rails PostgreSQL → Prisma PostgreSQL
 *
 * Migrates data from the existing Rails awesomer database to the new
 * Prisma-managed database. Handles:
 * - awesome_lists (adds generated slugs)
 * - categories (adds generated slugs)
 * - category_items
 * - repos
 * - star_snapshots
 *
 * Usage:
 *   npx tsx scripts/migrate-from-rails.ts
 *
 * Environment variables:
 *   RAILS_DATABASE_URL  - Source Rails database (default: postgresql://awesomer:awesomer_password@localhost:5432/awesomer_development)
 *   DATABASE_URL        - Target Prisma database (from prisma.config.ts)
 */

import pg from 'pg';
import { PrismaClient } from '../src/generated/prisma/client.js';
import { PrismaPg } from '@prisma/adapter-pg';

const { Pool } = pg;

const RAILS_DB_URL =
  process.env.RAILS_DATABASE_URL ||
  'postgresql://awesomer:awesomer_password@localhost:5432/awesomer_development';

function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .substring(0, 100);
}

function ensureUniqueSlug(slug: string, existing: Set<string>): string {
  let candidate = slug;
  let counter = 1;
  while (existing.has(candidate)) {
    candidate = `${slug}-${counter}`;
    counter++;
  }
  existing.add(candidate);
  return candidate;
}

async function main() {
  console.log('=== Awesomer Data Migration: Rails → Prisma ===\n');

  // Connect to Rails database (source)
  const railsPool = new Pool({ connectionString: RAILS_DB_URL });
  console.log(`Source: ${RAILS_DB_URL.replace(/:[^:@]+@/, ':***@')}`);

  // Connect to Prisma database (target)
  const targetPool = new pg.Pool({
    connectionString: process.env.DATABASE_URL,
  });
  const adapter = new PrismaPg(targetPool);
  const prisma = new PrismaClient({ adapter });
  await prisma.$connect();
  console.log('Target: Prisma database connected\n');

  try {
    // --- Step 1: Migrate awesome_lists ---
    console.log('Step 1: Migrating awesome_lists...');
    const { rows: awesomeLists } = await railsPool.query(
      'SELECT * FROM awesome_lists ORDER BY id',
    );
    const listSlugSet = new Set<string>();
    const listIdMap = new Map<number, number>(); // old ID → new ID

    for (const list of awesomeLists) {
      const slug = ensureUniqueSlug(slugify(list.name), listSlugSet);
      const created = await prisma.awesomeList.upsert({
        where: { slug },
        update: {},
        create: {
          name: list.name,
          slug,
          description: list.description,
          githubRepo: list.github_repo,
          state: list.state || 'pending',
          lastCommitAt: list.last_commit_at,
          skipExternalLinks: list.skip_external_links ?? true,
          processingStartedAt: list.processing_started_at,
          processingCompletedAt: list.processing_completed_at,
          lastSyncedAt: list.last_synced_at,
          lastPushedAt: list.last_pushed_at,
          syncThreshold: list.sync_threshold ?? 10,
          archived: list.archived ?? false,
          archivedAt: list.archived_at,
          readmeContent: list.readme_content,
          sortPreference: list.sort_preference || 'stars',
        },
      });
      listIdMap.set(list.id, created.id);
    }
    console.log(`  Migrated ${awesomeLists.length} awesome lists\n`);

    // --- Step 2: Migrate repos ---
    console.log('Step 2: Migrating repos...');
    const { rows: repos } = await railsPool.query(
      'SELECT * FROM repos ORDER BY id',
    );
    const repoIdMap = new Map<number, number>();

    for (const repo of repos) {
      const created = await prisma.repo.upsert({
        where: { githubRepo: repo.github_repo },
        update: {
          description: repo.description,
          stars: repo.stars,
          previousStars: repo.previous_stars,
          lastCommitAt: repo.last_commit_at,
          stars7d: repo.stars_7d,
          stars30d: repo.stars_30d,
          stars90d: repo.stars_90d,
          starHistoryFetchedAt: repo.star_history_fetched_at,
        },
        create: {
          githubRepo: repo.github_repo,
          description: repo.description,
          stars: repo.stars,
          previousStars: repo.previous_stars,
          lastCommitAt: repo.last_commit_at,
          stars7d: repo.stars_7d,
          stars30d: repo.stars_30d,
          stars90d: repo.stars_90d,
          starHistoryFetchedAt: repo.star_history_fetched_at,
        },
      });
      repoIdMap.set(repo.id, created.id);
    }
    console.log(`  Migrated ${repos.length} repos\n`);

    // --- Step 3: Migrate categories ---
    console.log('Step 3: Migrating categories...');
    const { rows: categories } = await railsPool.query(
      'SELECT * FROM categories ORDER BY id',
    );
    const categoryIdMap = new Map<number, number>();
    const categorySlugSet = new Set<string>();

    // First pass: categories without parents
    for (const cat of categories.filter((c: { parent_id: number | null }) => !c.parent_id)) {
      const slug = ensureUniqueSlug(slugify(cat.name), categorySlugSet);
      const newListId = listIdMap.get(cat.awesome_list_id);
      if (!newListId) {
        console.warn(`  Skipping category ${cat.id}: no matching awesome_list`);
        continue;
      }
      const created = await prisma.category.create({
        data: {
          name: cat.name,
          slug,
          awesomeListId: newListId,
          repoCount: cat.repo_count,
        },
      });
      categoryIdMap.set(cat.id, created.id);
    }

    // Second pass: categories with parents
    for (const cat of categories.filter((c: { parent_id: number | null }) => c.parent_id)) {
      const slug = ensureUniqueSlug(slugify(cat.name), categorySlugSet);
      const newListId = listIdMap.get(cat.awesome_list_id);
      const newParentId = categoryIdMap.get(cat.parent_id);
      if (!newListId) {
        console.warn(`  Skipping category ${cat.id}: no matching awesome_list`);
        continue;
      }
      const created = await prisma.category.create({
        data: {
          name: cat.name,
          slug,
          awesomeListId: newListId,
          parentId: newParentId || null,
          repoCount: cat.repo_count,
        },
      });
      categoryIdMap.set(cat.id, created.id);
    }
    console.log(`  Migrated ${categories.length} categories\n`);

    // --- Step 4: Migrate category_items ---
    console.log('Step 4: Migrating category_items...');
    const { rows: items } = await railsPool.query(
      'SELECT * FROM category_items ORDER BY id',
    );
    let itemCount = 0;
    let skippedItems = 0;

    for (const item of items) {
      const newCategoryId = categoryIdMap.get(item.category_id);
      if (!newCategoryId) {
        skippedItems++;
        continue;
      }
      const newRepoId = item.repo_id ? repoIdMap.get(item.repo_id) : null;

      await prisma.categoryItem.create({
        data: {
          name: item.name,
          githubRepo: item.github_repo,
          demoUrl: item.demo_url,
          primaryUrl: item.primary_url,
          description: item.description,
          commitsPastYear: item.commits_past_year,
          lastCommitAt: item.last_commit_at,
          stars: item.stars,
          categoryId: newCategoryId,
          previousStars: item.previous_stars,
          githubDescription: item.github_description,
          stars30d: item.stars_30d,
          stars90d: item.stars_90d,
          starHistoryFetchedAt: item.star_history_fetched_at,
          repoId: newRepoId || null,
        },
      });
      itemCount++;
    }
    console.log(
      `  Migrated ${itemCount} category items (${skippedItems} skipped)\n`,
    );

    // --- Step 5: Migrate star_snapshots ---
    console.log('Step 5: Migrating star_snapshots...');
    const { rows: snapshotCount } = await railsPool.query(
      'SELECT COUNT(*) as count FROM star_snapshots',
    );
    const totalSnapshots = parseInt(snapshotCount[0].count);
    console.log(`  Total snapshots to migrate: ${totalSnapshots}`);

    const BATCH_SIZE = 5000;
    let offset = 0;
    let migratedSnapshots = 0;

    while (offset < totalSnapshots) {
      const { rows: snapshots } = await railsPool.query(
        `SELECT * FROM star_snapshots ORDER BY id LIMIT ${BATCH_SIZE} OFFSET ${offset}`,
      );

      const batchData = snapshots
        .map((s: { repo_id: number; stars: number; snapshot_date: string }) => {
          const newRepoId = repoIdMap.get(s.repo_id);
          if (!newRepoId) return null;
          return {
            repoId: newRepoId,
            stars: s.stars,
            snapshotDate: new Date(s.snapshot_date),
          };
        })
        .filter(Boolean) as Array<{
        repoId: number;
        stars: number;
        snapshotDate: Date;
      }>;

      if (batchData.length > 0) {
        await prisma.starSnapshot.createMany({
          data: batchData,
          skipDuplicates: true,
        });
      }

      migratedSnapshots += batchData.length;
      offset += BATCH_SIZE;
      process.stdout.write(
        `\r  Progress: ${migratedSnapshots}/${totalSnapshots} (${Math.round((migratedSnapshots / totalSnapshots) * 100)}%)`,
      );
    }
    console.log(`\n  Migrated ${migratedSnapshots} star snapshots\n`);

    // --- Verification ---
    console.log('=== Verification ===');
    const counts = {
      awesomeLists: await prisma.awesomeList.count(),
      repos: await prisma.repo.count(),
      categories: await prisma.category.count(),
      categoryItems: await prisma.categoryItem.count(),
      starSnapshots: await prisma.starSnapshot.count(),
    };

    console.log(`  awesome_lists: ${awesomeLists.length} → ${counts.awesomeLists}`);
    console.log(`  repos:         ${repos.length} → ${counts.repos}`);
    console.log(`  categories:    ${categories.length} → ${counts.categories}`);
    console.log(`  category_items:${items.length} → ${counts.categoryItems}`);
    console.log(`  star_snapshots:${totalSnapshots} → ${counts.starSnapshots}`);
    console.log('\nMigration complete!');
  } finally {
    await railsPool.end();
    await prisma.$disconnect();
    await targetPool.end();
  }
}

main().catch((error) => {
  console.error('Migration failed:', error);
  process.exit(1);
});
