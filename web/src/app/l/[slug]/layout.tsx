import { getStaticLists } from '@/lib/static-data';

export async function generateStaticParams() {
  const { data: lists } = getStaticLists();
  return lists.map((list) => ({ slug: list.slug }));
}

export default async function SlugLayout({
  children,
}: {
  children: React.ReactNode;
  params: Promise<{ slug: string }>;
}) {
  return <>{children}</>;
}
