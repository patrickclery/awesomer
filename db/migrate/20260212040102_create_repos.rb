class CreateRepos < ActiveRecord::Migration[8.0]
  def change
    create_table :repos do |t|
      t.string :github_repo, null: false
      t.string :description
      t.integer :stars
      t.integer :previous_stars
      t.datetime :last_commit_at
      t.integer :stars_30d
      t.integer :stars_90d
      t.datetime :star_history_fetched_at
      t.timestamps
    end

    add_index :repos, :github_repo, unique: true
  end
end
