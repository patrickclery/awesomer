# frozen_string_literal: true

require 'net/http'
require 'json'

class BackfillStarSnapshotsOperation
  include Dry::Monads[:result]

  OSSINSIGHT_BASE_URL = 'https://api.ossinsight.io/v1'

  def call(github_repo:)
    repo = Repo.find_by(github_repo: github_repo)
    return Failure("Repo not found in database: #{github_repo}") unless repo

    rows = fetch_star_history(github_repo)
    return Failure("No star history data returned for #{github_repo}") if rows.empty?

    snapshots_created = create_snapshots(repo, rows)

    repo.update!(star_history_fetched_at: Time.current)

    Success("Backfilled #{snapshots_created} snapshots for #{github_repo}")
  rescue StandardError => e
    Rails.logger.error "BackfillStarSnapshotsOperation error: #{e.message}"
    Failure("Backfill failed: #{e.message}")
  end

  private

  def fetch_star_history(github_repo)
    uri = URI("#{OSSINSIGHT_BASE_URL}/repos/#{github_repo}/stargazers/history?per=day")

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(Net::HTTP::Get.new(uri))
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise "OSSInsight API returned #{response.code}: #{response.body}"
    end

    parsed = JSON.parse(response.body)
    parsed.dig('data', 'rows') || []
  end

  def create_snapshots(repo, rows)
    count = 0

    rows.each do |row|
      date = Date.parse(row['date'])
      stars = row['stargazers'].to_i

      snapshot = StarSnapshot.find_or_initialize_by(repo: repo, snapshot_date: date)
      snapshot.stars = stars
      snapshot.save!
      count += 1
    end

    count
  end
end
