-- Insert awesome-local-llm as a new awesome list vertical
-- Data-only migration: schema.prisma is unchanged.
-- parser_type is NULL on purpose -> getParser() returns DefaultReadmeParser.
-- Item coverage was checked against the upstream README, not just against the
-- parser's own output ("186/186" would be circular): the README contains 188
-- GitHub URLs, 2 of which SKIP_URL correctly drops as /blob/ paths, leaving 186.
-- Section STRUCTURE is a known, accepted limitation rather than something this
-- migration verified. The README repeats "Retrieval-Augmented Generation",
-- "Miscellaneous" and "Models" as H3 headings under different H2 parents;
-- persistParsedData() slugs categories as slugify(`${awesomeListId}-${name}`),
-- so those same-named siblings collide on upsert and are merged into a single
-- category. It also ignores #### subsections (HEADER_RE caps at ###), which is
-- harmless here only because those subsections contain no GitHub URLs. Fixing
-- the merge needs either a local-llm parser that qualifies slugs by parent
-- heading or general sibling disambiguation in persistParsedData(), plus a data
-- migration to split the categories that have already been merged.
-- The `description` column present in the 20260401230000 analog was dropped by
-- 20260414_drop_awesome_list_description_last_commit_at; list descriptions now come from
-- awesome_lists.repo_id -> repos.description.
INSERT INTO awesome_lists
  (name, slug, github_repo, state, skip_external_links, sort_preference,
   parser_type, theme, sync_threshold, archived, created_at, updated_at)
VALUES (
  'Awesome local LLM',
  'local-llm',
  'rafska/awesome-local-llm',
  'pending',
  true,
  'stars',
  NULL,
  'claude',
  10,
  false,
  NOW(),
  NOW()
)
-- awesome_lists.slug is @unique. Without this guard a pre-existing 'local-llm'
-- row (manual insert, baselined database, partially-applied deploy) raises
-- 23505, Prisma records the migration as failed in _prisma_migrations, and
-- every subsequent `migrate deploy` is blocked until an operator runs
-- `migrate resolve` by hand.
ON CONFLICT (slug) DO NOTHING;
