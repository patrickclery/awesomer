# frozen_string_literal: true

class PersistParsedCategoriesOperation
  include Dry::Monads[:result, :do]

  def call(awesome_list:, parsed_categories:)
    return Success([]) if parsed_categories.blank?

    categories = []

    # Clear all existing categories for this awesome list to ensure clean state
    awesome_list.categories.destroy_all

    parsed_categories.each do |category_data|
      # Create the category
      category = Category.create!(
        awesome_list:,
        name: category_data[:name]
      )

      # Create category items
      category_data[:items].each do |item_data|
        category.category_items.create!(
          demo_url: item_data[:demo_url],
          description: item_data[:description],
          github_repo: item_data[:github_repo],
          name: item_data[:name],
          primary_url: item_data[:primary_url]
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
