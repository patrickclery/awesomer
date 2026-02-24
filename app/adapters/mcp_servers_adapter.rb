# frozen_string_literal: true

class McpServersAdapter < BaseParserAdapter
  # Awesome-MCP-Servers format:
  # ## Server Implementations (parent section - ignore)
  # ### 🔗 <a name="aggregators"></a>Aggregators
  # - [name](url) 📇 ☁️ - Description

  HEADER_REGEX = /^(#+)\s+(.+)$/
  # Match items: - [Name](url) emoji - Description...
  LINK_ITEM_REGEX = /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)\s*(?<description>.+)?/

  def matches?(content)
    return false if content.blank?

    # Check for awesome-mcp-servers specific patterns:
    # 1. Has ## Server Implementations as a parent section
    has_server_implementations = content.match?(/^##\s+Server Implementations\s*$/m)

    # 2. Has ### Category headers with anchor tags
    has_anchor_categories = content.match?(/<a name="[^"]+"><\/a>/i)

    # 3. Has MCP-related content
    has_mcp_content = content.match?(/MCP|Model Context Protocol/i)

    # Must have server implementations section OR (anchor categories AND mcp content)
    has_server_implementations || (has_anchor_categories && has_mcp_content)
  end

  def priority
    26 # Higher than SelfhostedAdapter
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
    in_server_section = false

    building_item_attrs = nil

    flush_building_item_to_current_items = lambda do
      if building_item_attrs
        github_repo = building_item_attrs[:github_repo]
        github_url = github_repo ? "https://github.com/#{github_repo}" : nil
        primary_url = github_url || building_item_attrs[:url]

        # Skip external links if requested
        if skip_external_links && !github_repo
          building_item_attrs = nil
          return
        end

        # Clean the description
        cleaned_description = clean_mcp_description(building_item_attrs[:description])

        current_items_buffer << {
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

        # Track when we enter the Server Implementations section
        if level == 2 && title == 'Server Implementations'
          in_server_section = true
          next
        end

        # Exit Server Implementations section when we hit another H2
        if level == 2 && title != 'Server Implementations'
          # Check if we were in server section - if so, we're done with categories
          if in_server_section
            flush_building_item_to_current_items.call
            flush_current_category_to_result.call
          end
          in_server_section = false

          # Also capture Frameworks section
          if title == 'Frameworks'
            flush_building_item_to_current_items.call
            flush_current_category_to_result.call
            current_category_name = title
          end
          next
        end

        # Process H3 headers as categories when in Server Implementations section
        if level == 3 && in_server_section
          # Skip certain meta headers
          next if title.match?(/^(Contents?|Table of Contents?|Contributing|License|Legend)$/i)

          # Clean the title:
          # 1. Remove anchor tags like <a name="aggregators"></a>
          clean_title = title.gsub(/<a[^>]*>.*?<\/a>/i, '')

          # 2. Remove leading emoji (but keep for display if needed)
          clean_title = clean_title.gsub(/^[\p{Emoji}\s]+/, '')

          # 3. Strip any remaining whitespace
          clean_title = clean_title.strip

          next if clean_title.empty?

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
      elsif building_item_attrs && line.strip.present? && !line.start_with?('#') && !line.start_with?('>')
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
    Failure("Failed to parse mcp-servers format: #{e.message}")
  end

  private

  def clean_mcp_description(description)
    return nil unless description

    cleaned = description.dup

    # Remove emoji characters (programming language, scope, OS indicators)
    # Keep the text but remove standalone emojis
    cleaned.gsub!(/[\p{Emoji}&&[^\d#*]]\uFE0F?/, ' ')

    # Remove the leading dash if present
    cleaned.gsub!(/^\s*-\s*/, '')

    # Clean up multiple spaces
    cleaned.gsub!(/\s+/, ' ')

    cleaned.strip!
    cleaned.empty? ? nil : cleaned
  end
end
