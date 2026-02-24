class DropRepoStats < ActiveRecord::Migration[8.0]
  def up
    drop_table :repo_stats
  end

  def down
    create_table :repo_stats do |t|
      t.integer :awesome_list_id, null: false
      t.integer :stars
      t.integer :commits_past_year
      t.datetime :last_commit_at
      t.timestamps
    end
    add_index :repo_stats, :awesome_list_id
    add_foreign_key :repo_stats, :awesome_lists
  end
end
