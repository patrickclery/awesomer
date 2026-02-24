# frozen_string_literal: true

class GenerateMarkdownJob < ApplicationJob
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  queue_as :markdown_processing

  def perform(categories:, output_options: {}, repo_identifier: nil)
    Rails.logger.info 'Generating markdown with collected stats'

    # Convert hash data back to structs if needed
    category_structs = categories.map do |category_data|
      if category_data.is_a?(Hash)
        # Handle both :items (from ParseMarkdownOperation) and :repos (from Structs::Category)
        items_data = category_data[:items] || category_data[:repos] || []
        repos = items_data.map { |repo_data| Structs::CategoryItem.new(repo_data) }
        Structs::Category.new(
          custom_order: category_data[:custom_order],
          name: category_data[:name],
          repos:
        )
      else
        category_data # Already a struct
      end
    end

    # Update categories with cached stats
    updated_categories = category_structs.map do |category|
      updated_repos = category.repos.map do |repo_item|
        update_key = "category_item_update:#{repo_item.to_h[:id] || repo_item.url}"
        cached_update = Rails.cache.read(update_key)

        if cached_update && cached_update[:stats]
          stats = cached_update[:stats]
          # Create new CategoryItem with updated stats
          current_attrs = repo_item.to_h
          new_attrs = current_attrs.merge(
            last_commit_at: stats[:last_commit_at],
            stars: stats[:stars]
          )
          Structs::CategoryItem.new(new_attrs)
        else
          # No stats found, keep original item
          Rails.logger.warn "No cached stats found for #{repo_item.name} (#{repo_item.url})"
          repo_item
        end
      end

      # Create new Category with updated repos
      Structs::Category.new(
        custom_order: category.custom_order,
        name: category.name,
        repos: updated_repos
      )
    end

    # Generate the markdown using ProcessCategoryService
    result = yield ProcessCategoryService.new.call(
      categories: updated_categories,
      repo_identifier:
    )

    Rails.logger.info "Successfully generated markdown file: #{result}"

    # Clean up cache entries
    cleanup_cache_entries(category_structs)

    result
  end

  private

  def cleanup_cache_entries(categories)
    categories.each do |category|
      category.repos.each do |repo_item|
        update_key = "category_item_update:#{repo_item.to_h[:id] || repo_item.url}"
        Rails.cache.delete(update_key)
      end
    end
    Rails.logger.info 'Cleaned up cache entries'
  end
end
