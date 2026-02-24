class AddStars7dToRepos < ActiveRecord::Migration[8.0]
  def change
    add_column :repos, :stars_7d, :integer
  end
end
