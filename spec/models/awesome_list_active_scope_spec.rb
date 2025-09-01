# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwesomeList do
  describe 'active scope usage in services' do
    let!(:active_list) { create(:awesome_list, archived: false, state: 'completed') }
    let!(:archived_list) { create(:awesome_list, archived: true, state: 'completed') }

    it 'filters out archived lists with active scope' do
      expect(described_class.active).to include(active_list)
      expect(described_class.active).not_to include(archived_list)
    end

    it 'chains active scope with other scopes' do
      expect(described_class.active.completed).to include(active_list)
      expect(described_class.active.completed).not_to include(archived_list)
    end

    context 'with needs_sync scope' do
      before do
        active_list.update!(last_synced_at: 2.days.ago, sync_threshold: 10)
        archived_list.update!(last_synced_at: 2.days.ago, sync_threshold: 10)

        create(:category_item,
               category: create(:category, awesome_list: active_list),
               previous_stars: 50,
               stars: 100)
        create(:category_item,
               category: create(:category, awesome_list: archived_list),
               previous_stars: 50,
               stars: 100)
      end

      it 'combines active and needs_sync scopes' do
        results = described_class.active.completed.needs_sync
        expect(results).to include(active_list)
        expect(results).not_to include(archived_list)
      end
    end
  end
end
