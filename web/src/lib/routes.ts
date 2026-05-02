export function listPath(slug: string): string {
  return `/l/${slug}`;
}

export function repoPath(githubRepo: string): string {
  return `/r/${githubRepo.replace('/', '~')}`;
}
