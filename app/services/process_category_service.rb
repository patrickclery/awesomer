# frozen_string_literal: true

require "fileutils"

class ProcessCategoryService
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  TARGET_DIR = Rails.root.join("static", "md")
  OUTPUT_FILENAME = "processed_awesome_list.md" # Default filename for the single output file

  def call(categories:)
    yield ensure_target_directory_exists

    # Categories are expected to be pre-sorted by custom_order by the calling service
    # If not, sort them here: sorted_categories = categories.sort_by(&:custom_order)
    # For this refactor, assuming ProcessAwesomeListService sends them sorted.

    file_path = TARGET_DIR.join(OUTPUT_FILENAME)
    overall_content = []

    categories.each do |category|
      # Add a separator before a new category, but not for the very first one.
      overall_content << "" if overall_content.any? # Results in a blank line after join

      overall_content << "## #{category.name}"
      overall_content << ""
      overall_content << "| Name | Description | Stars | Last Commit |"
      overall_content << "|------|-------------|-------|-------------|"

      # Sort items by stars (descending, nil stars last)
      sorted_items = category.repos.sort do |a, b|
        stars_a = a.stars.to_i # Treat nil as 0 for comparison
        stars_b = b.stars.to_i # Treat nil as 0 for comparison
        if stars_a == stars_b
          # Secondary sort by name (ascending) if stars are equal
          a.name.downcase <=> b.name.downcase
        else
          stars_b <=> stars_a # Descending for stars
        end
      end

      if sorted_items.any?
        sorted_items.each do |item|
          puts "DEBUG (ProcessCategoryService): Processing item: #{item.inspect}"
          name_md = "[#{item.name}](#{item.url})"
          description_md = item.description.to_s.gsub("\n", "<br>")
          stars_md = item.stars.nil? ? "N/A" : item.stars.to_s
          last_commit_md = item.last_commit_at.nil? ? "N/A" : item.last_commit_at.strftime("%Y-%m-%d")
          overall_content << "| #{name_md} | #{description_md} | #{stars_md} | #{last_commit_md} |"
        end
      else
        overall_content << "| *No items in this category.* | | | |" # Placeholder for empty categories
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

  # sanitize_filename might not be needed if OUTPUT_FILENAME is fixed,
  # but keeping it if a dynamic name based on input might be used later.
  # def sanitize_filename(name)
  #   name.gsub(/[^0-9a-z.\-_@]+/i, '_').downcase
  # end
end
