import { Suspense } from 'react';
import { getAwesomeLists } from '@/lib/api';
import ReposClient from './repos-client';

export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
  return lists.map((list) => ({ slug: list.slug }));
}

export default async function ReposPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  return (
    <Suspense fallback={<div className="text-center py-12 text-muted">Loading...</div>}>
      <ReposClient slug={slug} />
    </Suspense>
  );
}
