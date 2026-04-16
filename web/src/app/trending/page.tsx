import { getTrending } from '@/lib/api';
import TrendingClient from './trending-client';

export default async function TrendingPage() {
  const [t7, t30, t90] = await Promise.all([
    getTrending({ period: '7d', limit: 25 }).then((r) => r.data).catch(() => []),
    getTrending({ period: '30d', limit: 25 }).then((r) => r.data).catch(() => []),
    getTrending({ period: '90d', limit: 25 }).then((r) => r.data).catch(() => []),
  ]);

  return <TrendingClient data7d={t7} data30d={t30} data90d={t90} />;
}
