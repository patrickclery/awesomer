# frozen_string_literal: true

require 'rails_helper'
require 'awesomer/commands/prune'

RSpec.describe Awesomer::Commands::Prune do
  let(:prune_command) { described_class.new }

  before do
    # Silence output during tests
    allow(prune_command).to receive(:say)
    allow(prune_command).to receive(:print)
    allow(prune_command).to receive(:puts)
  end

  describe '#execute' do
    context 'with stale repositories' do
      let!(:old_repo) { create(:awesome_list, github_repo: 'user/old-repo', updated_at: 400.days.ago) }
      let!(:recent_repo) { create(:awesome_list, github_repo: 'user/recent-repo', updated_at: 10.days.ago) }

      context 'with dry_run option' do
        before do
          prune_command.options = {dry_run: true, since: 365, unarchive: false}
        end

        it 'does not archive any repositories' do
          expect { prune_command.execute }.not_to(change { old_repo.reload.archived })
        end

        it 'identifies stale repositories' do
          expect(prune_command).to receive(:say).with(/Found 1 stale repositories to archive/, anything)
          prune_command.execute
        end
      end

      context 'without dry_run option' do
        before do
          prune_command.options = {dry_run: false, since: 365, unarchive: false}
          allow(prune_command).to receive(:yes?).and_return(true)
        end

        it 'archives stale repositories' do
          expect { prune_command.execute }.to change { old_repo.reload.archived }.from(false).to(true)
        end

        it 'does not archive recent repositories' do
          expect { prune_command.execute }.not_to(change { recent_repo.reload.archived })
        end

        it 'sets archived_at timestamp' do
          freeze_time do
            prune_command.execute
            expect(old_repo.reload.archived_at).to eq(Time.current)
          end
        end
      end

      context 'with custom since option' do
        before do
          prune_command.options = {dry_run: false, since: 5, unarchive: false}
          allow(prune_command).to receive(:yes?).and_return(true)
        end

        it 'archives repositories based on custom threshold' do
          prune_command.execute
          expect(old_repo.reload.archived).to be(true)
          expect(recent_repo.reload.archived).to be(true)
        end
      end

      context 'when user cancels confirmation' do
        before do
          prune_command.options = {dry_run: false, since: 365, unarchive: false}
          allow(prune_command).to receive(:yes?).and_return(false)
          allow(prune_command).to receive(:exit).with(1).and_raise(SystemExit.new(1))
        end

        it 'does not archive any repositories' do
          expect { prune_command.execute }.to raise_error(SystemExit) do |error|
            expect(error.status).to eq(1)
          end
          expect(old_repo.reload.archived).to be(false)
        end
      end
    end

    context 'with unarchive option' do
      let!(:archived_recent) { create(:awesome_list, archived: true, archived_at: 1.day.ago, updated_at: 5.days.ago) }
      let!(:archived_old) { create(:awesome_list, archived: true, archived_at: 1.day.ago, updated_at: 400.days.ago) }

      before do
        prune_command.options = {dry_run: false, since: 30, unarchive: true}
        allow(prune_command).to receive(:yes?).and_return(true)
      end

      it 'unarchives recently updated repositories' do
        expect { prune_command.execute }.to change { archived_recent.reload.archived }.from(true).to(false)
      end

      it 'does not unarchive old repositories' do
        expect { prune_command.execute }.not_to(change { archived_old.reload.archived })
      end

      it 'clears archived_at timestamp' do
        prune_command.execute
        expect(archived_recent.reload.archived_at).to be_nil
      end
    end

    context 'with no stale repositories' do
      let!(:recent_repo) { create(:awesome_list, updated_at: 10.days.ago) }

      before do
        prune_command.options = {dry_run: false, since: 5, unarchive: false}
      end

      it 'reports no stale repositories found' do
        expect(prune_command).to receive(:say).with(/No stale repositories found/, anything)
        prune_command.execute
      end

      it 'does not prompt for confirmation' do
        expect(prune_command).not_to receive(:yes?)
        prune_command.execute
      end
    end

    context 'with summary display' do
      let!(:active_repos) { create_list(:awesome_list, 3, archived: false) }
      let!(:archived_repos) { create_list(:awesome_list, 2, archived: true) }

      before do
        prune_command.options = {dry_run: true, since: 365, unarchive: false}
      end

      it 'displays correct counts' do
        expect(prune_command).to receive(:say).with(/Total repositories: 5/, anything)
        expect(prune_command).to receive(:say).with(/Active: 3/, anything)
        expect(prune_command).to receive(:say).with(/Archived: 2/, anything)
        prune_command.execute
      end

      it 'calculates archived percentage' do
        expect(prune_command).to receive(:say).with(/Archived percentage: 40.0%/, anything)
        prune_command.execute
      end
    end
  end
end
