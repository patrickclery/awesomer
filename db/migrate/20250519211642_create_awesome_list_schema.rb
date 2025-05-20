# frozen_string_literal: true

class CreateAwesomeListSchema < ActiveRecord::Migration[8.0]
  def change
    create_table :awesome_lists do |t|
      t.string :name, null: false
      t.text :description
      t.string :github_repo, null: false
      t.timestamps
    end

    create_table :awesome_list_versions do |t|
      t.belongs_to :awesome_list, foreign_key: true, null: false
      t.integer :stars
      t.integer :commits_past_year
      t.datetime :last_commit_at
      t.integer :repo_count
      t.integer :category_count
      t.timestamps
    end

    create_table :categories do |t|
      t.belongs_to :awesome_list_version, foreign_key: true, null: false
      t.belongs_to :parent, foreign_key: {to_table: :categories}
      t.string :name, null: false
      t.integer :repo_count
      t.timestamps
    end

    create_table :repo_stats do |t|
      t.belongs_to :awesome_list_version, foreign_key: true, null: false
      t.integer :stars
      t.integer :commits_past_year
      t.datetime :last_commit_at
      t.timestamps
    end
  end
end
