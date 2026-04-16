/** Repos with fewer stars than this are excluded from all listings and trending. */
export const MIN_STARS = 100;

/**
 * The slug of the "awesome" meta-list (sindresorhus/awesome).
 * This list catalogs awesome lists, so cross-references should NOT be filtered from it.
 */
export const META_AWESOME_LIST_SLUG = 'awesome';

/**
 * GitHub stargazers API returns 100 per page, max 400 pages = 40,000 stars.
 * Repos above this limit get truncated history (most recent 40k stargazers).
 */
export const MAX_STARGAZER_PAGES = 400;

/** Repos whose last commit is older than this many days are excluded from individual repo pages. */
export const STALE_DAYS = 365;
