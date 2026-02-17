import { getFeatured, type FeaturedProfile } from '@/lib/api';

interface Props {
  params: Promise<{ slug: string }>;
}

export default async function FeaturedPage({ params }: Props) {
  const { slug } = await params;
  let profiles: FeaturedProfile[] = [];

  try {
    const response = await getFeatured(slug);
    profiles = response.data;
  } catch {
    // API not available
  }

  return (
    <div>
      <h1 className="text-2xl font-bold mb-8">Featured Profiles</h1>

      {profiles.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {profiles.map((profile) => (
            <div
              key={profile.id}
              className="p-6 bg-surface border border-border rounded-lg"
            >
              <div className="flex items-start gap-4">
                {profile.avatarUrl && (
                  <img
                    src={profile.avatarUrl}
                    alt={profile.name}
                    className="w-16 h-16 rounded-full"
                  />
                )}
                <div>
                  <h3 className="font-semibold text-lg">{profile.name}</h3>
                  <span className="text-xs text-muted px-2 py-0.5 bg-background rounded-full">
                    {profile.profileType.replace('_', ' ')}
                  </span>
                  {profile.bio && (
                    <p className="text-muted text-sm mt-2">{profile.bio}</p>
                  )}
                  <div className="flex gap-3 mt-3 text-sm">
                    {profile.githubHandle && (
                      <a
                        href={`https://github.com/${profile.githubHandle}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-accent hover:underline"
                      >
                        GitHub
                      </a>
                    )}
                    {profile.twitterHandle && (
                      <a
                        href={`https://twitter.com/${profile.twitterHandle}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-accent hover:underline"
                      >
                        Twitter
                      </a>
                    )}
                    {profile.website && (
                      <a
                        href={profile.website}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-accent hover:underline"
                      >
                        Website
                      </a>
                    )}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="text-center py-12 text-muted">
          No featured profiles yet.
        </div>
      )}
    </div>
  );
}
