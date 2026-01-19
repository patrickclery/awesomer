# frozen_string_literal: true

require 'rails_helper'
require 'cli/markdown_processor'

RSpec.describe Cli::MarkdownProcessor do
  let(:cli) { described_class.new }

  describe '#sync' do
    # Note: Factory defaults to state: 'completed', so we explicitly set state: 'pending'
    # for active_list to ensure it's included in incomplete scope tests
    let!(:active_list) { create(:awesome_list, archived: false, state: 'pending', github_repo: 'owner/active-repo') }
    let!(:archived_list) { create(:awesome_list, archived: true, state: 'pending', github_repo: 'owner/archived-repo') }

    context 'when running in dry-run mode' do
      example 'only includes active lists in the count' do
        expect { cli.invoke(:sync, [], dry_run: true) }
          .to output(/Would process 1 awesome lists/).to_stdout
      end

      example 'does not include archived lists' do
        expect { cli.invoke(:sync, [], dry_run: true) }
          .not_to output(/archived-repo/).to_stdout
      end

      example 'includes active lists' do
        expect { cli.invoke(:sync, [], dry_run: true) }
          .to output(/active-repo/).to_stdout
      end
    end

    context 'when processing lists' do
      example 'only processes active lists' do
        # Track which repos are processed by stubbing the service entirely
        processed_repos = []
        mock_service = instance_double(ProcessAwesomeListService)
        allow(mock_service).to receive(:call).and_return(Dry::Monads::Success('processed'))

        allow(ProcessAwesomeListService).to receive(:new) do |args|
          processed_repos << args[:repo_identifier]
          mock_service
        end

        cli.invoke(:sync, [], output_dir: 'tmp/test_sync')

        expect(processed_repos).to include('owner/active-repo')
        expect(processed_repos).not_to include('owner/archived-repo')
      end
    end

    context 'with incomplete_only option' do
      let!(:active_pending) { create(:awesome_list, archived: false, state: 'pending', github_repo: 'owner/pending') }
      let!(:active_completed) { create(:awesome_list, archived: false, state: 'completed', github_repo: 'owner/completed') }
      let!(:archived_pending) { create(:awesome_list, archived: true, state: 'pending', github_repo: 'owner/archived-pending') }

      example 'only includes active incomplete lists' do
        # active_list (pending) + active_pending = 2 active incomplete lists
        # active_completed is excluded (state: completed)
        # archived_pending is excluded (archived: true)
        expect { cli.invoke(:sync, [], dry_run: true, incomplete_only: true) }
          .to output(/Would process 2 awesome lists/).to_stdout
      end

      example 'excludes archived incomplete lists' do
        expect { cli.invoke(:sync, [], dry_run: true, incomplete_only: true) }
          .not_to output(/archived-pending/).to_stdout
      end
    end
  end
end
