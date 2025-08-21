# frozen_string_literal: true

class CreateSyncLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :sync_logs do |t|
      t.references :awesome_list, foreign_key: true, null: false
      t.datetime :started_at, null: false
      t.datetime :completed_at
      t.integer :items_checked, default: 0
      t.integer :items_updated, default: 0
      t.string :status, null: false
      t.text :error_message
      t.string :git_commit_sha

      t.timestamps
    end
  end
end
