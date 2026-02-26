import Link from 'next/link';
import { getAwesomeLists } from '@/lib/api';

const ASCII_BANNER = ` █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗██████╗
██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝██╔══██╗
███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗  ██████╔╝
██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝  ██╔══██╗
██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗██║  ██║
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝`;

const BOOT_SEQUENCE = [
  { label: 'Connecting to github.com', status: 'OK' },
  { label: 'Loading star snapshot data', status: 'OK' },
  { label: 'Parsing awesome lists', status: 'OK' },
  { label: 'Computing trending deltas', status: 'OK' },
  { label: 'Rendering static output', status: 'OK' },
];

export default async function HomePage() {
  let lists: Awaited<ReturnType<typeof getAwesomeLists>>['data'] = [];

  try {
    const response = await getAwesomeLists();
    lists = response.data;
  } catch {
    // API not available yet — show placeholder
  }

  return (
    <div>
      <section className="py-8">

        {/* ASCII Banner — desktop */}
        <div className="hidden sm:block mb-6 overflow-x-auto">
          <pre className="ascii-art text-accent glow-intense glitch">
            {ASCII_BANNER}
          </pre>
        </div>

        {/* Mobile fallback */}
        <div className="sm:hidden text-accent glow text-2xl font-bold mb-4">
          awesomer<span className="cursor-blink">_</span>
        </div>

        {/* Boot sequence block */}
        <div className="border border-border bg-surface p-4 mb-6 text-xs font-mono space-y-1">
          <div className="text-muted mb-2">
            ┌─ awesomer-engine v2.0.0 ── boot sequence ─────────────────────────────┐
          </div>
          {BOOT_SEQUENCE.map(({ label, status }) => (
            <div key={label} className="flex gap-2 pl-2">
              <span className="text-muted flex-1">{label.padEnd(42, '.')}</span>
              <span className="text-success">[{status}]</span>
            </div>
          ))}
          <div className="text-muted mt-2">
            └────────────────────────────────────────────────────────────────────────┘
          </div>
          <div className="pt-1 flex flex-wrap gap-6 pl-2">
            <span>
              <span className="text-accent">SIGNAL</span>
              <span className="text-muted">........</span>
              <span className="text-foreground">★ stars only. no votes.</span>
            </span>
            <span>
              <span className="text-accent">VERTICALS</span>
              <span className="text-muted">......</span>
              <span className="text-success">{lists.length || '…'} loaded</span>
            </span>
            <span>
              <span className="text-accent">STATUS</span>
              <span className="text-muted">.........</span>
              <span className="text-success glow-pulse">■ ONLINE</span>
            </span>
          </div>
        </div>

        <div className="text-accent glow text-sm mb-2">$ cat README.md</div>
        <h1 className="text-2xl font-bold mb-3 text-foreground">
          discover trending open-source tools
        </h1>
        <p className="text-muted text-sm max-w-xl">
          powered by real github data. no votes, no hype — just stars.
        </p>
      </section>

      <section>
        <div className="text-muted text-sm mb-4">
          ## verticals ({lists.length})
        </div>
        {lists.length > 0 ? (
          <div className="space-y-1">
            {lists.map((list) => (
              <Link
                key={list.id}
                href={`/${list.slug}`}
                className="block py-2 px-3 border border-transparent hover:border-border hover:bg-surface transition-colors group"
              >
                <div className="flex items-center gap-3">
                  <span className="text-muted group-hover:text-accent">&gt;</span>
                  <span className="text-foreground group-hover:text-accent font-medium">
                    {list.name}
                  </span>
                  {list._count && (
                    <span className="text-muted text-xs">
                      [{list._count.categories} categories]
                    </span>
                  )}
                </div>
                {list.description && (
                  <p className="text-muted text-xs ml-6 mt-0.5 truncate">
                    {list.description}
                  </p>
                )}
              </Link>
            ))}
          </div>
        ) : (
          <div className="py-8 text-muted text-sm">
            <span className="text-danger">[ERR]</span> no verticals available. connect the API to get started.
          </div>
        )}
      </section>
    </div>
  );
}
