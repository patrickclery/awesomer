import { getAwesomeLists } from '@/lib/api';
import NewsletterClient from './newsletter-client';

export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
  return lists.map((list) => ({ slug: list.slug }));
}

export default async function NewsletterPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  return <NewsletterClient slug={slug} />;
}
