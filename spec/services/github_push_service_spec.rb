# frozen_string_literal: true

require 'English'
require 'rails_helper'

RSpec.describe GithubPushService do
  let(:service) { described_class.new(commit_message:, files_changed:) }
  let(:files_changed) { ['static/md/awesome-ruby.md', 'static/md/awesome-python.md'] }
  let(:commit_message) { nil }

  describe '#call' do
    context 'when git operations succeed' do
      before do
        allow(Dir).to receive(:exist?).with('.git').and_return(true)
        allow(File).to receive(:exist?).and_return(true)

        # Mock git commands in order they're called
        allow(service).to receive(:`) do |cmd|
          case cmd
          when 'git rev-parse --abbrev-ref HEAD'
            "main\n"
          when 'git status --porcelain static/'
            "M static/md/awesome-ruby.md\nM static/md/awesome-python.md\n"
          when /git add/
            ''
          when /git commit/
            "Committed\n"
          when 'git rev-parse HEAD'
            "abc123def456\n"
          when /git push/
            "Pushed\n"
          else
            ''
          end
        end

        # Mock $?.success? for commit and push operations
        @success_count = 0
        allow($CHILD_STATUS).to receive(:success?) do
          @success_count += 1
          true # All operations succeed
        end
      end

      it 'stages all changed files' do
        expect(service).to receive(:`).with('git add static/md/awesome-ruby.md')
        expect(service).to receive(:`).with('git add static/md/awesome-python.md')
        service.call
      end

      it 'creates a commit' do
        expect(service).to receive(:`).with(/git commit -m/)
        service.call
      end

      it 'uses custom message when provided' do
        service = described_class.new(commit_message: 'Custom commit message', files_changed:)
        allow(Dir).to receive(:exist?).with('.git').and_return(true)
        allow(File).to receive(:exist?).and_return(true)

        allow(service).to receive(:`) do |cmd|
          case cmd
          when 'git rev-parse --abbrev-ref HEAD'
            "main\n"
          when 'git status --porcelain static/'
            "M static/md/awesome-ruby.md\n"
          when /Custom commit message/
            "Committed\n"
          else
            ''
          end
        end
        allow($CHILD_STATUS).to receive(:success?).and_return(true)

        expect(service).to receive(:`).with(/Custom commit message/)
        service.call
      end

      it 'pushes to origin' do
        expect(service).to receive(:`).with(/git push origin/)
        service.call
      end

      it 'returns success with commit details' do
        result = service.call

        expect(result).to be_success
        expect(result.value![:commit_sha]).to eq('abc123def456')
        expect(result.value![:files_count]).to eq(2)
        expect(result.value![:branch]).to eq('main')
      end

      it 'updates last_pushed_at for synced lists' do
        awesome_list = create(:awesome_list, github_repo: 'sindresorhus/awesome-ruby', last_synced_at: 1.hour.ago)

        expect do
          service.call
        end.to change { awesome_list.reload.last_pushed_at }.from(nil)
      end
    end

    context 'when not in a git repository' do
      before do
        allow(Dir).to receive(:exist?).with('.git').and_return(false)
      end

      it 'returns failure with appropriate message' do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to eq('Not in a git repository')
      end
    end

    context 'when no files are changed' do
      let(:files_changed) { [] }

      it 'returns failure with appropriate message' do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to eq('No files to push')
      end
    end

    context 'when files do not exist' do
      before do
        allow(Dir).to receive(:exist?).with('.git').and_return(true)
        allow(File).to receive(:exist?).and_return(false)
        allow(service).to receive(:`).with('git rev-parse --abbrev-ref HEAD').and_return("main\n")
        allow(service).to receive(:`).with('git status --porcelain static/').and_return("M static/md/awesome-ruby.md\n")
      end

      it 'skips non-existent files' do
        expect(service).not_to receive(:`).with(/git add/)
        service.call
      end
    end

    context 'when commit fails' do
      before do
        allow(Dir).to receive(:exist?).with('.git').and_return(true)
        allow(File).to receive(:exist?).and_return(true)
        allow(service).to receive(:`) do |cmd|
          case cmd
          when 'git rev-parse --abbrev-ref HEAD'
            "main\n"
          when 'git status --porcelain static/'
            "M static/md/awesome-ruby.md\n"
          when /git commit/
            'error message'
          else
            ''
          end
        end
        allow($CHILD_STATUS).to receive(:success?).and_return(false)
      end

      it 'returns failure with error message' do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to include('Failed to create commit')
      end
    end

    context 'when push fails' do
      before do
        allow(Dir).to receive(:exist?).with('.git').and_return(true)
        allow(File).to receive(:exist?).and_return(true)

        allow(service).to receive(:`) do |cmd|
          case cmd
          when 'git rev-parse --abbrev-ref HEAD'
            "main\n"
          when 'git status --porcelain static/'
            "M static/md/awesome-ruby.md\n"
          when /git commit/
            "Committed\n"
          when 'git rev-parse HEAD'
            "abc123\n"
          when /git push/
            'push error'
          when 'git reset HEAD~1'
            ''
          else
            ''
          end
        end

        success_counter = 0
        allow($CHILD_STATUS).to receive(:success?) do
          success_counter += 1
          success_counter == 1 # First call (commit) succeeds, second (push) fails
        end
      end

      it 'returns failure with error message' do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to include('Failed to push to GitHub')
      end

      it 'resets the commit' do
        expect(service).to receive(:`).with('git reset HEAD~1')
        service.call
      end
    end

    context 'when no changes in static/ directory' do
      before do
        allow(Dir).to receive(:exist?).with('.git').and_return(true)
        allow(service).to receive(:`).with('git rev-parse --abbrev-ref HEAD').and_return("main\n")
        allow(service).to receive(:`).with('git status --porcelain static/').and_return('')
      end

      it 'returns success without committing' do
        result = service.call

        expect(result).to be_success
        expect(result.value!).to eq('No changes to push')
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(Dir).to receive(:exist?).and_raise(StandardError, 'Unexpected error')
      end

      it 'returns failure with the error message' do
        result = service.call

        expect(result).to be_failure
        expect(result.failure).to include('Unexpected error')
      end
    end
  end
end
