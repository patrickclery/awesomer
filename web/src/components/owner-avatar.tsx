'use client';

import { useState } from 'react';
import { GitHubIcon } from '@/components/github-icon';

interface OwnerAvatarProps {
  owner: string;
  size: number;
  className?: string;
}

export function OwnerAvatar({ owner, size, className = '' }: OwnerAvatarProps) {
  const [hasError, setHasError] = useState(false);

  if (hasError) {
    return <GitHubIcon size={size} className={`avatar avatar-fallback ${className}`} />;
  }

  return (
    /* eslint-disable-next-line @next/next/no-img-element -- D-03: static export with images.unoptimized, next/image adds no value */
    <img
      src={`https://github.com/${owner}.png?size=${size * 2}`}
      alt={`${owner} avatar`}
      width={size}
      height={size}
      loading="lazy"
      onError={() => setHasError(true)}
      className={`avatar ${className}`}
    />
  );
}
