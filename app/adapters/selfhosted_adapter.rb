# frozen_string_literal: true

class SelfhostedAdapter < BaseParserAdapter
  # Awesome-Selfhosted format:
  # ## Software (parent section - ignore)
  # ### Category Name
  # - [Item Name](https://url) - Description. ([Demo](url), [Source Code](url)) `License` `Language`

  HEADER_REGEX = /^(#+)\s+(.+)$/
  # Match items: - [Name](url) - Description...
  LINK_ITEM_REGEX = /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\s*[-–—]\s*(?<description>.+))?/

  def matches?(content)
    return false if content.blank?

    # Check for awesome-selfhosted specific patterns:
    # 1. Has ## Software as a parent section
    has_software_section = content.match?(/^##\s+Software\s*$/m)

    # 2. Has ### Category headers underneath
    has_h3_categories = content.match?(/^###\s+.+$/m)

    # 3. Has list items with the specific format including backtick license/language tags
    has_backtick_metadata = content.match?(/`[A-Z]+-[\d.]+`\s*`[A-Za-z]+`/)

    # 4. Has back to top links (unique to selfhosted format)
    has_back_to_top = content.include?('back to top')

    # Strong match if it has the Software section with H3 categories
    return true if has_software_section && has_h3_categories

    # Also match if it has the specific metadata format
    has_h3_categories && (has_backtick_metadata || has_back_to_top)
  end

  def priority
    25 # Higher priority than other adapters for this specific format
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
    in_software_section = false

    building_item_attrs = nil

    flush_building_item_to_current_items = lambda do
      if building_item_attrs
        # Extract source code URL (may override the primary URL)
        source_code_url = extract_source_code_url(building_item_attrs[:description])
        demo_url = extract_demo_url(building_item_attrs[:description])

        # If there's a source code link, use it to extract the github repo
        github_repo = if source_code_url
                        extract_github_repo(source_code_url)
                      else
                        building_item_attrs[:github_repo]
                      end

        github_url = github_repo ? "https://github.com/#{github_repo}" : nil
        primary_url = github_url || building_item_attrs[:url]

        # Skip external links if requested
        if skip_external_links && !github_repo
          building_item_attrs = nil
          return
        end

        # Clean the description (remove links, license tags, etc.)
        cleaned_description = clean_selfhosted_description(building_item_attrs[:description])

        current_items_buffer << {
          demo_url:,
          description: cleaned_description,
          github_repo:,
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

        # Track when we enter the Software section
        if level == 2 && title == 'Software'
          in_software_section = true
          next
        end

        # Exit Software section when we hit another H2
        if level == 2 && title != 'Software'
          in_software_section = false
          # Also check for External Links which might be a valid category
          if title == 'External Links'
            flush_building_item_to_current_items.call
            flush_current_category_to_result.call
            current_category_name = title
          end
          next
        end

        # Process H3 headers as categories when in Software section
        if level == 3 && in_software_section
          # Skip certain meta headers
          next if title.match?(/^(Contents?|Table of Contents?|Contributing|License|Acknowledgments?|Credits?)$/i)

          # Clean the title - remove "back to top" links and other artifacts
          clean_title = title.gsub(/\*\*\[`\^.*?\^`\].*?\*\*/, '').strip

          flush_building_item_to_current_items.call
          flush_current_category_to_result.call
          current_category_name = clean_title
        end
      # Check for list items with links
      elsif current_category_name && (match = LINK_ITEM_REGEX.match(line))
        flush_building_item_to_current_items.call

        name = match[:name].strip
        url = match[:url].strip
        description = match[:description]&.strip

        # Extract GitHub repo if present in the main URL
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
    Failure("Failed to parse selfhosted format: #{e.message}")
  end

  private

  def clean_selfhosted_description(description)
    return nil unless description

    cleaned = description.dup

    # Remove [Source Code](url) links
    cleaned.gsub!(/\[Source Code\]\([^)]+\)/i, '')

    # Remove [Demo](url) links
    cleaned.gsub!(/\[Demo\]\([^)]+\)/i, '')

    # Remove backtick-wrapped license and language tags like `MIT` `Python/Docker`
    cleaned.gsub!(/`[^`]+`/, '')

    # Remove warning emoji and marker
    cleaned.gsub!(/`⚠`/, '')
    cleaned.gsub!(/⚠/, '')

    # Remove parentheses that are now empty or only contain commas/spaces
    cleaned.gsub!(/\(\s*,?\s*,?\s*\)/, '')
    cleaned.gsub!(/\(\s*\)/, '')

    # Remove trailing punctuation artifacts
    cleaned.gsub!(/\s*,\s*,\s*/, ' ')
    cleaned.gsub!(/\s+\.?\s*$/, '')

    # Clean up multiple spaces
    cleaned.gsub!(/\s+/, ' ')

    cleaned.strip!
    cleaned.empty? ? nil : cleaned
  end
end
