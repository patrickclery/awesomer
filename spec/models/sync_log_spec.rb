# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SyncLog, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:awesome_list) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:started_at) }

    it 'validates inclusion of status' do
      valid_statuses = %w[started completed failed partial]
      valid_statuses.each do |status|
        sync_log = build(:sync_log, status:)
        expect(sync_log).to be_valid
      end

      sync_log = build(:sync_log, status: 'invalid_status')
      expect(sync_log).not_to be_valid
      expect(sync_log.errors[:status]).to include('is not included in the list')
    end
  end

  describe 'scopes' do
    let!(:completed_log) { create(:sync_log, status: 'completed') }
    let!(:failed_log) { create(:sync_log, status: 'failed') }
    let!(:started_log) { create(:sync_log, status: 'started') }

    describe '.completed' do
      it 'returns only completed logs' do
        expect(described_class.completed).to contain_exactly(completed_log)
      end
    end

    describe '.failed' do
      it 'returns only failed logs' do
        expect(described_class.failed).to contain_exactly(failed_log)
      end
    end

    describe '.recent' do
      it 'orders by started_at descending' do
        older_log = create(:sync_log, started_at: 1.day.ago)
        newer_log = create(:sync_log, started_at: 1.hour.ago)

        # Only look at the logs we just created
        created_logs = [older_log, newer_log]
        recent_logs = described_class.where(id: created_logs.map(&:id)).recent.to_a

        expect(recent_logs.first).to eq(newer_log)
        expect(recent_logs.last).to eq(older_log)
      end
    end
  end

  describe '#duration' do
    let(:sync_log) { build(:sync_log, completed_at: Time.current, started_at: 1.hour.ago) }

    it 'returns the duration between started_at and completed_at' do
      expect(sync_log.duration).to be_within(1).of(3600)
    end

    it 'returns nil if started_at is nil' do
      sync_log.started_at = nil
      expect(sync_log.duration).to be_nil
    end

    it 'returns nil if completed_at is nil' do
      sync_log.completed_at = nil
      expect(sync_log.duration).to be_nil
    end
  end

  describe '#success?' do
    it 'returns true for completed status' do
      sync_log = build(:sync_log, status: 'completed')
      expect(sync_log.success?).to be(true)
    end

    it 'returns false for other statuses' do
      %w[started failed partial].each do |status|
        sync_log = build(:sync_log, status:)
        expect(sync_log.success?).to be(false)
      end
    end
  end

  describe '#failed?' do
    it 'returns true for failed status' do
      sync_log = build(:sync_log, status: 'failed')
      expect(sync_log.failed?).to be(true)
    end

    it 'returns false for other statuses' do
      %w[started completed partial].each do |status|
        sync_log = build(:sync_log, status:)
        expect(sync_log.failed?).to be(false)
      end
    end
  end
end
