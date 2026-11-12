-- Phase 33: enforce one category per (awesome list, heading name).
--
-- persistParsedData used to upsert categories by slug `${awesomeListId}-${name}`, which never
-- matched the legacy un-prefixed slugs (`containers`, `security-6`), so imports created a second
-- row for the same heading. persistParsedData now looks categories up by (awesome_list_id, name),
-- and this index is the hard guard behind it.
--
-- Apply ONLY after `scripts/merge-duplicate-categories.js --apply` has merged every duplicate.
-- If any duplicate remains, Postgres refuses with "could not create unique index" and names the
-- duplicated (awesome_list_id, name) key. That loud failure is intended: re-run the merge, then
-- `npx prisma migrate resolve --rolled-back 20261111000000_unique_category_list_name`, then
-- `npx prisma migrate deploy` again.

-- CreateIndex
CREATE UNIQUE INDEX "categories_awesome_list_id_name_key" ON "categories"("awesome_list_id", "name");
