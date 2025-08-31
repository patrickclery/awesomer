# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SyncAwesomeListsJob, type: :job do
  include Dry::Monads[:result]

  describe '#perform' do
    let(:awesome_list) { create(:awesome_list, last_synced_at: 2.days.ago, state: 'completed') }
    let(:category) { create(:category, awesome_list:) }
    let!(:category_item) do
      create(:category_item,
             category:,
             description: 'Test repo',
             last_commit_at: 1.day.ago,
             name: 'test-repo',
             previous_stars: 50,
             primary_url: 'https://github.com/owner/repo',
             stars: 100)
    end

    let(:delta_sync_result) { Success(items_checked: 1, items_updated: 1) }
    let(:process_category_result) { Success(Pathname.new('static/md/awesome-test.md')) }
    let(:github_push_result) { Success(commit_sha: 'abc123', files_count: 1, pushed_at: Time.current) }

    let(:delta_sync_service) { instance_double(DeltaSyncService, call: delta_sync_result) }
    let(:process_category_service) { instance_double(ProcessCategoryService, call: process_category_result) }
    let(:github_push_service) { instance_double(GithubPushService, call: github_push_result) }

    before do
      allow(DeltaSyncService).to receive(:new).and_return(delta_sync_service)
      allow(ProcessCategoryService).to receive(:new).and_return(process_category_service)
      allow(GithubPushService).to receive(:new).and_return(github_push_service)
    end

    context 'without force flag' do
      it 'only syncs lists that need syncing' do
        recent_list = create(:awesome_list, last_synced_at: 1.hour.ago, state: 'completed')

        expect(DeltaSyncService).to receive(:new).with(awesome_list:).and_return(delta_sync_service)
        expect(DeltaSyncService).not_to receive(:new).with(awesome_list: recent_list)

        described_class.new.perform
      end
    end

    context 'with force flag' do
      it 'syncs all completed lists' do
        recent_list = create(:awesome_list, last_synced_at: 1.hour.ago, state: 'completed')

        expect(DeltaSyncService).to receive(:new).with(awesome_list:).and_return(delta_sync_service)
        expect(DeltaSyncService).to receive(:new).with(awesome_list: recent_list).and_return(delta_sync_service)

        described_class.new.perform(force: true)
      end
    end

    context 'when items are updated' do
      it 'regenerates the markdown file' do
        expect(process_category_service).to receive(:call).with(
          categories: [
            {
              items: [
                {
                  description: 'Test repo',
                  last_commit_at: category_item.last_commit_at,
                  name: 'test-repo',
                  primary_url: 'https://github.com/owner/repo',
                  stars: 100
                }
              ],
              name: category.name
            }
          ],
          repo_identifier: awesome_list.github_repo
        )

        described_class.new.perform
      end

      it 'pushes changes to GitHub' do
        expect(github_push_service).to receive(:call)
        described_class.new.perform
      end

      it 'logs the update progress' do
        expect(Rails.logger).to receive(:info).with(/Starting sync job/)
        expect(Rails.logger).to receive(:info).with(/Found 1 lists to sync/)
        expect(Rails.logger).to receive(:info).with(/Syncing #{awesome_list.github_repo}/)
        expect(Rails.logger).to receive(:info).with(/Regenerating markdown/)
        expect(Rails.logger).to receive(:info).with(/Updated markdown file/)
        expect(Rails.logger).to receive(:info).with(/Pushing 1 updated files/)
        expect(Rails.logger).to receive(:info).with(/Successfully pushed to GitHub/)
        expect(Rails.logger).to receive(:info).with(/completed: 1 items updated across 1 files/)

        described_class.new.perform
      end
    end

    context 'when no items are updated' do
      let(:delta_sync_result) { Success(items_checked: 1, items_updated: 0) }

      it 'does not regenerate markdown files' do
        expect(process_category_service).not_to receive(:call)
        described_class.new.perform
      end

      it 'does not push to GitHub' do
        expect(github_push_service).not_to receive(:call)
        described_class.new.perform
      end

      it 'logs that no files were updated' do
        expect(Rails.logger).to receive(:info).with(/No files were updated, skipping GitHub push/)
        described_class.new.perform
      end
    end

    context 'when delta sync fails' do
      let(:delta_sync_result) { Failure('API rate limit exceeded') }

      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with(/Delta sync failed.*API rate limit exceeded/)
        described_class.new.perform
      end

      it 'continues processing other lists' do
        another_list = create(:awesome_list, last_synced_at: 2.days.ago, state: 'completed')

        delta_sync_service2 = instance_double(DeltaSyncService, call: Success(items_checked: 1, items_updated: 1))

        allow(DeltaSyncService).to receive(:new).with(awesome_list:).and_return(delta_sync_service)
        allow(DeltaSyncService).to receive(:new).with(awesome_list: another_list).and_return(delta_sync_service2)

        expect(Rails.logger).to receive(:error).once
        expect(process_category_service).to receive(:call).once

        described_class.new.perform
      end
    end

    context 'when markdown generation fails' do
      let(:process_category_result) { Failure('Failed to write file') }

      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with(/Failed to generate markdown.*Failed to write file/)
        described_class.new.perform
      end

      it 'does not push to GitHub' do
        expect(github_push_service).not_to receive(:call)
        described_class.new.perform
      end
    end

    context 'when GitHub push fails' do
      let(:github_push_result) { Failure('Authentication failed') }

      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with(/Failed to push to GitHub.*Authentication failed/)
        described_class.new.perform
      end

      it 'still completes the job' do
        expect { described_class.new.perform }.not_to raise_error
      end
    end

    context 'with multiple lists' do
      let!(:awesome_list2) { create(:awesome_list, last_synced_at: 2.days.ago, state: 'completed') }
      let!(:category2) { create(:category, awesome_list: awesome_list2) }
      let!(:category_item2) do
        create(:category_item,
               category: category2,
               previous_stars: 150,
               stars: 200)
      end

      it 'processes all lists that need syncing' do
        expect(DeltaSyncService).to receive(:new).twice.and_return(delta_sync_service)
        described_class.new.perform
      end

      it 'batches all file updates in a single push' do
        expect(github_push_service).to receive(:call).once
        described_class.new.perform
      end

      it 'tracks total items updated across all lists' do
        expect(Rails.logger).to receive(:info).with(/completed: 2 items updated across 2 files/)
        described_class.new.perform
      end
    end

    context 'when no lists need syncing' do
      before do
        awesome_list.update!(last_synced_at: 1.hour.ago)
      end

      it 'logs that no lists were found' do
        expect(Rails.logger).to receive(:info).with(/Found 0 lists to sync/)
        described_class.new.perform
      end

      it 'does not perform any sync operations' do
        expect(DeltaSyncService).not_to receive(:new)
        described_class.new.perform
      end
    end

    context 'with complex category structures' do
      let!(:category2) { create(:category, awesome_list:, name: 'Second Category') }
      let!(:category_item2) do
        create(:category_item,
               category: category2,
               previous_stars: 40,
               stars: 50)
      end

      it 'includes all categories in markdown generation' do
        expect(process_category_service).to receive(:call).with(
          hash_including(
            categories: array_including(
              hash_including(name: category.name),
              hash_including(name: category2.name)
            )
          )
        )

        described_class.new.perform
      end
    end
  end

  describe 'job configuration' do
    it 'uses the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end
