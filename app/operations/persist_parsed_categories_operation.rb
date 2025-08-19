# frozen_string_literal: true

class PersistParsedCategoriesOperation
  include Dry::Monads[:result, :do]

  def call(awesome_list:, parsed_categories:)
    return Success([]) if parsed_categories.blank?

    categories = []

    # Clear all existing categories for this awesome list to ensure clean state
    awesome_list.categories.destroy_all

    parsed_categories.each do |category_data|
      # Handle both hash and struct formats
      category_name = category_data.respond_to?(:name) ? category_data.name : category_data[:name]
      category_items = category_data.respond_to?(:repos) ? category_data.repos : (category_data[:items] || category_data[:repos])
      
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
        
        category.category_items.create!(
          demo_url: item_attrs[:demo_url],
          description: item_attrs[:description],
          github_repo: item_attrs[:github_repo],
          name: item_attrs[:name],
          primary_url: item_attrs[:primary_url],
          stars: item_attrs[:stars],
          last_commit_at: item_attrs[:last_commit_at]
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
