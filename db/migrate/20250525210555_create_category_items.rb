# frozen_string_literal: true

class CreateCategoryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :category_items do |t|
      t.string :name
      t.string :github_repo
      t.string :demo_url
      t.string :primary_url
      t.text :description
      t.integer :commits_past_year
      t.datetime :last_commit_at
      t.integer :stars
      t.references :category, foreign_key: true, null: false

      t.timestamps
    end
  end
end
