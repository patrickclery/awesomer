'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { LineChart } from 'lucide-react';
import { GitHubIcon } from '@/components/github-icon';

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
    <header className="border-b border-border bg-background/80 backdrop-blur-sm sticky top-0 z-50">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-12">
          <div className="flex items-center gap-6">
            <Link href="/" className="text-accent glow-intense font-bold tracking-tight">
              awesomer<span className="cursor-blink">_</span>
            </Link>
          </div>

          <form onSubmit={handleSearch} className="flex-1 max-w-sm mx-6">
            <div className="flex items-center border border-border bg-surface/50 hover:border-accent/40 focus-within:border-accent/60 transition-colors rounded-sm">
              <span className="pl-3 text-accent text-sm">&gt;</span>
              <input
                type="text"
                placeholder="search repos..."
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                className="w-full px-2 py-1.5 bg-transparent text-foreground text-sm placeholder-muted/60 focus:outline-none"
              />
            </div>
          </form>

          <div className="flex items-center gap-4 text-sm">
            <Link
              href="/trending"
              aria-label="Trending"
              className="text-muted hover:text-accent transition-colors hidden sm:block"
            >
              <LineChart size={18} aria-hidden="true" />
            </Link>
            <a
              href="https://github.com/patrickclery/awesomer"
              target="_blank"
              rel="noopener noreferrer"
              aria-label="GitHub"
              className="text-muted hover:text-accent transition-colors hidden sm:block"
            >
              <GitHubIcon size={18} />
            </a>
          </div>
        </div>
      </div>
    </header>
  );
}
