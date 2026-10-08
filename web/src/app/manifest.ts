import type { MetadataRoute } from 'next';

// Statically generated at build time (output: 'export') to /manifest.webmanifest.
// Next prefixes basePath onto the <link rel="manifest"> href itself, but not onto
// URLs inside the manifest body, so start_url/scope/icons are prefixed here:
// '/awesomer/...' on gh-pages, '/...' for local builds without BASE_PATH.
export const dynamic = 'force-static';

const basePath = process.env.BASE_PATH || '';

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: 'awesomer',
    short_name: 'awesomer',
    description: 'Trending GitHub repos, organized by awesome-list',
    start_url: `${basePath}/`,
    scope: `${basePath}/`,
    display: 'standalone',
    background_color: '#1e1e2e',
    theme_color: '#1e1e2e',
    icons: [
      { src: `${basePath}/icon-192.png`, sizes: '192x192', type: 'image/png', purpose: 'any' },
      { src: `${basePath}/icon-512.png`, sizes: '512x512', type: 'image/png', purpose: 'any' },
      { src: `${basePath}/icon-512.png`, sizes: '512x512', type: 'image/png', purpose: 'maskable' },
    ],
  };
}
