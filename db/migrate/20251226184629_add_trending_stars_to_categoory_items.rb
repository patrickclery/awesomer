class AddTrendingStarsToCategooryItems < ActiveRecord::Migration[8.0]
  def change
    add_column :category_items, :stars_30d, :integer
    add_column :category_items, :stars_90d, :integer
    add_column :category_items, :star_history_fetched_at, :datetime
  end
end
