# frozen_string_literal: true

class PersistParsedCategoriesOperation
  include Dry::Monads[:result, :do]

  def call(awesome_list:, parsed_categories:)
    return Success([]) if parsed_categories.blank?

    categories = []

    # Build a lookup of existing items by github_repo to preserve their stats
    existing_items_by_repo = {}
    awesome_list.category_items.where.not(github_repo: [nil, '']).find_each do |item|
      existing_items_by_repo[item.github_repo] = {
        stars: item.stars,
        last_commit_at: item.last_commit_at,
        stars_30d: item.stars_30d,
        stars_90d: item.stars_90d,
        star_history_fetched_at: item.star_history_fetched_at
      }
    end

    # Clear all existing categories for this awesome list to ensure clean state
    awesome_list.categories.destroy_all

    parsed_categories.each do |category_data|
      # Handle both hash and struct formats
      category_name = category_data.respond_to?(:name) ? category_data.name : category_data[:name]
      category_items = if category_data.respond_to?(:repos)
                         category_data.repos
                       else
                         category_data[:items] || category_data[:repos]
                       end

      # Create the category
      category = Category.create!(
        awesome_list:,
        name: category_name
      )

      # Create category items
      category_items.each do |item_data|
        # Handle both hash and struct formats for items
        item_attrs = if item_data.respond_to?(:to_h)
                       item_data.to_h
                     else
                       item_data
                     end

        # Preserve existing stats if available
        existing_stats = existing_items_by_repo[item_attrs[:github_repo]] || {}

        # Find or create repo if github_repo is present
        repo = if item_attrs[:github_repo].present?
                 Repo.find_or_create_by!(github_repo: item_attrs[:github_repo])
               end

        category.category_items.create!(
          demo_url: item_attrs[:demo_url],
          description: item_attrs[:description],
          github_repo: item_attrs[:github_repo],
          last_commit_at: item_attrs[:last_commit_at] || existing_stats[:last_commit_at],
          name: item_attrs[:name],
          primary_url: item_attrs[:primary_url],
          repo: repo,
          stars: item_attrs[:stars] || existing_stats[:stars],
          stars_30d: existing_stats[:stars_30d],
          stars_90d: existing_stats[:stars_90d],
          star_history_fetched_at: existing_stats[:star_history_fetched_at]
        )
      end

      categories << category
    end

    Success(categories)
  rescue ActiveRecord::RecordInvalid => e
    Failure("Failed to persist categories: #{e.message}")
  rescue StandardError => e
    Failure("Failed to persist categories: #{e.message}")
  end
end
