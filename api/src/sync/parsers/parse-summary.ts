import type { ParseResult } from './readme-parser.interface.js';

/**
 * Matches badge or image markup left in a description: the image opener `![`
 * or the shields.io host. Non-global, so `.test()` carries no lastIndex state.
 */
export const BADGE_MARKUP_RE = /!\[|img\.shields\.io/;

/**
 * Matches a category name that still carries a section number, optionally
 * behind leading emoji or punctuation: `1. Core Frameworks & Libraries` and
 * `🖥️ 12. User Interfaces & Self-hosted Platforms` match; `3D Generation` and
 * `Deep Learning Frameworks` do not.
 */
export const NUMBERED_NAME_RE = /^[^\p{L}\d]*\d+\.\s/u;

/** Counts that describe the quality of one ParseResult. */
export interface ParseSummary {
  categories: number;
  items: number;
  uniqueUrls: number;
  nullDescriptions: number;
  badgeDescriptions: number;
  numberedCategories: number;
  emptyCategories: number;
}

/**
 * Summarizes a ParseResult: totals, distinct primary URLs, NULL and
 * badge-contaminated descriptions, numbered category names, and categories
 * whose `order` no item's `categoryIndex` references.
 */
export function summarizeParseResult(result: ParseResult): ParseSummary {
  const referenced = new Set(result.items.map((item) => item.categoryIndex));
  return {
    categories: result.categories.length,
    items: result.items.length,
    uniqueUrls: new Set(result.items.map((item) => item.primaryUrl)).size,
    nullDescriptions: result.items.filter((item) => item.description === null)
      .length,
    badgeDescriptions: result.items.filter(
      (item) =>
        item.description !== null && BADGE_MARKUP_RE.test(item.description),
    ).length,
    numberedCategories: result.categories.filter((category) =>
      NUMBERED_NAME_RE.test(category.name),
    ).length,
    emptyCategories: result.categories.filter(
      (category) => !referenced.has(category.order),
    ).length,
  };
}
