/** Repos with fewer stars than this are excluded from all listings and trending. */
export const MIN_STARS = 100;

/**
 * The slug of the "awesome" meta-list (sindresorhus/awesome).
 * This list catalogs awesome lists, so cross-references should NOT be filtered from it.
 */
export const META_AWESOME_LIST_SLUG = 'awesome';

/**
 * Caps GraphQL pagination of stargazers (100 per page → 100k stargazers max).
 * The REST endpoint hard-caps at 400 pages and pages 401+ return HTTP 422,
 * so we use GraphQL with orderBy: STARRED_AT DESC. This cap exists only
 * to bound GraphQL point usage on ultra-viral repos; normal repos hit the
 * STARGAZER_BACKFILL_DAYS stop condition long before this.
 */
export const MAX_STARGAZER_PAGES = 1000;

/**
 * Backfill window: stop paginating stargazers once the oldest one in our
 * batch is older than this many days. Covers 90d trending + buffer.
 */
export const STARGAZER_BACKFILL_DAYS = 100;

/** Repos whose last commit is older than this many days are excluded from individual repo pages. */
export const STALE_DAYS = 365;

/**
 * Postgres advisory-lock key shared by every writer of list rows: the daily pipeline,
 * the legacy sync, a full import, a diff-sync and the guarded re-import. Holding it
 * keeps those from overlapping across processes (cron, systemd unit, API, CLI).
 */
export const SYNC_WRITE_LOCK_KEY = 0x61776d72;

// Trophy thresholds (Phase 19). The web copy in web/src/lib/trophies.ts ("10k+", "1,000+", "25%+")
// mirrors these numbers and must change with them. src/trophies/__tests__/web-mirror.spec.ts fails if not.

/** Stars gained in 7 days to earn the "10k+ this week" trophy. */
export const TROPHY_SURGE_HIGH = 10_000;

/** Stars gained in 7 days to earn the "1k+ this week" trophy (below TROPHY_SURGE_HIGH). */
export const TROPHY_SURGE_LOW = 1_000;

/** 7d gain divided by the star count a week ago needed for the "Fast-growing" trophy. */
export const TROPHY_FAST_GROWTH_RATIO = 0.25;

/** Minimum current stars for the "Fast-growing" trophy. */
export const TROPHY_FAST_GROWTH_MIN_STARS = 1_000;
