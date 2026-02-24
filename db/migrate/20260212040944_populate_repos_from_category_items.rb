class PopulateReposFromCategoryItems < ActiveRecord::Migration[8.0]
  def up
    # Get all unique github_repos from category_items
    execute <<~SQL
      INSERT INTO repos (github_repo, stars, previous_stars, last_commit_at, stars_30d, stars_90d, star_history_fetched_at, created_at, updated_at)
      SELECT DISTINCT ON (ci.github_repo)
        ci.github_repo,
        ci.stars,
        ci.previous_stars,
        ci.last_commit_at,
        ci.stars_30d,
        ci.stars_90d,
        ci.star_history_fetched_at,
        NOW(),
        NOW()
      FROM category_items ci
      WHERE ci.github_repo IS NOT NULL AND ci.github_repo != ''
      ORDER BY ci.github_repo, ci.stars DESC NULLS LAST
    SQL

    # Link category_items to their repos
    execute <<~SQL
      UPDATE category_items
      SET repo_id = repos.id
      FROM repos
      WHERE category_items.github_repo = repos.github_repo
        AND category_items.github_repo IS NOT NULL
        AND category_items.github_repo != ''
    SQL
  end

  def down
    execute "UPDATE category_items SET repo_id = NULL"
    execute "DELETE FROM repos"
  end
end
