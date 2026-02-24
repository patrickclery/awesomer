# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QueueStarHistoryJobsOperation do
  let(:operation) { described_class.new }

  describe '#call' do
    context 'with eligible category items' do
      let(:awesome_list) { create(:awesome_list) }
      let(:category) { create(:category, awesome_list:) }
      let!(:eligible_item) do
        create(:category_item, :with_stats,
               category:,
               github_repo: 'owner/repo1',
               stars: 500)
      end
      let!(:another_eligible_item) do
        create(:category_item, :with_stats,
               category:,
               github_repo: 'owner/repo2',
               stars: 200)
      end

      example 'queues FetchStarHistoryJob for each eligible item' do
        expect do
          operation.call(awesome_list:)
        end.to have_enqueued_job(FetchStarHistoryJob).exactly(2).times
      end

      example 'returns success with queued count' do
        result = operation.call(awesome_list:)

        expect(result).to be_success
        expect(result.value![:queued]).to eq(2)
      end
    end

    context 'with items that have no GitHub repo' do
      let(:awesome_list) { create(:awesome_list) }
      let(:category) { create(:category, awesome_list:) }
      let!(:no_github_item) do
        create(:category_item,
               category:,
               github_repo: nil,
               primary_url: 'https://example.com')
      end

      example 'does not queue jobs for items without GitHub repos' do
        expect do
          operation.call(awesome_list:)
        end.not_to have_enqueued_job(FetchStarHistoryJob)
      end

      example 'returns success with zero queued' do
        result = operation.call(awesome_list:)

        expect(result).to be_success
        expect(result.value![:queued]).to eq(0)
      end
    end

    context 'with items that have too many stars' do
      let(:awesome_list) { create(:awesome_list) }
      let(:category) { create(:category, awesome_list:) }
      let!(:popular_item) do
        create(:category_item, :with_stats,
               category:,
               github_repo: 'popular/repo',
               stars: 15_000)
      end

      example 'does not queue jobs for popular repos' do
        expect do
          operation.call(awesome_list:)
        end.not_to have_enqueued_job(FetchStarHistoryJob)
      end
    end

    context 'with items that were recently fetched' do
      let(:awesome_list) { create(:awesome_list) }
      let(:category) { create(:category, awesome_list:) }
      let!(:recently_fetched_item) do
        create(:category_item, :with_stats,
               category:,
               github_repo: 'owner/repo',
               stars: 500,
               star_history_fetched_at: 1.day.ago)
      end

      example 'does not queue jobs for recently fetched items' do
        expect do
          operation.call(awesome_list:)
        end.not_to have_enqueued_job(FetchStarHistoryJob)
      end
    end

    context 'with items that need refresh' do
      let(:awesome_list) { create(:awesome_list) }
      let(:category) { create(:category, awesome_list:) }
      let!(:stale_item) do
        create(:category_item, :with_stats,
               category:,
               github_repo: 'owner/repo',
               stars: 500,
               star_history_fetched_at: 2.weeks.ago)
      end

      example 'queues jobs for items with stale star history' do
        expect do
          operation.call(awesome_list:)
        end.to have_enqueued_job(FetchStarHistoryJob).with(category_item_id: stale_item.id)
      end
    end

    context 'when awesome_list is nil' do
      example 'returns failure' do
        result = operation.call(awesome_list: nil)

        expect(result).to be_failure
        expect(result.failure).to eq('AwesomeList is required')
      end
    end
  end
end
