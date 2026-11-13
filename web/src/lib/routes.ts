export function listPath(slug: string): string {
  return `/l/${slug}`;
}

/** URL slug for a repo's /r/ page: `owner/repo` -> `owner~repo`. */
export function repoSlug(githubRepo: string): string {
  return githubRepo.replace('/', '~');
}

export function repoPath(githubRepo: string): string {
  return `/r/${repoSlug(githubRepo)}`;
}
