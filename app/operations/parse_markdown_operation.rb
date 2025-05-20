# frozen_string_literal: true

# require_relative "../structs/category"
# require_relative "../structs/category_item"

class ParseMarkdownOperation
  include Dry::Monads[:result, :do]

  # A very basic Markdown parser focusing on H2 headers and lists.
  # This is a simplified initial implementation.
  #
  # Expected structure:
  # ## Category 1
  # - Item 1.1
  # - Item 1.2
  # ## Category 2
  # - Item 2.1

  HEADER_REGEX = /^(#+)\s+(.+)$/ # Match one or more hashes, then space, then title
  LINK_ITEM_REGEX = /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\s*-\s*(?<description>.+))?/
  GITHUB_REPO_REGEX = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}

  def call(markdown_content:)
    return Success([]) if markdown_content.blank?

    categories = []
    current_category_data = nil
    current_items = []
    item_id_counter = 0
    category_order_counter = 0

    markdown_content.lines.each_with_index do |line, index|
      stripped_line = line.strip
      next if stripped_line.empty?

      header_match = HEADER_REGEX.match(stripped_line)
      if header_match && header_match[1].length.between?(2, 6) # Check if hashes are between 2 and 6
        if current_category_data
          categories << Structs::Category.new(
            custom_order: current_category_data[:custom_order],
            name: current_category_data[:name],
            repos: current_items
          )
        end
        category_name = header_match[2].strip # Group 2 is the category name text
        current_category_data = {custom_order: category_order_counter, name: category_name}
        current_items = []
        category_order_counter += 1
      elsif current_category_data && (link_match = LINK_ITEM_REGEX.match(stripped_line))
        item_id_counter += 1
        item_name = link_match[:name].strip
        item_url = link_match[:url].strip
        # item_description = link_match[:description]&.strip # Description not used by CategoryItem

        item_data = {
          id: item_id_counter,
          name: item_name,
          url: item_url
        }
        current_items << Structs::CategoryItem.new(item_data)
      elsif current_category_data && !current_items.empty? && !line.match?(/^#/) && !line.match?(/^\s*[-*]\s*/)
        # This part attempts to append to the description of the *last parsed item if Link had a description*
        # Since Link struct does not have a description, and the logic was to append to a hash,
        # this part might need reconsideration or removal if descriptions are not handled by Link structs.
        # For now, this won't do anything as current_items.last is a Link struct, not a hash with :description.
      end
    end

    if current_category_data # Add the last processed category
      categories << Structs::Category.new(
        custom_order: current_category_data[:custom_order],
        name: current_category_data[:name],
        repos: current_items
      )
    end

    Success(categories)
  rescue Dry::Struct::Error => e # Catch specific struct errors for better diagnostics
    Failure("Failed to parse markdown (Struct error): #{e.message}")
  rescue StandardError => e
    Failure("Failed to parse markdown (Standard error): #{e.message}")
  end
end
