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
  GITHUB_REPO_REGEX = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/#]+?)(?:/|\.git|#|$)}
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

        # Determine URLs based on the new schema - prioritize GitHub URLs
        original_primary_url = building_item_attrs[:url]
        github_repo = nil
        final_primary_url = original_primary_url

        # Check if primary URL is GitHub
        primary_url_is_github = GITHUB_REPO_REGEX.match?(original_primary_url)

        # If we have a GitHub source code URL, prioritize it over external primary URL
        if source_code_url && GITHUB_REPO_REGEX.match?(source_code_url)
          github_match = GITHUB_REPO_REGEX.match(source_code_url)
          github_repo = "#{github_match[:owner]}/#{github_match[:repo]}"
          # Use GitHub URL as primary URL instead of external website
          final_primary_url = "https://github.com/#{github_repo}"
        elsif primary_url_is_github
          # If primary URL is GitHub, extract repo from it and clean the URL
          github_match = GITHUB_REPO_REGEX.match(original_primary_url)
          github_repo = "#{github_match[:owner]}/#{github_match[:repo]}"
          # Clean the primary_url to remove fragments like #readme
          final_primary_url = "https://github.com/#{github_repo}"
        end

        # When skip_external_links is true, only include items that have GitHub repos
        # When skip_external_links is false, include all items
        should_include_item = if skip_external_links
                                !github_repo.nil?
        else
                                true
        end

        if should_include_item
          current_items_buffer << {
            demo_url:,
            description: strip_html_tags(building_item_attrs[:description]),
            github_repo:,
            id: building_item_attrs[:id],
            name: building_item_attrs[:name],
            primary_url: final_primary_url
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

  # Strip HTML tags and remove all markdown links from description text
  # Returns nil if description is nil, otherwise returns cleaned text
  def strip_html_tags(description)
    return nil if description.nil?

    # Use Rails' built-in strip_tags helper which is more robust than regex
    cleaned = ActionView::Base.full_sanitizer.sanitize(description)

    # Remove all markdown links [text](url) from descriptions
    # This removes any links since we already extract important URLs to dedicated fields
    cleaned = cleaned&.gsub(/\[[^\]]*\]\([^)]+\)/, "")

    # Remove any remaining empty parenthetical groups like "(, )" or "()"
    cleaned = cleaned&.gsub(/\(\s*[,\s]*\s*\)/, "")

    # Clean up extra commas and spaces that might be left behind
    cleaned = cleaned&.gsub(/\s*,\s*,\s*/, ", ") # Multiple commas
    cleaned = cleaned&.gsub(/^\s*,\s*|\s*,\s*$/, "") # Leading/trailing commas

    # Clean up extra whitespace but preserve intentional line breaks
    cleaned&.gsub(/[ \t]+/, " ")&.gsub(/\n\s*\n/, "\n")&.strip
  end
end
