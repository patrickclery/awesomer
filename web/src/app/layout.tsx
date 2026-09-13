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

export const metadata: Metadata = {
  title: 'awesomer — trending open source tools',
  description:
    'Data-driven discovery of trending open-source tools. GitHub stars are the signal.',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark">
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
