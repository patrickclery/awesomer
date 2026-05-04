import { GitHubIcon } from '@/components/github-icon';

interface ExternalGitHubLinkProps {
  githubRepo: string;     // "owner/repo" form (e.g. "facebook/react")
  size?: number;
  label: string;          // aria-label, e.g. "react on GitHub"
  className?: string;
}

export function ExternalGitHubLink({
  githubRepo,
  size = 16,
  label,
  className = 'text-muted group-hover:text-foreground transition-colors cursor-pointer rounded focus-visible:outline-2 focus-visible:outline-accent',
}: ExternalGitHubLinkProps) {
  return (
    <a
      href={`https://github.com/${githubRepo}`}
      target="_blank"
      rel="noopener noreferrer"
      aria-label={label}
      className={`inline-flex items-center ${className}`}
    >
      <GitHubIcon size={size} />
    </a>
  );
}
