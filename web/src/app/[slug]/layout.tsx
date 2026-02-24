import { getAwesomeLists, getAwesomeList } from '@/lib/api';
import { getTheme, themeToStyle } from '@/lib/themes';

export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
  return lists.map((list) => ({ slug: list.slug }));
}

export default async function SlugLayout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;

  let themeName = 'claude';
  try {
    const { data: list } = await getAwesomeList(slug);
    themeName = list.theme ?? 'claude';
  } catch {
    // List not found — default theme will be used
  }

  const theme = getTheme(themeName);

  return (
    <div style={themeToStyle(theme)}>
      {children}
    </div>
  );
}
