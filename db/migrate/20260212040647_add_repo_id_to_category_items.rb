class AddRepoIdToCategoryItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :category_items, :repo, foreign_key: true, null: true
  end
end
