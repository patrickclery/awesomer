const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000/api';

interface PaginatedResponse<T> {
  data: T[];
  meta: {
    total: number;
    page: number;
    per_page: number;
    total_pages: number;
  };
}

interface SingleResponse<T> {
  data: T;
}

async function fetchApi<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options?.headers,
    },
  });

  if (!res.ok) {
    throw new Error(`API error: ${res.status} ${res.statusText}`);
  }

  return res.json() as Promise<T>;
}

// Types
export interface AwesomeList {
  id: number;
  name: string;
  slug: string;
  description: string | null;
  githubRepo: string;
  state: string;
  lastSyncedAt: string | null;
  _count?: {
    categories: number;
  };
}

export interface Category {
  id: number;
  name: string;
  slug: string;
  _count?: {
    categoryItems: number;
  };
}

export interface Repo {
  id: number;
  githubRepo: string;
  description: string | null;
  stars: number | null;
  stars7d: number | null;
  stars30d: number | null;
  stars90d: number | null;
  lastCommitAt: string | null;
}

export interface CategoryItem {
  id: number;
  name: string | null;
  description: string | null;
  githubDescription: string | null;
  primaryUrl: string | null;
  githubRepo: string | null;
  stars: number | null;
  lastCommitAt: string | null;
  category: {
    id: number;
    name: string;
    slug: string;
  };
  repo: {
    stars7d: number | null;
    stars30d: number | null;
    stars90d: number | null;
  } | null;
}

export interface FeaturedProfile {
  id: number;
  name: string;
  avatarUrl: string | null;
  bio: string | null;
  githubHandle: string | null;
  twitterHandle: string | null;
  website: string | null;
  profileType: string;
  featuredDate: string;
  awesomeList: {
    id: number;
    name: string;
    slug: string;
  };
}

export interface StarHistoryPoint {
  snapshotDate: string;
  stars: number;
}

// API functions
export async function getAwesomeLists() {
  return fetchApi<SingleResponse<AwesomeList[]>>('/awesome-lists');
}

export async function getAwesomeList(slug: string) {
  return fetchApi<SingleResponse<AwesomeList & { categories: Category[] }>>(
    `/awesome-lists/${slug}`,
  );
}

export async function getReposByList(
  slug: string,
  params?: {
    sort?: string;
    category?: string;
    search?: string;
    min_stars?: number;
    page?: number;
    per_page?: number;
  },
) {
  const searchParams = new URLSearchParams();
  if (params) {
    Object.entries(params).forEach(([key, value]) => {
      if (value !== undefined) searchParams.set(key, String(value));
    });
  }
  const query = searchParams.toString();
  return fetchApi<PaginatedResponse<CategoryItem>>(
    `/awesome-lists/${slug}/repos${query ? `?${query}` : ''}`,
  );
}

export async function getRepo(id: number) {
  return fetchApi<SingleResponse<Repo>>(`/repos/${id}`);
}

export async function getStarHistory(repoId: number) {
  return fetchApi<SingleResponse<StarHistoryPoint[]>>(
    `/repos/${repoId}/star-history`,
  );
}

export async function getTrending(params?: {
  period?: '7d' | '30d' | '90d';
  limit?: number;
}) {
  const searchParams = new URLSearchParams();
  if (params?.period) searchParams.set('period', params.period);
  if (params?.limit) searchParams.set('limit', String(params.limit));
  const query = searchParams.toString();
  return fetchApi<SingleResponse<Repo[]>>(
    `/trending${query ? `?${query}` : ''}`,
  );
}

export async function getTrendingByList(
  slug: string,
  params?: { period?: '7d' | '30d' | '90d'; limit?: number },
) {
  const searchParams = new URLSearchParams();
  if (params?.period) searchParams.set('period', params.period);
  if (params?.limit) searchParams.set('limit', String(params.limit));
  const query = searchParams.toString();
  return fetchApi<SingleResponse<Repo[]>>(
    `/trending/${slug}${query ? `?${query}` : ''}`,
  );
}

export async function getFeatured(listSlug?: string) {
  const query = listSlug ? `?list=${listSlug}` : '';
  return fetchApi<SingleResponse<FeaturedProfile[]>>(`/featured${query}`);
}

export async function subscribeNewsletter(
  email: string,
  awesomeListId: number,
) {
  return fetchApi<SingleResponse<{ subscribed: boolean; id: number }>>(
    '/newsletter/subscribe',
    {
      method: 'POST',
      body: JSON.stringify({ email, awesome_list_id: awesomeListId }),
    },
  );
}
