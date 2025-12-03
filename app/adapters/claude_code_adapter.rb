# frozen_string_literal: true

class ClaudeCodeAdapter < BaseParserAdapter
  # Claude Code awesome list format:
  # ## Category Name
  #
  # [`Project Name`](https://github.com/user/repo) &nbsp; by &nbsp; [author](profile) &nbsp;&nbsp;⚖️&nbsp;&nbsp;License
  # Description on the next line

  HEADER_REGEX = /^##\s+(.+)$/
  # Match the claude-code specific format with backticks and metadata
  ITEM_REGEX = /^\[`([^`]+)`\]\(([^)]+)\)\s*(?:&nbsp;.*?by\s*&nbsp;\s*\[([^\]]+)\]\([^)]+\))?\s*
                (?:&nbsp;&nbsp;.*?&nbsp;&nbsp;(.+?))?$/x
  # Also match simpler format without backticks
  SIMPLE_ITEM_REGEX = /^\[([^\]]+)\]\(([^)]+)\)\s*(?:&nbsp;.*?by\s*&nbsp;\s*\[([^\]]+)\]\([^)]+\))?\s*
                       (?:&nbsp;&nbsp;.*?&nbsp;&nbsp;(.+?))?$/x

  def matches?(content)
    return false if content.blank?

    # Check for claude-code specific patterns:
    # 1. Has the backtick format [`name`](url) - this is the key differentiator
    has_backtick_format = content.match?(/\[`[^`]+`\]\([^)]+\)/)

    # 2. Has "by" attribution pattern with &nbsp;
    has_by_pattern = content.match?(/&nbsp;\s*by\s*&nbsp;/i)

    # 3. Check if this IS the awesome-claude-code repo (title at top, not just a link)
    is_claude_code_repo = content.match?(/^#\s+awesome-claude-code/i)

    # Must have BOTH backtick format AND by pattern, or be the specific repo
    is_claude_code_repo || (has_backtick_format && has_by_pattern)
  end

  def priority
    20 # Higher priority when detected, as it's more specific
  end

  def parse(content, skip_external_links: false)
    return Success([]) if content.blank?

    categories_result = []
    current_category = nil
    current_items = []
    building_item = nil
    lines = content.lines

    flush_item = lambda do
      if building_item && building_item[:name]
        # Skip external links if requested
        current_items << building_item if !skip_external_links || building_item[:github_repo]
        building_item = nil
      end
    end

    flush_category = lambda do
      if current_category && current_items.any?
        categories_result << {
          custom_order: categories_result.size,
          items: current_items.dup,
          name: current_category
        }
      end
      current_items.clear
    end

    lines.each_with_index do |line, _index|
      stripped = line.strip

      # Check for headers (categories)
      if (match = HEADER_REGEX.match(line))
        title = match[1].strip

        # Skip meta headers
        next if title.match?(/^(This Week|Contents?|Contributing|Announcements?|Table of Contents?)/i)

        # Remove emoji and clean up
        title = title.gsub(/[🧠🧰📊🪝🔪🌻✨]/, '').strip

        flush_item.call
        flush_category.call
        current_category = title

      # Check for item in claude-code format
      elsif current_category && (match = ITEM_REGEX.match(stripped) || SIMPLE_ITEM_REGEX.match(stripped))
        flush_item.call

        name = match[1].strip
        url = match[2].strip
        match[3]&.strip
        match[4]&.strip

        github_repo = extract_github_repo(url)

        building_item = {
          demo_url: nil,
          description: nil,
          github_repo:,
          name:,
          primary_url: url
        }

      # Don't add author and license to description - they're already in the original format
      # and adding them here creates redundancy in the output

      # Check if next line is a description (for multi-line format)
      elsif building_item && stripped.present? && !stripped.start_with?('[') &&
            !stripped.start_with?('#') && !stripped.start_with?('>') &&
            !stripped.start_with?('<details') && !stripped.start_with?('<summary') &&
            !stripped.start_with?('</details') && !stripped.start_with?('<br')
        # This is likely a description line (but not HTML tags)
        if building_item[:description]
          building_item[:description] += " #{stripped}"
        else
          building_item[:description] = stripped
        end

      # Stop building description when we hit HTML details/summary blocks
      elsif building_item && stripped.start_with?('<details', '<summary')
        # Flush the current item - we've reached the end of the description
        flush_item.call

      # Handle standalone links that might be items
      elsif current_category && stripped.match?(/^\[.+\]\(.+\)/)
        # Try to parse as a simple link
        if (match = /^\[([^\]]+)\]\(([^)]+)\)(.*)/.match(stripped))
          flush_item.call

          name = match[1].strip
          url = match[2].strip
          rest = match[3].strip

          github_repo = extract_github_repo(url)

          building_item = {
            demo_url: nil,
            description: rest.empty? ? nil : rest.gsub(/^\s*-\s*/, ''),
            github_repo:,
            name:,
            primary_url: url
          }
        end
      end
    end

    # Flush any remaining data
    flush_item.call
    flush_category.call

    Success(categories_result)
  rescue StandardError => e
    Failure("Failed to parse claude-code format: #{e.message}")
  end
end
