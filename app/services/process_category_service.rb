# frozen_string_literal: true

require "fileutils"
require "terminal-table"

class ProcessCategoryService
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  TARGET_DIR = Rails.root.join("static", "md")
  OUTPUT_FILENAME = "processed_awesome_list.md" # Default filename for the single output file

  def call(categories:, async: false, repo_identifier: nil)
    yield ensure_target_directory_exists

    # If async is true, queue the background job instead of processing immediately
    if async
      Rails.logger.info "ProcessCategoryService: Queueing asynchronous processing"
      ProcessMarkdownWithStatsJob.perform_later(categories:, repo_identifier:)
      return Success("Background processing queued")
    end

    # Generate filename based on repo_identifier if provided
    filename = if repo_identifier
                 generate_filename_from_repo(repo_identifier)
    else
                 OUTPUT_FILENAME
    end

    file_path = TARGET_DIR.join(filename)
    overall_content = []

    categories.each do |category|
      # Add a separator before a new category, but not for the very first one.
      overall_content << "" if overall_content.any? # Results in a blank line after join

      # Handle both struct and hash formats
      category_name = category.respond_to?(:name) ? category.name : category[:name]
      category_items = category.respond_to?(:repos) ? category.repos : category[:items]

      overall_content << "## #{category_name}"
      overall_content << ""

      # Sort items by stars (descending, nil stars last)
      sorted_items = category_items.sort do |a, b|
        # Handle both struct and hash formats for stars
        stars_a = (a.respond_to?(:stars) ? a.stars : a[:stars]).to_i
        stars_b = (b.respond_to?(:stars) ? b.stars : b[:stars]).to_i
        if stars_a == stars_b
          # Secondary sort by name (ascending) if stars are equal
          name_a = a.respond_to?(:name) ? a.name : a[:name]
          name_b = b.respond_to?(:name) ? b.name : b[:name]
          name_a.downcase <=> name_b.downcase
        else
          stars_b <=> stars_a # Descending for stars
        end
      end

      if sorted_items.any?
        # Prepare table data
        table_rows = sorted_items.map do |item|
          Rails.logger.debug "ProcessCategoryService: Processing item: #{item.inspect}"

          # Handle both struct and hash formats for item attributes
          item_name = item.respond_to?(:name) ? item.name : item[:name]
          item_url = item.respond_to?(:primary_url) ? item.primary_url : item[:primary_url]
          item_description = item.respond_to?(:description) ? item.description : item[:description]
          item_stars = item.respond_to?(:stars) ? item.stars : item[:stars]
          item_last_commit = item.respond_to?(:last_commit_at) ? item.last_commit_at : item[:last_commit_at]

          name_md = "[#{item_name}](#{item_url})"
          description_md = item_description.to_s.gsub("\n", "<br>")
          stars_md = item_stars.nil? ? "N/A" : item_stars.to_s
          last_commit_md = item_last_commit.nil? ? "N/A" : item_last_commit.strftime("%Y-%m-%d")

          [ name_md, description_md, stars_md, last_commit_md ]
        end

        # Create table using terminal-table in markdown mode
        table = Terminal::Table.new do |t|
          t.headings = [ "Name", "Description", "Stars", "Last Commit" ]
          table_rows.each { |row| t.add_row(row) }
          t.style = {border: :markdown}
        end

        overall_content << table.to_s
      else
        # Create empty table for categories with no items
        table = Terminal::Table.new do |t|
          t.headings = [ "Name", "Description", "Stars", "Last Commit" ]
          t.add_row([ "*No items in this category.*", "", "", "" ])
          t.style = {border: :markdown}
        end

        overall_content << table.to_s
      end
    end

    begin
      # Add a final newline to the file if content exists
      file_content_string = overall_content.any? ? overall_content.join("\n") + "\n" : ""
      File.write(file_path, file_content_string, encoding: "UTF-8")
      Success(file_path) # Return the path to the single created file
    rescue StandardError => e
      Failure("Failed to write processed awesome list to #{file_path}: #{e.message}")
    end
  end

  private

  def ensure_target_directory_exists
    FileUtils.mkdir_p(TARGET_DIR)
    Success(true)
  rescue StandardError => e
    Failure("Failed to create target directory #{TARGET_DIR}: #{e.message}")
  end

  def generate_filename_from_repo(repo_identifier)
    # Extract repo name from various formats:
    # - "owner/repo" -> "repo.md"
    # - "https://github.com/owner/repo" -> "repo.md"
    # - "https://github.com/owner/repo.git" -> "repo.md"

    # Remove protocol and domain if it's a URL
    clean_identifier = repo_identifier.gsub(%r{^https?://github\.com/}, "")

    # Remove .git suffix if present
    clean_identifier = clean_identifier.gsub(/\.git$/, "")

    # Extract only the repository name (part after the "/")
    repo_name = clean_identifier.split("/").last

    # Add .md extension
    "#{repo_name}.md"
  end

  # sanitize_filename might not be needed if OUTPUT_FILENAME is fixed,
  # but keeping it if a dynamic name based on input might be used later.
  # def sanitize_filename(name)
  #   name.gsub(/[^0-9a-z.\-_@]+/i, '_').downcase
  # end
end
