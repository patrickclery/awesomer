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
      {/* Claude Code status bar */}
      <div className="flex items-stretch text-xs font-mono overflow-hidden" style={{ backgroundColor: '#1a1b2e', minHeight: '28px' }}>
        <div
          className="flex items-center px-3 font-bold text-white shrink-0"
          style={{
            backgroundColor: '#c96a2b',
            clipPath: 'polygon(0 0, calc(100% - 8px) 0, 100% 50%, calc(100% - 8px) 100%, 0 100%)',
            paddingRight: '18px',
          }}
        >
          ~/awesomer
        </div>
        <div className="flex items-center px-3 py-1.5 hidden sm:flex" style={{ color: '#cdd6f4' }}>
          git ⌐main (~5 ?1) ●
        </div>
        <div className="flex items-center px-3 py-1.5 ml-auto" style={{ color: '#a6adc8' }}>
          ⊙ 47,018 (69%)
        </div>
      </div>

      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-12">
          <div className="flex items-center gap-6">
            <Link href="/" className="text-accent glow-intense font-bold tracking-tight">
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
            <div className="flex items-center border border-border bg-background hover:border-accent/40 transition-colors">
              <span className="pl-3 text-accent text-sm">&gt;</span>
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
