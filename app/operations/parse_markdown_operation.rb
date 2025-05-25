# frozen_string_literal: true

# require_relative "../structs/category"
# require_relative "../structs/category_item"

class ParseMarkdownOperation
  # noinspection RubyResolve
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
  # LINK_ITEM_REGEX captures name, URL, and optional description.
  # Description is capture group :description.
  LINK_ITEM_REGEX = /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\s*-\s*(?<description>.+))?/
  GITHUB_REPO_REGEX = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}
  # Regex to find "Source Code" links in descriptions
  SOURCE_CODE_LINK_REGEX = /\[Source Code\]\(([^)]+)\)/i
  # Regex to find "Demo" links in descriptions
  DEMO_LINK_REGEX = /\[Demo\]\(([^)]+)\)/i

  # Added skip_external_links parameter, defaulting to false (process all links by default)
  # If true, only GitHub links will be processed. Non-GitHub links will be skipped.
  # Categories with no processable items (after skipping) will also be skipped.
  def call(markdown_content:, skip_external_links: false)
    return Success([]) if markdown_content.blank?

    categories_result = []
    current_category_name = nil
    current_category_order = -1
    current_items_buffer = []
    item_id_counter = 0

    # Temp storage for the item currently being built (attributes hash)
    building_item_attrs = nil

    flush_building_item_to_current_items = lambda do
      if building_item_attrs
        # Extract different URL types from the description
        source_code_url = extract_source_code_url(building_item_attrs[:description])
        demo_url = extract_demo_url(building_item_attrs[:description])

        # Determine URLs based on the new schema
        primary_url = building_item_attrs[:url]
        github_repo = nil

        # If we have a source code URL, extract the repo identifier
        if source_code_url && GITHUB_REPO_REGEX.match?(source_code_url)
          github_match = GITHUB_REPO_REGEX.match(source_code_url)
          github_repo = "#{github_match[:owner]}/#{github_match[:repo]}"
        elsif GITHUB_REPO_REGEX.match?(primary_url)
          # If primary URL is GitHub, extract repo from it
          github_match = GITHUB_REPO_REGEX.match(primary_url)
          github_repo = "#{github_match[:owner]}/#{github_match[:repo]}"
        end

        # Skip external links if requested and no GitHub repo found
        unless skip_external_links && github_repo.nil?
          current_items_buffer << {
            demo_url:,
            description: building_item_attrs[:description],
            github_repo:,
            id: building_item_attrs[:id],
            name: building_item_attrs[:name],
            primary_url:
          }
        end
        building_item_attrs = nil
      end
    end

    finalize_current_category = lambda do
      flush_building_item_to_current_items.call # Ensure last item of category is flushed
      if current_category_name && current_items_buffer.any?
        categories_result << {
          custom_order: current_category_order,
          items: current_items_buffer,
          name: current_category_name
        }
      end
      current_items_buffer = []
      current_category_name = nil # Mark as no active category
    end

    markdown_content.lines.each do |line|
      stripped_line = line.strip
      next if stripped_line.empty?

      header_match = HEADER_REGEX.match(stripped_line)
      if header_match && header_match[1].length.between?(2, 6)
        finalize_current_category.call # Finalize previous category before starting new one
        current_category_name = header_match[2].strip
        current_category_order += 1
      elsif current_category_name && (link_match = LINK_ITEM_REGEX.match(stripped_line))
        flush_building_item_to_current_items.call # Finalize previous item before starting new one

        item_id_counter += 1
        building_item_attrs = {
          description: link_match[:description]&.strip,
          id: item_id_counter,
          name: link_match[:name].strip,
          url: link_match[:url].strip
        }
      elsif building_item_attrs && current_category_name && # If we are building an item
            !stripped_line.start_with?("- ", "* ", "+ ") && # And it's not a new list marker
            !HEADER_REGEX.match(stripped_line) # And it's not a new header
        # This line is a continuation of the current building_item_attrs' description
        if building_item_attrs[:description].nil?
          building_item_attrs[:description] = stripped_line
        else
          building_item_attrs[:description] += "\n" + stripped_line
        end
      else
        # Not a header, not a new link item, not a continuation of a link item's description
        # This means any `building_item_attrs` should be flushed if it exists.
        flush_building_item_to_current_items.call
      end
    end

    finalize_current_category.call # Finalize the last category after loop

    Success(categories_result)
  rescue StandardError => e
    Failure("Failed to parse markdown: #{e.message}")
  end

  private

  # Extract the URL from a "Source Code" link in the description
  # Returns nil if no Source Code link is found
  def extract_source_code_url(description)
    return nil if description.nil?

    match = SOURCE_CODE_LINK_REGEX.match(description)
    match&.[](1)&.strip
  end

  # Extract the URL from a "Demo" link in the description
  # Returns nil if no Demo link is found
  def extract_demo_url(description)
    return nil if description.nil?

    match = DEMO_LINK_REGEX.match(description)
    match&.[](1)&.strip
  end
end
