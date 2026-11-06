import type { ComponentPropsWithoutRef } from 'react';

const BASE_PATH = process.env.NEXT_PUBLIC_BASE_PATH ?? '';

/** Turns an internal path into the deployed URL: base path, trailing slash, query and hash intact. */
export function siteHref(href: string): string {
  if (!href.startsWith('/') || href.startsWith('//')) return href;

  const suffixStart = href.search(/[?#]/);
  const path = suffixStart === -1 ? href : href.slice(0, suffixStart);
  const suffix = suffixStart === -1 ? '' : href.slice(suffixStart);

  return `${BASE_PATH}${path.endsWith('/') ? path : `${path}/`}${suffix}`;
}

type SiteLinkProps = Omit<ComponentPropsWithoutRef<'a'>, 'href'> & { href: string };

// The deploy omits the framework's payload files, so a plain anchor is the only navigation that does not issue a failing fetch.
export default function SiteLink({ href, ...props }: SiteLinkProps) {
  return <a href={siteHref(href)} {...props} />;
}
