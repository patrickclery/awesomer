# frozen_string_literal: true

class SnapshotStarsOperation
  include Dry::Monads[:result]

  BATCH_SIZE = 100

  def call
    repos = Repo.where.not(github_repo: [nil, '']).order(:id)
    total = repos.count
    return Success("No repos to snapshot") if total.zero?

    rate_limiter = GithubRateLimiterService.new
    client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
    snapshotted = 0
    skipped = 0
    batch_number = 0

    repos.in_batches(of: BATCH_SIZE) do |batch|
      batch_number += 1
      batch_repos = batch.to_a

      rate_limiter.wait_if_needed

      query = build_graphql_query(batch_repos)
      response = client.post('/graphql', { query: query }.to_json)

      data = response.is_a?(Hash) ? response['data'] : response.data

      batch_repos.each_with_index do |repo, index|
        repo_data = data["repo#{index}"]

        if repo_data.nil?
          skipped += 1
          Rails.logger.warn "SnapshotStarsOperation: Repo not found: #{repo.github_repo}"
          next
        end

        stars = repo_data['stargazerCount']
        pushed_at = repo_data['pushedAt']

        snapshot = StarSnapshot.find_or_initialize_by(repo: repo, snapshot_date: Date.current)
        snapshot.stars = stars
        snapshot.save!

        repo.update!(
          stars: stars,
          last_commit_at: pushed_at ? Time.parse(pushed_at) : nil
        )

        snapshotted += 1
      end

      GithubApiRequest.create!(
        endpoint: 'graphql',
        requested_at: Time.current,
        response_status: 200,
        owner: 'batch',
        repo: "batch_#{batch_number}"
      )

      Rails.logger.info "SnapshotStarsOperation: Batch #{batch_number} complete (#{snapshotted}/#{total})"
    end

    Success("Snapshotted #{snapshotted} repos, skipped #{skipped}")
  rescue StandardError => e
    Rails.logger.error "SnapshotStarsOperation error: #{e.message}"
    Failure("Snapshot failed: #{e.message}")
  end

  private

  def build_graphql_query(repos)
    fields = repos.each_with_index.map do |repo, index|
      owner, name = repo.github_repo.split('/', 2)
      next nil unless owner && name

      "repo#{index}: repository(owner: \"#{owner}\", name: \"#{name}\") { stargazerCount pushedAt }"
    end.compact

    "query { #{fields.join(' ')} }"
  end
end
