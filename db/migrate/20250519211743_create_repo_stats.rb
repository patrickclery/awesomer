# frozen_string_literal: true

class CreateRepoStats < ActiveRecord::Migration[8.0]
  def change
    create_table :repo_stats do |t|
      t.references :awesome_list_version, foreign_key: true, null: false
      t.integer :stars
      t.integer :commits_past_year
      t.datetime :last_commit_at

      t.timestamps
    end
  end
end
