# frozen_string_literal: true

class H3AwesomeListAdapter < BaseParserAdapter
  # Alternative awesome list format that uses H3 headers:
  # ### Category Name
  # * [Item Name](https://url): Description
  # * [Another Item](https://url): Another description

  HEADER_REGEX = /^(#+)\s+(.+)$/
  LINK_ITEM_REGEX = /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\s*[:]-?\s*(?<description>.+))?/

  def matches?(content)
    return false if content.blank?

    # Check for H3 headers and asterisk-based list items
    has_h3_headers = content.match?(/^###\s+.+$/m)
    has_asterisk_links = content.match?(/^\s*\*\s*\[.+?\]\(.+?\)/m)

    # Check counts
    h3_count = content.scan(/^###\s+.+$/).size
    link_count = content.scan(/^\s*\*\s*\[.+?\]\(.+?\)/).size

    # This adapter matches if there are H3 headers and no H2 headers for categories
    h2_category_count = content.scan(/^##\s+(?!License|Contributing|Table of Contents|Contents|Acknowledgments|Credits).+$/).size

    has_h3_headers && has_asterisk_links && h3_count >= 1 && link_count >= 5 && h2_category_count == 0
  end

  def priority
    15 # Higher priority than standard adapter
  end

  def parse(content, skip_external_links: false)
    return Success([]) if content.blank?

    categories_result = []
    current_category_name = nil
    current_category_order = -1
    current_items_buffer = []
    item_id_counter = 0

    building_item_attrs = nil

    flush_building_item_to_current_items = lambda do
      if building_item_attrs
        extract_source_code_url(building_item_attrs[:description])
        demo_url = extract_demo_url(building_item_attrs[:description])

        github_url = building_item_attrs[:github_repo] ? "https://github.com/#{building_item_attrs[:github_repo]}" : nil
        primary_url = github_url || building_item_attrs[:url]

        # Skip external links if requested
        if skip_external_links && !github_url
          building_item_attrs = nil
          return
        end

        # Clean the description
        cleaned_description = clean_description(building_item_attrs[:description])

        current_items_buffer << {
          demo_url:,
          description: cleaned_description,
          github_repo: building_item_attrs[:github_repo],
          id: item_id_counter,
          name: building_item_attrs[:name],
          primary_url:
        }

        item_id_counter += 1
        building_item_attrs = nil
      end
    end

    flush_current_category_to_result = lambda do
      if current_category_name && current_items_buffer.any?
        categories_result << {
          custom_order: current_category_order,
          items: current_items_buffer.dup,
          name: current_category_name
        }
      end
      current_items_buffer.clear
      current_category_order += 1
    end

    content.lines.each do |line|
      # Check for headers
      if (match = HEADER_REGEX.match(line))
        level = match[1].length
        title = match[2].strip

        # Process H3 headers as categories (not H2)
        if level == 3
          # Skip certain headers that aren't categories
          if title.match?(/^(Contents?|Table of Contents?|Contributing|License|Acknowledgments?|Credits?|Related Lists?)$/i)
            next
          end

          flush_building_item_to_current_items.call
          flush_current_category_to_result.call
          current_category_name = title
        end
      # Check for list items with links
      elsif current_category_name && (match = LINK_ITEM_REGEX.match(line))
        flush_building_item_to_current_items.call

        name = match[:name].strip
        url = match[:url].strip
        description = match[:description]&.strip

        # Extract GitHub repo if present
        github_repo = extract_github_repo(url)

        building_item_attrs = {
          description:,
          github_repo:,
          name:,
          url:
        }
      # Handle continuation lines for descriptions
      elsif building_item_attrs && line.strip.present? && !line.start_with?('#')
        # Append to description if the line doesn't start a new list item
        unless line.match?(/^\s*[-*]/)
          building_item_attrs[:description] = [
            building_item_attrs[:description],
            line.strip
          ].compact.join(' ')
        end
      end
    end

    # Flush any remaining data
    flush_building_item_to_current_items.call
    flush_current_category_to_result.call

    Success(categories_result)
  rescue StandardError => e
    Failure("Failed to parse markdown: #{e.message}")
  end
end
