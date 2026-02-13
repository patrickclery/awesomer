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
  end
end
