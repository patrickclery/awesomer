# frozen_string_literal: true

class AddPreviousStarsToCategoryItems < ActiveRecord::Migration[8.0]
  def change
    add_column :category_items, :previous_stars, :integer
    add_index :category_items, %i[stars previous_stars]
  end
end
