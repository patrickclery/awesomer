import type { Metadata } from 'next';

// basePath ('/awesomer' on gh-pages, '' locally). Next prefixes basePath onto
// file-convention metadata assets itself, but NOT onto openGraph.url,
// alternates.canonical or explicitly listed image URLs — those are prefixed here
// and then resolved against the root layout's metadataBase (https://patrickclery.com).
const basePath = process.env.BASE_PATH || '';

export const SITE_NAME = 'awesomer';
export const SITE_TAGLINE = 'Trending GitHub repos, organized by awesome-list';

interface PageMetadataInput {
  /** Page title. The root layout template appends " | awesomer" unless `absoluteTitle`. */
  title: string;
  description: string;
  /** Route path without basePath, with trailing slash (trailingSlash: true), e.g. '/l/go/'. */
  path: string;
  absoluteTitle?: boolean;
}

/**
 * Per-route metadata so every page emits its own <title>, description,
 * canonical and og:url instead of inheriting the homepage values.
 *
 * A child `openGraph` / `twitter` object replaces the parent's wholesale —
 * including the root opengraph-image.png / twitter-image.png file-convention
 * images — so siteName, type, card and images are re-specified here.
 */
export function pageMetadata({ title, description, path, absoluteTitle = false }: PageMetadataInput): Metadata {
  const url = `${basePath}${path}`;
  const socialTitle = absoluteTitle ? title : `${title} | ${SITE_NAME}`;

  return {
    title: absoluteTitle ? { absolute: title } : title,
    description,
    alternates: { canonical: url },
    openGraph: {
      title: socialTitle,
      description,
      url,
      siteName: SITE_NAME,
      type: 'website',
      images: [{ url: `${basePath}/opengraph-image.png`, width: 1200, height: 630, type: 'image/png' }],
    },
    twitter: {
      card: 'summary_large_image',
      title: socialTitle,
      description,
      images: [{ url: `${basePath}/twitter-image.png`, width: 1200, height: 630, type: 'image/png' }],
    },
  };
}
