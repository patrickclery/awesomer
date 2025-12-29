# frozen_string_literal: true

require 'rails_helper'
require 'awesomer/commands/refresh'
require 'awesomer/commands/sync'

RSpec.describe Awesomer::Commands::Refresh do
  let(:command) { described_class.new }

  # Create test data
  let!(:active_list1) { create(:awesome_list, github_repo: 'owner/active-repo-1', archived: false, state: :completed) }
  let!(:active_list2) { create(:awesome_list, github_repo: 'owner/active-repo-2', archived: false, state: :pending) }
  let!(:archived_list) { create(:awesome_list, github_repo: 'owner/archived-repo', archived: true, state: :completed) }

  before do
    # Suppress Thor output during tests
    allow(command).to receive(:say)
    allow(command).to receive(:print)
    allow(command).to receive(:puts)
  end

  describe '#execute' do
    context 'with default options (async mode)' do
      before do
        command.options = Thor::CoreExt::HashWithIndifferentAccess.new(
          async: true,
          star_history: true,
          prune: true,
          limit: nil
        )
      end

      example 'only processes active (non-archived) lists' do
        # Stub out the job queueing
        allow(ProcessMarkdownWithStatsJob).to receive(:perform_later)
        allow(QueueStarHistoryJobsOperation).to receive(:new).and_return(
          instance_double(QueueStarHistoryJobsOperation, call: Dry::Monads::Success(queued: 0))
        )

        command.execute

        # Should only queue jobs for active lists
        expect(ProcessMarkdownWithStatsJob).to have_received(:perform_later).twice
        expect(ProcessMarkdownWithStatsJob).to have_received(:perform_later).with(
          hash_including(repo_identifier: 'owner/active-repo-1')
        )
        expect(ProcessMarkdownWithStatsJob).to have_received(:perform_later).with(
          hash_including(repo_identifier: 'owner/active-repo-2')
        )
        expect(ProcessMarkdownWithStatsJob).not_to have_received(:perform_later).with(
          hash_including(repo_identifier: 'owner/archived-repo')
        )
      end

      example 'queues star history jobs when star_history option is true' do
        allow(ProcessMarkdownWithStatsJob).to receive(:perform_later)
        mock_operation = instance_double(QueueStarHistoryJobsOperation)
        allow(QueueStarHistoryJobsOperation).to receive(:new).and_return(mock_operation)
        allow(mock_operation).to receive(:call).and_return(Dry::Monads::Success(queued: 5))

        command.execute

        # Should call QueueStarHistoryJobsOperation for each active list
        expect(mock_operation).to have_received(:call).twice
      end
    end

    context 'with star_history disabled' do
      before do
        command.options = Thor::CoreExt::HashWithIndifferentAccess.new(
          async: true,
          star_history: false,
          prune: true,
          limit: nil
        )
      end

      example 'does not queue star history jobs' do
        allow(ProcessMarkdownWithStatsJob).to receive(:perform_later)

        command.execute

        # QueueStarHistoryJobsOperation should never be instantiated when star_history is false
        expect(QueueStarHistoryJobsOperation).not_to receive(:new)
      end
    end

    context 'with limit option' do
      before do
        command.options = Thor::CoreExt::HashWithIndifferentAccess.new(
          async: true,
          star_history: false,
          prune: true,
          limit: 1
        )
      end

      example 'only processes up to the specified limit of lists' do
        allow(ProcessMarkdownWithStatsJob).to receive(:perform_later)

        command.execute

        expect(ProcessMarkdownWithStatsJob).to have_received(:perform_later).once
      end
    end

    context 'with sync mode (no-async)' do
      let!(:category_item_without_stars) do
        category = create(:category, awesome_list: active_list1)
        create(:category_item, category: category, github_repo: 'owner/item-repo', stars: nil)
      end

      before do
        command.options = Thor::CoreExt::HashWithIndifferentAccess.new(
          async: false,
          star_history: false,
          prune: false,
          limit: 1
        )
      end

      example 'processes lists synchronously instead of queueing jobs' do
        # Stub external dependencies
        allow(Octokit::Client).to receive(:new).and_return(
          instance_double(Octokit::Client, repository: double(
            description: 'Test',
            pushed_at: Time.current,
            stargazers_count: 100
          ))
        )
        allow(GithubRateLimiterService).to receive(:new).and_return(
          instance_double(GithubRateLimiterService, wait_if_needed: nil)
        )
        allow(ProcessAwesomeListService).to receive(:new).and_return(
          instance_double(ProcessAwesomeListService, call: Dry::Monads::Success([]))
        )
        allow(ProcessCategoryServiceEnhanced).to receive(:new).and_return(
          instance_double(ProcessCategoryServiceEnhanced, call: Dry::Monads::Success(:ok))
        )

        command.execute

        # Should NOT queue any jobs in sync mode
        expect(ProcessMarkdownWithStatsJob).not_to receive(:perform_later)
      end

      example 'only syncs GitHub stats for items belonging to active lists' do
        # Create item for archived list
        archived_category = create(:category, awesome_list: archived_list)
        create(:category_item, category: archived_category, github_repo: 'owner/archived-item', stars: nil)

        mock_client = instance_double(Octokit::Client)
        allow(Octokit::Client).to receive(:new).and_return(mock_client)
        allow(mock_client).to receive(:repository).and_return(
          double(description: 'Test', pushed_at: Time.current, stargazers_count: 100)
        )
        allow(GithubRateLimiterService).to receive(:new).and_return(
          instance_double(GithubRateLimiterService, wait_if_needed: nil)
        )
        allow(ProcessAwesomeListService).to receive(:new).and_return(
          instance_double(ProcessAwesomeListService, call: Dry::Monads::Success([]))
        )
        allow(ProcessCategoryServiceEnhanced).to receive(:new).and_return(
          instance_double(ProcessCategoryServiceEnhanced, call: Dry::Monads::Success(:ok))
        )

        command.execute

        # The item from active list should be updated
        expect(category_item_without_stars.reload.stars).to eq(100)
        # The item from archived list should NOT be updated
        archived_item = CategoryItem.find_by(github_repo: 'owner/archived-item')
        expect(archived_item.stars).to be_nil
      end
    end
  end

  describe '#fetch_lists_to_process' do
    example 'returns only active (non-archived) lists' do
      command.options = Thor::CoreExt::HashWithIndifferentAccess.new(limit: nil)

      lists = command.send(:fetch_lists_to_process).to_a

      expect(lists).to include(active_list1, active_list2)
      expect(lists).not_to include(archived_list)
    end

    example 'respects limit option' do
      command.options = Thor::CoreExt::HashWithIndifferentAccess.new(limit: 1)

      lists = command.send(:fetch_lists_to_process).to_a

      expect(lists.size).to eq(1)
    end

    example 'returns all active lists when limit is nil' do
      command.options = Thor::CoreExt::HashWithIndifferentAccess.new(limit: nil)

      lists = command.send(:fetch_lists_to_process).to_a

      expect(lists.size).to eq(2)
    end
  end

  describe 'state transitions' do
    example 'can reprocess a completed list' do
      expect(active_list1.state).to eq('completed')
      expect { active_list1.start_processing! }.not_to raise_error
      expect(active_list1.state).to eq('in_progress')
    end

    example 'can reprocess a failed list' do
      failed_list = create(:awesome_list, github_repo: 'owner/failed-repo', archived: false, state: :failed)
      expect { failed_list.start_processing! }.not_to raise_error
      expect(failed_list.state).to eq('in_progress')
    end
  end
end

RSpec.describe Awesomer::Commands::Sync do
  let(:command) { described_class.new }

  before do
    allow(command).to receive(:say)
    allow(command).to receive(:print)
    allow(command).to receive(:puts)
  end

  describe '#delete_old_markdown' do
    let!(:active_list) { create(:awesome_list, github_repo: 'owner/active-repo', archived: false) }
    let!(:archived_list) { create(:awesome_list, github_repo: 'owner/archived-repo', archived: true) }

    let(:markdown_dir) { Rails.root.join('static', 'awesomer') }

    before do
      FileUtils.mkdir_p(markdown_dir)
      # Create test files
      File.write(markdown_dir.join('active-repo.md'), 'active content')
      File.write(markdown_dir.join('archived-repo.md'), 'archived content')
      File.write(markdown_dir.join('orphaned-repo.md'), 'orphaned content')
      File.write(markdown_dir.join('README.md'), 'readme content')
    end

    after do
      # Clean up test files
      %w[active-repo.md archived-repo.md orphaned-repo.md].each do |f|
        path = markdown_dir.join(f)
        File.delete(path) if File.exist?(path)
      end
    end

    example 'never deletes markdown files for active lists' do
      command.send(:delete_old_markdown)

      expect(File.exist?(markdown_dir.join('active-repo.md'))).to be true
    end

    example 'deletes markdown files for archived lists' do
      command.send(:delete_old_markdown)

      expect(File.exist?(markdown_dir.join('archived-repo.md'))).to be false
    end

    example 'deletes orphaned markdown files (no corresponding list)' do
      command.send(:delete_old_markdown)

      expect(File.exist?(markdown_dir.join('orphaned-repo.md'))).to be false
    end

    example 'never deletes README.md' do
      command.send(:delete_old_markdown)

      expect(File.exist?(markdown_dir.join('README.md'))).to be true
    end
  end
end
