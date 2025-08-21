# frozen_string_literal: true

require "rails_helper"

RSpec.describe AwesomeList, "sync methods" do
  describe "associations" do
    it "has many sync_logs with dependent destroy" do
      association = described_class.reflect_on_association(:sync_logs)
      expect(association).not_to be_nil
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe ".needs_sync scope" do
    let!(:never_synced) { create(:awesome_list, last_synced_at: nil) }
    let!(:old_sync) { create(:awesome_list, last_synced_at: 2.days.ago) }
    let!(:recent_sync) { create(:awesome_list, last_synced_at: 1.hour.ago) }

    it "includes lists that have never been synced" do
      expect(described_class.needs_sync).to include(never_synced)
    end

    it "includes lists synced more than a day ago" do
      expect(described_class.needs_sync).to include(old_sync)
    end

    it "excludes lists synced within the last day" do
      expect(described_class.needs_sync).not_to include(recent_sync)
    end
  end

  describe "#sync_threshold_value" do
    context "when sync_threshold is set" do
      let(:awesome_list) { build(:awesome_list, sync_threshold: 25) }

      it "returns the custom threshold" do
        expect(awesome_list.sync_threshold_value).to eq(25)
      end
    end

    context "when sync_threshold is nil" do
      let(:awesome_list) { build(:awesome_list, sync_threshold: nil) }

      it "returns the default threshold of 10" do
        expect(awesome_list.sync_threshold_value).to eq(10)
      end
    end
  end

  describe "#needs_sync?" do
    context "when never synced" do
      let(:awesome_list) { build(:awesome_list, last_synced_at: nil) }

      it "returns true" do
        expect(awesome_list.needs_sync?).to be(true)
      end
    end

    context "when synced more than 24 hours ago" do
      let(:awesome_list) { build(:awesome_list, last_synced_at: 25.hours.ago) }

      it "returns true" do
        expect(awesome_list.needs_sync?).to be(true)
      end
    end

    context "when synced within 24 hours" do
      let(:awesome_list) { build(:awesome_list, last_synced_at: 23.hours.ago) }

      it "returns false" do
        expect(awesome_list.needs_sync?).to be(false)
      end
    end

    context "when synced exactly 24 hours ago" do
      let(:awesome_list) { build(:awesome_list, last_synced_at: 24.hours.ago) }

      it "returns true" do
        expect(awesome_list.needs_sync?).to be(true)
      end
    end
  end

  describe "#last_successful_sync" do
    let(:awesome_list) { create(:awesome_list) }

    context "when there are successful sync logs" do
      let!(:failed_sync) { create(:sync_log, awesome_list:, started_at: 3.hours.ago, status: "failed") }
      let!(:old_success) { create(:sync_log, awesome_list:, started_at: 2.hours.ago, status: "completed") }
      let!(:recent_success) {
 create(:sync_log, awesome_list:, started_at: 1.hour.ago, status: "completed") }

      it "returns the most recent successful sync" do
        expect(awesome_list.last_successful_sync).to eq(recent_success)
      end
    end

    context "when there are no successful syncs" do
      let!(:failed_sync) { create(:sync_log, awesome_list:, status: "failed") }

      it "returns nil" do
        expect(awesome_list.last_successful_sync).to be_nil
      end
    end

    context "when there are no sync logs" do
      it "returns nil" do
        expect(awesome_list.last_successful_sync).to be_nil
      end
    end
  end

  describe "#sync_in_progress?" do
    let(:awesome_list) { create(:awesome_list) }

    context "when there is a started sync log" do
      let!(:started_sync) { create(:sync_log, awesome_list:, status: "started") }

      it "returns true" do
        expect(awesome_list.sync_in_progress?).to be(true)
      end
    end

    context "when all syncs are completed or failed" do
      let!(:completed_sync) { create(:sync_log, awesome_list:, status: "completed") }
      let!(:failed_sync) { create(:sync_log, awesome_list:, status: "failed") }

      it "returns false" do
        expect(awesome_list.sync_in_progress?).to be(false)
      end
    end

    context "when there are no sync logs" do
      it "returns false" do
        expect(awesome_list.sync_in_progress?).to be(false)
      end
    end
  end
end
