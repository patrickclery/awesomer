# frozen_string_literal: true

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

  # Regex to capture typical Markdown link and optional description
  # Format: - [Name](URL) - Description
  # Or:     - [Name](URL)
  LINK_ITEM_REGEX = /^\s*[-*]\s*\[(?<name>[^\]]+)\]\((?<url>[^)]+)\)(?:\s*-\s*(?<description>.+))?/
  GITHUB_REPO_REGEX = %r{https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}

  def call(markdown_content:)
    return Success([]) if markdown_content.blank?

    parsed_structure = []
    current_category = nil
    accumulated_line = nil # For handling multi-line items

    markdown_content.lines.each do |line|
      stripped_line = line.strip
      next if stripped_line.empty? && accumulated_line.nil? # Skip empty lines unless accumulating

      if stripped_line.start_with?("## ")
        process_accumulated_line(current_category, accumulated_line) if accumulated_line
        accumulated_line = nil
        category_name = stripped_line.sub("## ", "").strip
        current_category = {items: [], name: category_name}
        parsed_structure << current_category
      elsif current_category && (match = LINK_ITEM_REGEX.match(stripped_line))
        process_accumulated_line(current_category, accumulated_line) if accumulated_line
        accumulated_line = nil # Reset for new item

        item_data = {
          description: match[:description]&.strip,
          name: match[:name].strip
        }

        url = match[:url].strip
        if (gh_match = GITHUB_REPO_REGEX.match(url))
          item_data[:repo_abbreviation] = "#{gh_match[:owner]}/#{gh_match[:repo]}"
        else
          item_data[:url] = url
        end
        current_category[:items] << item_data
      elsif current_category && stripped_line.match?(/^\s*[-*]\s*/) # A new list item that doesn't match LINK_ITEM_REGEX
        # Handle plain list items that are not in the [Name](URL) format if necessary,
        # or treat them as part of a multi-line description of a previous complex item.
        # For now, if it looks like a new item but doesn't match the link format, we might ignore or handle differently.
        # Let's assume for now that valid items we care about follow the LINK_ITEM_REGEX.
        # If an accumulated_line exists, process it first.
        process_accumulated_line(current_category, accumulated_line) if accumulated_line
        accumulated_line = stripped_line # Start accumulating this new, non-matching item line
      elsif current_category && !current_category[:items].empty?
        # This line is not a new category header, not a recognized link item, and not a new simple list item.
        # It could be a continuation of the previous item's description or a new simple list item's continuation.
        if accumulated_line # If we were already accumulating a simple list item
          accumulated_line += "\n" + line.strip # Note: line.strip, not stripped_line, to preserve internal spacing if any
        elsif !current_category[:items].last[:description].nil? && !line.match?(/^#/) # Append to last item's description
          # Only append if it doesn't look like a new distinct list item or header
          unless line.match?(/^\s*[-*]\s*/)
             current_category[:items].last[:description] += "\n" + line.strip
          end
        elsif line.match?(/^\s*[^#-*]/) # Line doesn't start with typical markdown markers, assume continuation
          # This is a tricky part - trying to append to the last item if it seems like a continuation
          # For now, let's simplify and assume description continuations are caught above or are part of LINK_ITEM_REGEX processing.
          # A more robust parser would handle this better.
        end
      elsif current_category # Current category exists, but line doesn't match any other pattern - potentially part of multi-line for a simple item
        accumulated_line = (accumulated_line.to_s + "\n" + stripped_line).strip
      end
    end
    process_accumulated_line(current_category, accumulated_line) if accumulated_line # Process any remaining accumulated line

    Success(parsed_structure)
  rescue StandardError => e
    Failure("Failed to parse markdown: #{e.message}")
  end

  private

  def process_accumulated_line(current_category, accumulated_line)
    nil if accumulated_line.nil? || current_category.nil?
    # This is for lines that started with a list marker but didn't match LINK_ITEM_REGEX.
    # We treat them as plain text items for now, without complex parsing.
    # The requirement is for items with repo_abbreviation/url, name, description.
    # Simple text lines won't fit this well unless we try to infer.
    # For now, this processing might just add them as a simple string or a basic hash.
    # Given the new requirements, these simple lines might need a different structure or be ignored.
    # Let's assume they are ignored for now if they don't become part of a complex item's description.
    # The old logic was: current_category[:items].last << "\n#{line}" if current_category[:items].last.is_a?(String)
    # This is now handled by appending to :description if it exists.
  end
end
