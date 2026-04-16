import { generateAsciiBanner, displayName } from '@/lib/ascii-banner';

interface AsciiBannerProps {
  listName: string;
  githubRepo: string;
  description?: string | null;
}

export function AsciiBanner({ listName, githubRepo, description }: AsciiBannerProps) {
  const { text, fontSize } = generateAsciiBanner(listName);

  return (
    <div className="mb-8">
      {/* ASCII banner — desktop */}
      <div className="hidden sm:block mb-3 overflow-hidden">
        <pre
          className="ascii-art text-accent glow-intense"
          style={{ fontSize: `${fontSize}px` }}
        >
          {text}
        </pre>
      </div>

      {/* Mobile fallback */}
      <div className="sm:hidden text-accent glow text-2xl font-bold mb-3">
        {displayName(listName)}
        <span className="cursor-blink">_</span>
      </div>

      {/* Description */}
      {description && (
        <p className="description text-muted text-sm mb-3 sm:mb-0">{description}</p>
      )}

      {/* Attribution */}
      <div className="flex items-center gap-3 font-mono text-sm mt-3">
        <span className="flex-1 h-px bg-accent/20"></span>
        <a
          href={`https://github.com/${githubRepo}`}
          target="_blank"
          rel="noopener noreferrer"
          className="text-muted hover:text-accent transition-colors whitespace-nowrap"
        >
          curated from {githubRepo}
        </a>
        <span className="flex-1 h-px bg-accent/20"></span>
      </div>
    </div>
  );
}
