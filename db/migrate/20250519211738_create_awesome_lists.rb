# frozen_string_literal: true

class CreateAwesomeLists < ActiveRecord::Migration[8.0]
  def change
    create_table :awesome_lists do |t|
      t.string :name
      t.text :description
      t.string :github_repo

      t.timestamps
    end
  end
end
