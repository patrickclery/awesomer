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
