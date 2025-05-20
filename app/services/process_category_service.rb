# frozen_string_literal: true

require "fileutils"

class ProcessCategoryService
  include Dry::Monads[:result, :do]

  TARGET_DIR = Rails.root.join("static", "md")

  def call(categories:)
    yield ensure_target_directory_exists

    created_files = []
    sorted_categories = categories.sort_by(&:custom_order)

    sorted_categories.each do |category|
      file_path = yield generate_markdown_for_category(category)
      created_files << file_path
    end

    Success(created_files)
  end

  private

  def ensure_target_directory_exists
    FileUtils.mkdir_p(TARGET_DIR)
    Success(true)
  rescue StandardError => e
    Failure("Failed to create target directory #{TARGET_DIR}: #{e.message}")
  end

  def generate_markdown_for_category(category)
    filename = "#{sanitize_filename(category.name)}-stars.md"
    file_path = TARGET_DIR.join(filename)
    content = []

    content << "## #{category.name}\n"
    content << "| Name | Description | Stars | Last Commit |"
    content << "|------|-------------|-------|-------------|"

    category.repos.each do |item|
      name = "[#{item.name}](#{item.url})"
      description = item.description.to_s.gsub("\n", "<br>") # Replace newlines for MD table
      stars = item.stars.nil? ? "N/A" : item.stars.to_s
      last_commit = item.last_commit_at.nil? ? "N/A" : item.last_commit_at.strftime("%Y-%m-%d")
      content << "| #{name} | #{description} | #{stars} | #{last_commit} |"
    end

    File.write(file_path, content.join("\n") + "\n")
    Success(file_path)
  rescue StandardError => e
    Failure("Failed to generate or write markdown for category #{category.name}: #{e.message}")
  end

  def sanitize_filename(name)
    name.gsub(/[^0-9a-z.\-_@]+/i, "_").downcase
  end
end
