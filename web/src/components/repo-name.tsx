interface RepoNameProps {
  name: string;
  className?: string;
}

export function RepoName({ name, className }: RepoNameProps) {
  const slashIndex = name.indexOf('/');
  const displayName = slashIndex === -1 ? name : name.slice(slashIndex + 1);

  return <span className={className}>{displayName}</span>;
}
