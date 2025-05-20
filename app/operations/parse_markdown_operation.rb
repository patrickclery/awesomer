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
  LINK_ITEM_REGEX = /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\s*-\s*(?<description>.+))?/ # Description is capture group 3
  GITHUB_REPO_REGEX = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}

  def call(markdown_content:)
    return Success([]) if markdown_content.blank?

    categories = []
    current_category_data = nil
    current_items = []
    item_id_counter = 0
    category_order_counter = 0
    # To handle multi-line descriptions for LINK_ITEM_REGEX items
    last_link_item_data = nil

    markdown_content.lines.each_with_index do |line, index|
      stripped_line = line.strip
      next if stripped_line.empty?

      header_match = HEADER_REGEX.match(stripped_line)
      if header_match && header_match[1].length.between?(2, 6) # Check if hashes are between 2 and 6
        # Finalize the last item's description if one was being accumulated
        if last_link_item_data && !current_items.empty? && current_items.last.respond_to?(:new)
          current_items[-1] = current_items.last.new(description: last_link_item_data[:description].strip) if last_link_item_data[:description]
        end
        last_link_item_data = nil # Reset for new category

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
        # Finalize the previous item's description before starting a new one
        if last_link_item_data && !current_items.empty? && current_items.last.respond_to?(:new)
          current_items[-1] = current_items.last.new(description: last_link_item_data[:description].strip) if last_link_item_data[:description]
        end

        item_id_counter += 1
        item_name = link_match[:name].strip
        item_url = link_match[:url].strip
        # Capture the initial description part from the regex
        item_description = link_match[:description]&.strip

        last_link_item_data = {
          description: item_description,
          id: item_id_counter,
          name: item_name,
          url: item_url # Start with description from the first line
        }
        # Create the item, description might be appended to later
        current_items << Structs::CategoryItem.new(last_link_item_data.slice(:id, :name, :url, :description))
      elsif last_link_item_data && !last_link_item_data[:description].nil? && current_category_data && !stripped_line.start_with?("* ", "- ", "+ ") && !HEADER_REGEX.match(stripped_line)
        # This line is a continuation of the previous link item's description, only if a description was started on the first line
        last_link_item_data[:description] = "#{last_link_item_data[:description]}\n#{stripped_line}".strip
      else
        # If it's not a header, not a link item, and not a continuation, finalize previous item
        if last_link_item_data && !current_items.empty? && current_items.last.respond_to?(:new)
          current_items[-1] = current_items.last.new(description: last_link_item_data[:description].strip) if last_link_item_data[:description]
        end
        last_link_item_data = nil # Reset as this line is not part of the previous link item
      end
    end

    # Finalize the very last item's description after loop
    if last_link_item_data && !current_items.empty? && current_items.last.respond_to?(:new)
      current_items[-1] = current_items.last.new(description: last_link_item_data[:description].strip) if last_link_item_data[:description]
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
