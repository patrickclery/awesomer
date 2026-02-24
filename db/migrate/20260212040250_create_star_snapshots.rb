class CreateStarSnapshots < ActiveRecord::Migration[8.0]
  def change
    create_table :star_snapshots do |t|
      t.references :repo, null: false, foreign_key: true
      t.integer :stars, null: false
      t.date :snapshot_date, null: false
      t.timestamps
    end

    add_index :star_snapshots, [:repo_id, :snapshot_date], unique: true
    add_index :star_snapshots, :snapshot_date
  end
end
