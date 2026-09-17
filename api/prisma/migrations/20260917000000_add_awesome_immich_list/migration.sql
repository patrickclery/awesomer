-- Insert awesome-immich (awesome.immich.app) as a new awesome list vertical.
-- Data-only migration: schema.prisma is unchanged.
--
-- parser_type = 'immich' routes getParser() to ImmichItemsJsonParser, which is the
-- point of this phase: awesome.immich.app is generated from a JSON data file, not a
-- README. The parser declares sourcePath = 'apps/awesome.immich.app/src/data/items.json'
-- and both sync.service.ts fetch sites (importAwesomeList, diffSyncAwesomeList) honour
-- it via GithubService.fetchFileContent(). With parser_type left NULL the import would
-- silently parse the static-pages monorepo README instead and find nothing.
--
-- Item arithmetic, counted from the upstream file itself rather than from the parser's
-- own output (a "51/51" self-report would be circular). Fetched 2026-09-17,
-- 18,146 bytes, 6 categories: Client apps, Command-line tools, Integrations, Tools,
-- Distributions, Guides.
--   61  projects in the file
--   -8  have no sourceCodeUrl at all (written guides / website-only entries)
--   -2  are hosted on non-GitHub forges (code.vexcited.com)
--   =51 GitHub root URLs, which is what the parser emits
--   -1  self-referencing 'immich-app/static-pages' entry, removed at import time by
--       filterAwesomeListRepos()
--   =50 persisted category_items across 49 unique repos (one repo is listed under two
--       categories, so items > unique repos)
-- The file changes often; these are the numbers observed when this migration was written.
--
-- github_repo is deliberately the static-pages monorepo and must NEVER be repointed at
-- 'immich-app/immich'. filterAwesomeListRepos() matches every item repo against every
-- list's github_repo, so a row carrying 'immich-app/immich' would delete that repo from
-- every other awesome list on its next diff-sync -- a cross-list regression.
--
-- Consequence, accepted for this phase: the `description` column was dropped by
-- 20260414_drop_awesome_list_description_last_commit_at, so list descriptions now come
-- from awesome_lists.repo_id -> repos.description. The immich list header will therefore
-- show the monorepo's blurb ("Sites and packages for Immich") and static-pages' star
-- count. A per-list description override is a follow-up, not this migration's job.
INSERT INTO awesome_lists
  (name, slug, github_repo, state, skip_external_links, sort_preference,
   parser_type, theme, sync_threshold, archived, created_at, updated_at)
VALUES (
  'Awesome Immich',
  'immich',
  'immich-app/static-pages',
  'pending',
  true,
  'stars',
  'immich',
  'claude',
  10,
  false,
  NOW(),
  NOW()
)
-- awesome_lists.slug is @unique. Without this guard a pre-existing 'immich' row
-- (manual insert, baselined database, partially-applied deploy) raises 23505, Prisma
-- records the migration as failed in _prisma_migrations, and every subsequent
-- `migrate deploy` is blocked until an operator runs `migrate resolve` by hand.
ON CONFLICT (slug) DO NOTHING;
