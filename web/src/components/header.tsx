'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState } from 'react';

export function Header() {
  const router = useRouter();
  const [query, setQuery] = useState('');

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (query.trim()) {
      router.push(`/search?q=${encodeURIComponent(query.trim())}`);
    }
  };

  return (
    <header className="border-b border-border bg-background sticky top-0 z-50">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-12">
          <div className="flex items-center gap-6">
            <Link href="/" className="text-accent glow font-bold tracking-tight">
              awesomer<span className="cursor-blink">_</span>
            </Link>
            <nav className="hidden md:flex items-center gap-4 text-sm">
              <Link
                href="/trending"
                className="text-muted hover:text-accent transition-colors"
              >
                /trending
              </Link>
            </nav>
          </div>

          <form onSubmit={handleSearch} className="flex-1 max-w-sm mx-6">
            <div className="flex items-center border border-border bg-background">
              <span className="pl-3 text-muted text-sm">&gt;</span>
              <input
                type="text"
                placeholder="search..."
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                className="w-full px-2 py-1.5 bg-transparent text-foreground text-sm placeholder-muted focus:outline-none"
              />
            </div>
          </form>

          <div className="flex items-center gap-4 text-sm">
            <a
              href="https://github.com/patrickclery/awesomer"
              target="_blank"
              rel="noopener noreferrer"
              className="text-muted hover:text-accent transition-colors"
            >
              [github]
            </a>
          </div>
        </div>
      </div>
    </header>
  );
}
