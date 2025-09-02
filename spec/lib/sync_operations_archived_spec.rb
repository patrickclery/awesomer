# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sync utilities with archived filtering' do
  describe 'FastSync' do
    let!(:active_pending) { create(:awesome_list, state: 'pending', archived: false, github_repo: 'user/active') }
    let!(:archived_pending) { create(:awesome_list, state: 'pending', archived: true, github_repo: 'user/archived') }
    let!(:active_completed) { create(:awesome_list, state: 'completed', archived: false, github_repo: 'user/completed') }

    it 'only processes active pending lists' do
      require_relative '../../lib/fast_sync'
      sync = FastSync.new
      
      # Mock the ProcessAwesomeListService
      expect(ProcessAwesomeListService).to receive(:new).with(
        hash_including(repo_identifier: 'user/active')
      ).and_return(double(call: Dry::Monads::Success(true)))
      
      expect(ProcessAwesomeListService).not_to receive(:new).with(
        hash_including(repo_identifier: 'user/archived')
      )
      
      # Silence output
      allow(sync).to receive(:puts)
      
      # Run the sync
      sync.run
    end
  end

  describe 'SyncAll' do
    let!(:active_pending) { create(:awesome_list, state: 'pending', archived: false, github_repo: 'user/active') }
    let!(:archived_pending) { create(:awesome_list, state: 'pending', archived: true, github_repo: 'user/archived') }
    let!(:active_in_progress) { create(:awesome_list, state: 'in_progress', archived: false, updated_at: 2.hours.ago) }

    before do
      require_relative '../../lib/sync_all'
    end

    it 'only counts active lists in status' do
      sync = SyncAll.new
      allow(sync).to receive(:puts)
      allow(sync).to receive(:reset_stuck_items)
      
      # Check that counts are correct
      expect(AwesomeList.active.pending.count).to eq(1)
      expect(AwesomeList.active.count).to eq(2)
      
      # Mock the processing
      allow(ProcessAwesomeListService).to receive(:new).and_return(
        double(call: Dry::Monads::Success(true))
      )
      
      sync.run
    end

    it 'only processes active pending lists' do
      sync = SyncAll.new
      allow(sync).to receive(:puts)
      allow(sync).to receive(:reset_stuck_items)
      
      expect(ProcessAwesomeListService).to receive(:new).with(
        hash_including(repo_identifier: 'user/active')
      ).and_return(double(call: Dry::Monads::Success(true)))
      
      expect(ProcessAwesomeListService).not_to receive(:new).with(
        hash_including(repo_identifier: 'user/archived')
      )
      
      sync.run
    end
  end

  describe 'Process command reset' do
    let!(:active_completed) { create(:awesome_list, state: 'completed', archived: false) }
    let!(:active_failed) { create(:awesome_list, state: 'failed', archived: false) }
    let!(:archived_completed) { create(:awesome_list, state: 'completed', archived: true) }
    let!(:archived_failed) { create(:awesome_list, state: 'failed', archived: true) }

    it 'only resets active lists to pending' do
      # Initially not pending
      expect(active_completed.state).to eq('completed')
      expect(active_failed.state).to eq('failed')
      expect(archived_completed.state).to eq('completed')
      expect(archived_failed.state).to eq('failed')

      # Simulate the reset operation
      AwesomeList.active.where.not(state: 'pending').find_each(&:reset_for_reprocessing!)

      # Active lists should be reset
      expect(active_completed.reload.state).to eq('pending')
      expect(active_failed.reload.state).to eq('pending')
      
      # Archived lists should remain unchanged
      expect(archived_completed.reload.state).to eq('completed')
      expect(archived_failed.reload.state).to eq('failed')
    end
  end

  describe 'Worker should_sync?' do
    context 'with only archived lists needing sync' do
      let!(:archived_needs_sync) do
        list = create(:awesome_list, state: 'completed', archived: true, sync_threshold: 10, last_synced_at: 2.days.ago)
        create(:category_item, category: create(:category, awesome_list: list), stars: 100, previous_stars: 50)
        list
      end

      it 'returns false' do
        expect(AwesomeList.active.completed.needs_sync.exists?).to be false
      end
    end

    context 'with active lists needing sync' do
      let!(:active_needs_sync) do
        list = create(:awesome_list, state: 'completed', archived: false, sync_threshold: 10, last_synced_at: 2.days.ago)
        create(:category_item, category: create(:category, awesome_list: list), stars: 100, previous_stars: 50)
        list
      end

      it 'returns true' do
        expect(AwesomeList.active.completed.needs_sync.exists?).to be true
      end
    end
  end
end