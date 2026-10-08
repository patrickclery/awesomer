import type { Metadata } from 'next';
import { Geist_Mono, IBM_Plex_Sans } from 'next/font/google';
import localFont from 'next/font/local';
import { Header } from '@/components/header';
import './globals.css';

const geistMono = Geist_Mono({
  variable: '--font-geist-mono',
  subsets: ['latin'],
});

// Self-hosted subset (ASCII + U+2500-259F) used for the figlet banners.
// System monospace fonts cannot be trusted here: in DejaVu Sans Mono and
// Liberation Mono the FULL BLOCK glyph is narrower than the cell, and Firefox
// honours that real advance (Chromium forces the monospace width), so each
// row of the ASCII art shifts by a different amount and the banner jumbles.
// Shipping one font whose block/box glyphs share the Latin advance removes
// all system font variance.
const asciiMono = localFont({
  src: './fonts/ascii-mono.woff2',
  variable: '--font-ascii',
  display: 'block',
});

const ibmPlexSans = IBM_Plex_Sans({
  variable: '--font-description',
  subsets: ['latin'],
  weight: ['400', '500', '600'],
  style: ['normal', 'italic'],
  display: 'swap',
});

// basePath ('/awesomer' on gh-pages, '' locally). Next prefixes file-convention
// assets (opengraph-image, icon, ...) with basePath itself, so metadataBase must be
// the bare origin — a '/awesomer/' path here would double the prefix in og:image.
// The public/ manifest is NOT prefixed by Next, so it is prefixed manually.
const basePath = process.env.BASE_PATH || '';

// Umami analytics (D-11). Read at build time; the tag is only emitted when both
// values are configured so builds without them never point visitors at a dead host.
const umamiScriptUrl = process.env.NEXT_PUBLIC_UMAMI_SCRIPT_URL;
const umamiWebsiteId = process.env.NEXT_PUBLIC_UMAMI_WEBSITE_ID;

export const metadata: Metadata = {
  metadataBase: new URL('https://patrickclery.com'),
  title: {
    default: 'awesomer — Trending GitHub repos, organized by awesome-list',
    template: '%s | awesomer',
  },
  description:
    'Trending GitHub repos, organized by awesome-list. 7d / 30d / 90d star deltas across curated awesome-lists.',
  manifest: `${basePath}/manifest.webmanifest`,
  openGraph: {
    title: 'awesomer — Trending GitHub repos, organized by awesome-list',
    description: 'Trending GitHub repos, organized by awesome-list.',
    url: 'https://patrickclery.com/awesomer/',
    siteName: 'awesomer',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'awesomer — Trending GitHub repos, organized by awesome-list',
    description: 'Trending GitHub repos, organized by awesome-list.',
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark">
      <head>
        {umamiScriptUrl && umamiWebsiteId && (
          <script async defer src={umamiScriptUrl} data-website-id={umamiWebsiteId} />
        )}
      </head>
      <body
        className={`${geistMono.variable} ${ibmPlexSans.variable} ${asciiMono.variable} antialiased bg-background text-foreground`}
      >
        <Header />
        <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-2">
          {children}
        </main>
      </body>
    </html>
  );
}
