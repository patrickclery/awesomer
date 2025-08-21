# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeltaSyncService do
  let(:awesome_list) { create(:awesome_list, sync_threshold: 10) }
  let(:category) { create(:category, awesome_list:) }
  let(:service) { described_class.new(awesome_list:, threshold:) }
  let(:threshold) { nil }

  describe "#call" do
    context "when there are no category items" do
      it "creates a sync log with zero items" do
        expect { service.call }.to change(SyncLog, :count).by(1)

        sync_log = SyncLog.last
        expect(sync_log.items_checked).to eq(0)
        expect(sync_log.items_updated).to eq(0)
        expect(sync_log.status).to eq("completed")
      end

      it "updates last_synced_at on the awesome list" do
        expect { service.call }.to change { awesome_list.reload.last_synced_at }.from(nil)
      end

      it "returns success with zero counts" do
        result = service.call
        expect(result).to be_success
        expect(result.value!).to eq({items_checked: 0, items_updated: 0})
      end
    end

    context "when there are items that need updating" do
      let!(:item_needing_update) do
        create(:category_item,
               category:,
               github_repo: "owner/repo",
               previous_stars: 50,
               stars: 100)
      end

      let!(:item_not_needing_update) do
        create(:category_item,
               category:,
               github_repo: "owner/other-repo",
               previous_stars: 55,
               stars: 60)
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(:repository).and_return(
          double(pushed_at: Time.current, stargazers_count: 110)
        )
        allow_any_instance_of(GithubRateLimiterService).to receive(:wait_if_needed)
      end

      it "only syncs items that exceed the threshold" do
        result = service.call

        expect(result).to be_success
        expect(result.value![:items_checked]).to eq(2)
        expect(result.value![:items_updated]).to eq(1)
      end

      it "updates the stars for items that need updating" do
        service.call

        item_needing_update.reload
        expect(item_needing_update.stars).to eq(110)
        expect(item_needing_update.previous_stars).to eq(110)
      end

      it "creates a successful sync log" do
        service.call

        sync_log = SyncLog.last
        expect(sync_log.status).to eq("completed")
        expect(sync_log.items_checked).to eq(2)
        expect(sync_log.items_updated).to eq(1)
      end
    end

    context "when using a custom threshold" do
      let(:threshold) { 1 }

      let!(:item) do
        create(:category_item,
               category:,
               github_repo: "owner/repo",
               previous_stars: 98,
               stars: 100)
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(:repository).and_return(
          double(pushed_at: Time.current, stargazers_count: 102)
        )
        allow_any_instance_of(GithubRateLimiterService).to receive(:wait_if_needed)
      end

      it "uses the custom threshold instead of the list default" do
        result = service.call

        expect(result).to be_success
        expect(result.value![:items_updated]).to eq(1)
      end
    end

    context "when GitHub API returns not found" do
      let!(:item) do
        create(:category_item,
               category:,
               github_repo: "owner/deleted-repo",
               previous_stars: nil,
               stars: nil)
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(:repository)
          .and_raise(Octokit::NotFound)
        allow_any_instance_of(GithubRateLimiterService).to receive(:wait_if_needed)
      end

      it "continues processing and marks as completed" do
        result = service.call

        expect(result).to be_success
        sync_log = SyncLog.last
        expect(sync_log.status).to eq("completed")
        expect(sync_log.items_updated).to eq(0)
      end
    end

    context "when rate limited" do
      let!(:item) do
        create(:category_item,
               category:,
               github_repo: "owner/repo",
               previous_stars: nil,
               stars: 50)
      end

      before do
        call_count = 0
        allow_any_instance_of(Octokit::Client).to receive(:repository) do
          call_count += 1
          if call_count == 1
            raise Octokit::TooManyRequests
          else
            double(pushed_at: Time.current, stargazers_count: 100)
          end
        end
        allow_any_instance_of(GithubRateLimiterService).to receive(:wait_if_needed)
        allow_any_instance_of(described_class).to receive(:sleep)
      end

      it "retries after waiting" do
        result = service.call

        expect(result).to be_success
        expect(result.value![:items_updated]).to eq(1)
      end
    end

    context "when an unexpected error occurs in the main flow" do
      let!(:item) do
        create(:category_item,
               category:,
               github_repo: "owner/repo",
               previous_stars: nil,
               stars: 100)
      end

      before do
        # Force an error during the main process, not in sync_items
        allow(awesome_list).to receive(:category_items).and_raise(StandardError, "Unexpected error")
      end

      it "marks sync log as failed" do
        result = service.call

        expect(result).to be_failure
        sync_log = SyncLog.last
        expect(sync_log.status).to eq("failed")
        expect(sync_log.error_message).to include("Unexpected error")
      end

      it "returns failure with error message" do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to include("Unexpected error")
      end
    end

    context "when items have no previous_stars" do
      let!(:new_item) do
        create(:category_item,
               category:,
               github_repo: "owner/new-repo",
               previous_stars: nil,
               stars: 50)
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(:repository).and_return(
          double(pushed_at: Time.current, stargazers_count: 50)
        )
        allow_any_instance_of(GithubRateLimiterService).to receive(:wait_if_needed)
      end

      it "treats them as needing update" do
        result = service.call

        expect(result).to be_success
        expect(result.value![:items_updated]).to eq(1)
      end
    end
  end
end
