'use client';

import { useState } from 'react';
import { useParams } from 'next/navigation';
import { subscribeNewsletter } from '@/lib/api';

export default function NewsletterPage() {
  const params = useParams();
  const slug = params.slug as string;
  const [email, setEmail] = useState('');
  const [status, setStatus] = useState<
    'idle' | 'loading' | 'success' | 'error'
  >('idle');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setStatus('loading');
    try {
      // TODO: resolve awesomeListId from slug
      await subscribeNewsletter(email, 1);
      setStatus('success');
      setEmail('');
    } catch {
      setStatus('error');
    }
  };

  return (
    <div className="max-w-lg mx-auto">
      <h1 className="text-2xl font-bold mb-4">Newsletter</h1>
      <p className="text-muted mb-8">
        Get a weekly digest of the top trending repos delivered to your inbox.
        Automated, data-driven, no fluff.
      </p>

      {status === 'success' ? (
        <div className="p-4 bg-success/10 border border-success/20 rounded-lg text-success">
          Subscribed! You&apos;ll get your first digest next Monday.
        </div>
      ) : (
        <form onSubmit={handleSubmit} className="flex gap-3">
          <input
            type="email"
            placeholder="you@example.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            className="flex-1 px-4 py-2 bg-background border border-border rounded-lg text-foreground placeholder-muted focus:outline-none focus:border-accent"
          />
          <button
            type="submit"
            disabled={status === 'loading'}
            className="px-6 py-2 bg-accent text-white rounded-lg hover:bg-accent-hover transition-colors disabled:opacity-50"
          >
            {status === 'loading' ? 'Subscribing...' : 'Subscribe'}
          </button>
        </form>
      )}

      {status === 'error' && (
        <p className="text-danger text-sm mt-3">
          Something went wrong. Please try again.
        </p>
      )}

      <div className="mt-12">
        <h2 className="text-lg font-semibold mb-4">Past Issues</h2>
        <p className="text-muted text-sm">No issues published yet.</p>
      </div>
    </div>
  );
}
