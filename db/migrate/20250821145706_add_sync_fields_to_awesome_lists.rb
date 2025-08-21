# frozen_string_literal: true

class AddSyncFieldsToAwesomeLists < ActiveRecord::Migration[8.0]
  def change
    add_column :awesome_lists, :last_synced_at, :datetime
    add_column :awesome_lists, :last_pushed_at, :datetime
    add_column :awesome_lists, :sync_threshold, :integer, default: 10

    add_index :awesome_lists, :last_synced_at
  end
end
