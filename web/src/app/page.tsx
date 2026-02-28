import Link from 'next/link';
import { getAwesomeLists } from '@/lib/api';

const ASCII_BANNER = ` █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗██████╗
██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝██╔══██╗
███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗  ██████╔╝
██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝  ██╔══██╗
██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗██║  ██║
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝`;

const VIBE_TASKS = [
  'Fetch star snapshots from GitHub API',
  'Parse awesome list markdown → extract repos',
  'Compute trending deltas (7d / 30d / 90d)',
  'Render static site output',
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
          <pre className="ascii-art text-accent glow-intense glitch">{ASCII_BANNER}</pre>
        </div>

        {/* Mobile fallback */}
        <div className="sm:hidden text-accent glow text-2xl font-bold mb-4">
          awesomer<span className="cursor-blink">_</span>
        </div>

        {/* Vibe coding panel — meta joke: this site was built by Claude Code */}
        <div className="mb-6 overflow-hidden text-xs font-mono" style={{ backgroundColor: '#1a1b2e', border: '1px solid #2a2d3e' }}>
          {/* Status bar row 1 — Claude Code prompt style */}
          <div className="flex items-stretch" style={{ backgroundColor: '#1a1b2e', minHeight: '28px' }}>
            <div
              className="flex items-center px-3 font-bold text-white"
              style={{
                backgroundColor: '#c96a2b',
                clipPath: 'polygon(0 0, calc(100% - 8px) 0, 100% 50%, calc(100% - 8px) 100%, 0 100%)',
                paddingRight: '18px',
              }}
            >
              ~/awesomer
            </div>
            <div className="flex items-center px-3 py-1.5" style={{ color: '#cdd6f4' }}>
              git ⌐main (~5 ?1) ●
            </div>
            <div className="flex items-center px-3 py-1.5 ml-auto" style={{ color: '#a6adc8' }}>
              ⊙ 47,018 (69%)
            </div>
          </div>
          {/* Status bar row 2 */}
          <div className="px-2 py-0.5" style={{ borderBottom: '1px solid #2a2d3e' }}>
            <span style={{ color: '#f38ba8' }}>►► bypass permissions on</span>
            <span style={{ color: '#585b70' }}> (shift+tab to cycle)</span>
          </div>
          {/* Command prompt */}
          <div className="px-3 py-2">
            <span style={{ color: '#585b70' }}>&gt; </span>
            <span style={{ color: '#c96a2b' }}>/execute-plan</span>
            <span style={{ color: '#cdd6f4' }}> build-trending-repo-rankings-from-awesome-lists.md</span>
            <span className="cursor-blink" style={{ color: '#cdd6f4' }}>█</span>
          </div>
          {/* Task list */}
          <div className="px-3 pb-3">
            <div className="mb-1.5" style={{ color: '#585b70' }}>● TodoWrite</div>
            {VIBE_TASKS.map((task) => (
              <div key={task} className="pl-2 leading-relaxed">
                <span style={{ color: '#00ff41' }}>✓ </span>
                <span style={{ color: '#cdd6f4' }}>{task}</span>
              </div>
            ))}
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
