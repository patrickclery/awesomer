import type { Metadata } from 'next';
import { Geist_Mono, IBM_Plex_Sans } from 'next/font/google';
import { Header } from '@/components/header';
import './globals.css';

const geistMono = Geist_Mono({
  variable: '--font-geist-mono',
  subsets: ['latin'],
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
        className={`${geistMono.variable} ${ibmPlexSans.variable} antialiased bg-background text-foreground`}
      >
        <Header />
        <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-2">
          {children}
        </main>
      </body>
    </html>
  );
}
