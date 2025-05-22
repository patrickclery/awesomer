# frozen_string_literal: true

class DropAwesomeListVersions < ActiveRecord::Migration[7.1]
  def change
    drop_table :awesome_list_versions do |t|
      # If you need to specify columns for rollback, copy them from the create_table migration
      # For example:
      # t.integer :awesome_list_id, null: false
      # t.integer :stars
      # t.integer :category_count
      # t.integer :repo_count
      # t.integer :commits_past_year
      # t.datetime :last_commit_at
      # t.timestamps
      # t.index [:awesome_list_id], name: "index_awesome_list_versions_on_awesome_list_id"
    end
  end
end
