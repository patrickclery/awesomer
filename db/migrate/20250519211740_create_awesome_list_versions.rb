class CreateAwesomeListVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :awesome_list_versions do |t|
      t.references :awesome_list, foreign_key: true, null: false
      t.integer :stars
      t.integer :commits_past_year
      t.datetime :last_commit_at
      t.integer :repo_count
      t.integer :category_count

      t.timestamps
    end
  end
end
