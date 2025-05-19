# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.references :awesome_list_version, foreign_key: true, null: false
      t.references :parent, foreign_key: true, null: false
      t.string :name
      t.integer :repo_count

      t.timestamps
    end
  end
end
