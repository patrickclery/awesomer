# frozen_string_literal: true

class PiracyAdapter < BaseParserAdapter
  # Awesome-Piracy format:
  # ## Category Name
  # ### Subcategory Name
  # - [Item Name](url) Description without leading dash
  # - [Item Name](url) :star2: Description with star emoji

  HEADER_REGEX = /^(#+)\s+(.+)$/
  # Match items without requiring dash before description
  LINK_ITEM_REGEX = /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)\s*(?<description>.+)?/

  def matches?(content)
    return false if content.blank?

    # Check for awesome-piracy specific patterns:
    # 1. Has the "arrrrr" reference or piracy in title
    has_piracy_ref = content.match?(/piracy/i) || content.match?(/arrrr/i)

    # 2. Has star emoji ratings
    has_star_ratings = content.include?(':star2:')

    # 3. Has typical piracy categories
    has_piracy_categories = content.match?(/VPN|Torrent|Usenet|Seedbox/i)

    has_piracy_ref && (has_star_ratings || has_piracy_categories)
  end

  def priority
    22 # Higher than standard but lower than selfhosted
  end

  def parse(content, skip_external_links: false)
    return Success([]) if content.blank?

    # Ensure UTF-8 encoding
    content = content.dup.force_encoding('UTF-8')
    content.encode!('UTF-8', invalid: :replace, undef: :replace, replace: '')

    categories_result = []
    current_category_name = nil
    current_category_order = -1
    current_items_buffer = []
    item_id_counter = 0

    building_item_attrs = nil

    flush_building_item_to_current_items = lambda do
      if building_item_attrs
        demo_url = extract_demo_url(building_item_attrs[:description])

        github_url = building_item_attrs[:github_repo] ? "https://github.com/#{building_item_attrs[:github_repo]}" : nil
        primary_url = github_url || building_item_attrs[:url]

        # Skip external links if requested
        if skip_external_links && !building_item_attrs[:github_repo]
          building_item_attrs = nil
          return
        end

        # Clean the description
        cleaned_description = clean_piracy_description(building_item_attrs[:description])

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

        # Process H2 and H3 headers as categories
        if level == 2 || level == 3
          # Skip meta headers
          next if title.match?(/^(Contents?|Table of Contents?|Contributing|License|Preamble|Background|How to use|Emoji|Archival)$/i)

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
        unless line.match?(/^\s*[-*]\s*\[/)
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
    Failure("Failed to parse piracy format: #{e.message}")
  end

  private

  def clean_piracy_description(description)
    return nil unless description

    cleaned = description.dup

    # Remove star emoji
    cleaned.gsub!(/:star2:/, '')
    cleaned.gsub!(/⭐/, '')

    # Remove leading dashes if present
    cleaned.gsub!(/^\s*-\s*/, '')

    # Clean up multiple spaces
    cleaned.gsub!(/\s+/, ' ')

    cleaned.strip!
    cleaned.empty? ? nil : cleaned
  end
end
