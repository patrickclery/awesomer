import { getAwesomeLists, getFeatured, type FeaturedProfile } from '@/lib/api';

export async function generateStaticParams() {
  const { data: lists } = await getAwesomeLists();
  return lists.map((list) => ({ slug: list.slug }));
}

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
      <h1 className="text-xl font-bold mb-6">$ featured --profiles</h1>

      {profiles.length > 0 ? (
        <div className="space-y-2">
          {profiles.map((profile) => (
            <div
              key={profile.id}
              className="p-4 border border-border hover:border-muted transition-colors"
            >
              <div className="flex items-start gap-4">
                {profile.avatarUrl && (
                  <img
                    src={profile.avatarUrl}
                    alt={profile.name}
                    className="w-12 h-12 grayscale hover:grayscale-0 transition-all"
                  />
                )}
                <div>
                  <div className="flex items-center gap-2">
                    <h3 className="font-bold">{profile.name}</h3>
                    <span className="text-xs text-muted border border-border px-1.5 py-0.5">
                      {profile.profileType.replace('_', ' ')}
                    </span>
                  </div>
                  {profile.bio && (
                    <p className="text-muted text-xs mt-1">{profile.bio}</p>
                  )}
                  <div className="flex gap-3 mt-2 text-xs">
                    {profile.githubHandle && (
                      <a
                        href={`https://github.com/${profile.githubHandle}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-muted hover:text-accent transition-colors"
                      >
                        [github]
                      </a>
                    )}
                    {profile.twitterHandle && (
                      <a
                        href={`https://twitter.com/${profile.twitterHandle}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-muted hover:text-accent transition-colors"
                      >
                        [twitter]
                      </a>
                    )}
                    {profile.website && (
                      <a
                        href={profile.website}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-muted hover:text-accent transition-colors"
                      >
                        [web]
                      </a>
                    )}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="py-8 text-muted text-sm">
          no featured profiles yet.
        </div>
      )}
    </div>
  );
}
