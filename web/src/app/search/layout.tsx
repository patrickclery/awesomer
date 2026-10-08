import type { Metadata } from 'next';
import { pageMetadata } from '@/lib/metadata';

// search/page.tsx is a client component and cannot export metadata itself.
export const metadata: Metadata = pageMetadata({
  title: 'Search',
  description: 'Search trending GitHub repos across every awesome-list on awesomer.',
  path: '/search/',
});

export default function SearchLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
