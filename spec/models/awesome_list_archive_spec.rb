# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwesomeList, type: :model do
  describe 'archive functionality' do
    let(:awesome_list) { create(:awesome_list) }

    describe 'scopes' do
      let!(:active_list) { create(:awesome_list, archived: false) }
      let!(:archived_list) { create(:awesome_list, archived: true, archived_at: 1.day.ago) }
      let!(:old_list) { create(:awesome_list, updated_at: 400.days.ago) }
      let!(:recent_list) { create(:awesome_list, updated_at: 10.days.ago) }

      describe '.active' do
        it 'returns only non-archived lists' do
          expect(described_class.active).to include(active_list, old_list, recent_list)
          expect(described_class.active).not_to include(archived_list)
        end
      end

      describe '.archived' do
        it 'returns only archived lists' do
          expect(described_class.archived).to include(archived_list)
          expect(described_class.archived).not_to include(active_list, old_list, recent_list)
        end
      end

      describe '.stale' do
        it 'returns lists not updated within specified days' do
          expect(described_class.stale(365)).to include(old_list)
          expect(described_class.stale(365)).not_to include(recent_list)
        end

        it 'uses 365 days as default' do
          expect(described_class.stale).to include(old_list)
          expect(described_class.stale).not_to include(recent_list)
        end

        it 'accepts custom day thresholds' do
          expect(described_class.stale(5)).to include(old_list, recent_list)
          expect(described_class.stale(500)).not_to include(old_list, recent_list)
        end
      end
    end

    describe '#archive!' do
      context 'when not archived' do
        it 'sets archived to true' do
          expect { awesome_list.archive! }.to change { awesome_list.archived }.from(false).to(true)
        end

        it 'sets archived_at timestamp' do
          freeze_time do
            awesome_list.archive!
            expect(awesome_list.archived_at).to eq(Time.current)
          end
        end
      end

      context 'when already archived' do
        before do
          awesome_list.update!(archived: true, archived_at: 1.day.ago)
        end

        it 'does not update the record' do
          original_archived_at = awesome_list.archived_at
          awesome_list.archive!
          expect(awesome_list.archived_at).to eq(original_archived_at)
        end
      end
    end

    describe '#unarchive!' do
      context 'when archived' do
        before do
          awesome_list.update!(archived: true, archived_at: 1.day.ago)
        end

        it 'sets archived to false' do
          expect { awesome_list.unarchive! }.to change { awesome_list.archived }.from(true).to(false)
        end

        it 'clears archived_at timestamp' do
          awesome_list.unarchive!
          expect(awesome_list.archived_at).to be_nil
        end
      end

      context 'when not archived' do
        it 'does not update the record' do
          expect { awesome_list.unarchive! }.not_to(change { awesome_list.updated_at })
        end
      end
    end

    describe '#stale?' do
      it 'returns true if updated_at is older than specified days' do
        awesome_list.update!(updated_at: 400.days.ago)
        expect(awesome_list.stale?(365)).to be(true)
      end

      it 'returns false if updated_at is within specified days' do
        awesome_list.update!(updated_at: 10.days.ago)
        expect(awesome_list.stale?(365)).to be(false)
      end

      it 'uses 365 days as default' do
        awesome_list.update!(updated_at: 400.days.ago)
        expect(awesome_list.stale?).to be(true)
      end
    end
  end
end
