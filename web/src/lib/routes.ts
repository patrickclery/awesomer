export function listPath(slug: string): string {
  return `/l/${slug}`;
}

export function listAllPath(slug: string): string {
  return `/l/${slug}/all`;
}

export function repoPath(githubRepo: string): string {
  return `/r/${githubRepo.replace('/', '~')}`;
}
