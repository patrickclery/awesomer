# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BackfillStarSnapshotsOperation do
  include Test::Support::VCR

  subject(:operation) { described_class.new }

  describe '#call' do
    context 'when OSSInsight returns star history' do
      let!(:repo) { create(:repo, github_repo: 'hesreallyhim/awesome-claude-code', stars: nil) }

      example 'creates star snapshots from OSSInsight data' do
        vcr('ossinsight', 'hesreallyhim_awesome_claude_code', record: :new_episodes) do
          result = operation.call(github_repo: 'hesreallyhim/awesome-claude-code')

          expect(result).to be_success
          expect(result.value!).to match(/Backfilled \d+ snapshots/)

          snapshots = StarSnapshot.where(repo: repo).order(:snapshot_date)
          expect(snapshots.count).to be > 0

          # Verify snapshots are cumulative (non-decreasing)
          star_counts = snapshots.pluck(:stars)
          expect(star_counts).to eq(star_counts.sort)

          # Verify dates are valid and ordered
          dates = snapshots.pluck(:snapshot_date)
          expect(dates).to eq(dates.sort)
        end
      end

      example 'updates repo star_history_fetched_at' do
        vcr('ossinsight', 'hesreallyhim_awesome_claude_code', time_travel: false) do
          freeze_time do
            operation.call(github_repo: 'hesreallyhim/awesome-claude-code')
            expect(repo.reload.star_history_fetched_at).to eq(Time.current)
          end
        end
      end
    end

    context 'when repo does not exist in database' do
      example 'returns failure without making API call' do
        result = operation.call(github_repo: 'nonexistent/repo')

        expect(result).to be_failure
        expect(result.failure).to include('Repo not found')
      end
    end

    context 'when OSSInsight returns empty rows' do
      let!(:repo) { create(:repo, github_repo: 'owner/empty-repo', stars: nil) }

      before do
        stub_request(:get, 'https://api.ossinsight.io/v1/repos/owner/empty-repo/stargazers/history?per=day')
          .to_return(
            status: 200,
            body: { 'data' => { 'rows' => [] }, 'result' => { 'code' => 200, 'row_count' => 0 } }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      example 'returns failure with no-data message' do
        result = operation.call(github_repo: 'owner/empty-repo')

        expect(result).to be_failure
        expect(result.failure).to include('No star history data')
      end
    end

    context 'when OSSInsight API returns an error' do
      let!(:repo) { create(:repo, github_repo: 'owner/error-repo', stars: nil) }

      before do
        stub_request(:get, 'https://api.ossinsight.io/v1/repos/owner/error-repo/stargazers/history?per=day')
          .to_return(status: 500, body: 'Internal Server Error')
      end

      example 'returns failure' do
        result = operation.call(github_repo: 'owner/error-repo')

        expect(result).to be_failure
        expect(result.failure).to include('Backfill failed')
      end
    end

    context 'when snapshots already exist for some dates' do
      let!(:repo) { create(:repo, github_repo: 'hesreallyhim/awesome-claude-code', stars: nil) }

      before do
        create(:star_snapshot, repo: repo, snapshot_date: Date.parse('2025-04-22'), stars: 999)
      end

      example 'updates existing snapshots with OSSInsight values' do
        vcr('ossinsight', 'hesreallyhim_awesome_claude_code') do
          result = operation.call(github_repo: 'hesreallyhim/awesome-claude-code')

          expect(result).to be_success
          snapshot = StarSnapshot.find_by(repo: repo, snapshot_date: Date.parse('2025-04-22'))
          expect(snapshot.stars).not_to eq(999) # Updated from stale value
        end
      end
    end
  end
end
