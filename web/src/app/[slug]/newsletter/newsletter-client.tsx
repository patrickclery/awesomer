'use client';

import { useState, useEffect } from 'react';
import { getAwesomeList, subscribeNewsletter } from '@/lib/api';

export default function NewsletterClient({ slug }: { slug: string }) {
  const [email, setEmail] = useState('');
  const [listId, setListId] = useState<number | null>(null);
  const [listName, setListName] = useState('');
  const [status, setStatus] = useState<
    'idle' | 'loading' | 'success' | 'error'
  >('idle');

  useEffect(() => {
    getAwesomeList(slug)
      .then((res) => {
        setListId(res.data.id);
        setListName(res.data.name);
      })
      .catch(() => {
        // List not found
      });
  }, [slug]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!listId) return;
    setStatus('loading');
    try {
      await subscribeNewsletter(email, listId);
      setStatus('success');
      setEmail('');
    } catch {
      setStatus('error');
    }
  };

  return (
    <div className="max-w-lg">
      <h1 className="text-xl font-bold mb-2">
        $ subscribe --newsletter {listName ? `"${listName}"` : ''}
      </h1>
      <p className="text-muted text-sm mb-6">
        weekly digest of top trending repos. automated, data-driven, no fluff.
      </p>

      {status === 'success' ? (
        <div className="p-3 border border-success text-success text-sm">
          [OK] subscribed. first digest arrives next monday.
        </div>
      ) : (
        <form onSubmit={handleSubmit} className="flex gap-2">
          <div className="flex items-center border border-border flex-1">
            <span className="pl-3 text-muted text-sm">&gt;</span>
            <input
              type="email"
              placeholder="you@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="w-full px-2 py-1.5 bg-transparent text-foreground text-sm placeholder-muted focus:outline-none"
            />
          </div>
          <button
            type="submit"
            disabled={status === 'loading' || !listId}
            className="px-4 py-1.5 border border-accent text-accent text-sm hover:bg-accent hover:text-background transition-colors disabled:opacity-30"
          >
            {status === 'loading' ? 'subscribing...' : '[ subscribe ]'}
          </button>
        </form>
      )}

      {status === 'error' && (
        <p className="text-danger text-xs mt-2">
          [ERR] something went wrong. try again.
        </p>
      )}

      <div className="mt-10">
        <div className="text-muted text-sm mb-3">## past issues</div>
        <p className="text-muted text-xs">no issues published yet.</p>
      </div>
    </div>
  );
}
