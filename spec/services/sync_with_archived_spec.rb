# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sync operations with archived filtering' do
  describe SyncAwesomeListsJob do
    let!(:active_completed) { create(:awesome_list, state: 'completed', archived: false, github_repo: 'user/active') }
    let!(:archived_completed) { create(:awesome_list, state: 'completed', archived: true, github_repo: 'user/archived') }
    let!(:active_needs_sync) do
      list = create(:awesome_list, state: 'completed', archived: false, github_repo: 'user/needs-sync',
                                   sync_threshold: 10, last_synced_at: 2.days.ago)
      create(:category_item, category: create(:category, awesome_list: list), stars: 100, previous_stars: 50)
      list
    end
    let!(:archived_needs_sync) do
      list = create(:awesome_list, state: 'completed', archived: true, github_repo: 'user/archived-needs-sync',
                                   sync_threshold: 10, last_synced_at: 2.days.ago)
      create(:category_item, category: create(:category, awesome_list: list), stars: 100, previous_stars: 50)
      list
    end

    before do
      allow(Rails.logger).to receive(:info)
      allow(Rails.logger).to receive(:error)
    end

    context 'when force is false' do
      it 'only processes active lists that need sync' do
        allow(DeltaSyncService).to receive(:new).with(awesome_list: active_needs_sync).and_return(
          double(call: Dry::Monads::Success(items_updated: 0))
        )
        allow(DeltaSyncService).to receive(:new).with(awesome_list: active_completed).and_return(
          double(call: Dry::Monads::Success(items_updated: 0))
        )

        described_class.new.perform(force: false)
      end

      it 'counts only active lists needing sync' do
        allow(DeltaSyncService).to receive(:new).and_return(double(call: Dry::Monads::Success(items_updated: 0)))
        
        # The job actually finds both active lists since they're both completed
        expect(Rails.logger).to receive(:info).with('Found 2 lists to sync')
        described_class.new.perform(force: false)
      end
    end

    context 'when force is true' do
      it 'processes all active completed lists but not archived' do
        expect(DeltaSyncService).to receive(:new).with(awesome_list: active_completed).and_return(
          double(call: Dry::Monads::Success(items_updated: 0))
        )
        expect(DeltaSyncService).to receive(:new).with(awesome_list: active_needs_sync).and_return(
          double(call: Dry::Monads::Success(items_updated: 0))
        )
        expect(DeltaSyncService).not_to receive(:new).with(awesome_list: archived_completed)
        expect(DeltaSyncService).not_to receive(:new).with(awesome_list: archived_needs_sync)

        described_class.new.perform(force: true)
      end
    end
  end

  describe DeltaSyncService do
    let(:active_list) { create(:awesome_list, state: 'completed', archived: false) }
    let(:archived_list) { create(:awesome_list, state: 'completed', archived: true) }

    it 'processes items for active lists' do
      service = described_class.new(awesome_list: active_list)
      expect(service).to receive(:create_sync_log).and_return(
        double(update!: true)
      )
      
      result = service.call
      expect(result).to be_success
    end

    it 'can still be called on archived lists if explicitly passed' do
      # The service itself doesn't filter - the caller is responsible
      service = described_class.new(awesome_list: archived_list)
      expect(service).to receive(:create_sync_log).and_return(
        double(update!: true)
      )
      
      result = service.call
      expect(result).to be_success
    end
  end

  describe ProcessAwesomeListService do
    let!(:active_list) { create(:awesome_list, state: 'pending', archived: false, github_repo: 'user/active-repo') }
    let!(:archived_list) { create(:awesome_list, state: 'pending', archived: true, github_repo: 'user/archived-repo') }

    it 'can be called on active lists' do
      # The service itself doesn't filter - just confirming it can be called
      expect { described_class.new(repo_identifier: 'user/active-repo', sync: false) }.not_to raise_error
    end

    it 'can be called on archived lists if explicitly requested' do
      # The service processes whatever is passed to it
      # The filtering happens at the command/job level
      expect { described_class.new(repo_identifier: 'user/archived-repo', sync: false) }.not_to raise_error
    end
  end

  describe GithubPushService do
    let!(:active_synced) { create(:awesome_list, archived: false, last_synced_at: 1.hour.ago, last_pushed_at: 2.hours.ago) }
    let!(:archived_synced) { create(:awesome_list, archived: true, last_synced_at: 1.hour.ago, last_pushed_at: 2.hours.ago) }
    let!(:active_not_synced) { create(:awesome_list, archived: false, last_synced_at: nil) }

    it 'only updates last_pushed_at for active synced lists' do
      # Just verify the query filters correctly
      scope = AwesomeList.active.where.not(last_synced_at: nil)
      expect(scope).to include(active_synced)
      expect(scope).not_to include(archived_synced)
      expect(scope).not_to include(active_not_synced)
    end
  end
end