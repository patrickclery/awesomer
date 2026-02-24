# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComputeTrendingOperation do
  let(:operation) { described_class.new }

  describe '#call' do
    context 'with repos that have snapshots spanning >30 days' do
      let!(:repo) { create(:repo, github_repo: 'owner/popular-repo', stars: 5000) }

      before do
        create(:star_snapshot, repo:, snapshot_date: Date.current, stars: 5000)
        create(:star_snapshot, repo:, snapshot_date: Date.current - 30, stars: 4000)
        create(:star_snapshot, repo:, snapshot_date: Date.current - 90, stars: 3000)
      end

      example 'computes stars_30d from snapshot diff' do
        result = operation.call
        expect(result).to be_success
        expect(repo.reload.stars_30d).to eq(1000)
      end

      example 'computes stars_90d from snapshot diff' do
        operation.call
        expect(repo.reload.stars_90d).to eq(2000)
      end
    end

    context 'with repo that has <30 days of snapshots' do
      let!(:repo) { create(:repo, github_repo: 'owner/new-repo', stars: 100) }

      before do
        create(:star_snapshot, repo:, snapshot_date: Date.current, stars: 100)
        create(:star_snapshot, repo:, snapshot_date: Date.current - 10, stars: 80)
      end

      example 'leaves stars_30d as nil' do
        operation.call
        expect(repo.reload.stars_30d).to be_nil
      end

      example 'leaves stars_90d as nil' do
        operation.call
        expect(repo.reload.stars_90d).to be_nil
      end
    end

    context 'with repo that has no snapshots' do
      let!(:repo) { create(:repo, github_repo: 'owner/no-snapshots', stars: 50) }

      example 'leaves trending columns unchanged' do
        operation.call
        repo.reload
        expect(repo.stars_30d).to be_nil
        expect(repo.stars_90d).to be_nil
      end
    end

    context 'with snapshot date tolerance (3-day window)' do
      let!(:repo) { create(:repo, github_repo: 'owner/gapped-repo', stars: 3000) }

      before do
        # No snapshot for exactly today, but one from yesterday
        create(:star_snapshot, repo:, snapshot_date: Date.current - 1, stars: 3000)
        # No snapshot for exactly 30 days ago, but one from 31 days ago
        create(:star_snapshot, repo:, snapshot_date: Date.current - 31, stars: 2500)
      end

      example 'uses closest snapshot within tolerance window' do
        operation.call
        expect(repo.reload.stars_30d).to eq(500)
      end
    end

    context 'with multiple repos' do
      let!(:repo1) { create(:repo, github_repo: 'owner/repo-a', stars: 10_000) }
      let!(:repo2) { create(:repo, github_repo: 'owner/repo-b', stars: 200) }
      let!(:repo3) { create(:repo, github_repo: 'owner/repo-c', stars: 500) }

      before do
        # repo1: has both 30d and 90d data
        create(:star_snapshot, repo: repo1, snapshot_date: Date.current, stars: 10_000)
        create(:star_snapshot, repo: repo1, snapshot_date: Date.current - 30, stars: 9000)
        create(:star_snapshot, repo: repo1, snapshot_date: Date.current - 90, stars: 7000)

        # repo2: only has 30d data
        create(:star_snapshot, repo: repo2, snapshot_date: Date.current, stars: 200)
        create(:star_snapshot, repo: repo2, snapshot_date: Date.current - 30, stars: 150)

        # repo3: no snapshots
      end

      example 'updates all repos with available data' do
        result = operation.call
        expect(result).to be_success

        expect(repo1.reload.stars_30d).to eq(1000)
        expect(repo1.stars_90d).to eq(3000)

        expect(repo2.reload.stars_30d).to eq(50)
        expect(repo2.stars_90d).to be_nil

        expect(repo3.reload.stars_30d).to be_nil
        expect(repo3.stars_90d).to be_nil
      end

      example 'returns summary message with counts' do
        result = operation.call
        expect(result.value!).to match(/Updated trending: \d+ repos \(30d\), \d+ repos \(90d\)/)
      end
    end

    context 'with no repos at all' do
      example 'returns success with zero counts' do
        result = operation.call
        expect(result).to be_success
        expect(result.value!).to include('0 repos (30d)')
      end
    end

    context 'when trending is computed, item.repo.stars_30d is accessible' do
      let!(:list) { create(:awesome_list, github_repo: 'owner/awesome-test') }
      let!(:category) { create(:category, awesome_list: list) }
      let!(:repo) { create(:repo, github_repo: 'owner/trending-repo', stars: 5000) }
      let!(:item) { create(:category_item, category:, github_repo: 'owner/trending-repo', repo:, stars: 5000) }

      before do
        create(:star_snapshot, repo:, snapshot_date: Date.current, stars: 5000)
        create(:star_snapshot, repo:, snapshot_date: Date.current - 30, stars: 4200)
      end

      example 'makes stars_30d available through category_item.repo' do
        operation.call

        item.reload
        expect(item.repo.stars_30d).to eq(800)
      end
    end

    context 'with negative trending (repo losing stars)' do
      let!(:repo) { create(:repo, github_repo: 'owner/declining-repo', stars: 400) }

      before do
        create(:star_snapshot, repo:, snapshot_date: Date.current, stars: 400)
        create(:star_snapshot, repo:, snapshot_date: Date.current - 30, stars: 500)
      end

      example 'stores negative value for declining repos' do
        operation.call
        expect(repo.reload.stars_30d).to eq(-100)
      end
    end
  end
end
