# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'terminal-table'

class ProcessCategoryServiceEnhanced
  include Dry::Monads[:result, :do]

  # Custom error for missing star data on GitHub items
  class MissingStarsError < StandardError; end

  TARGET_DIR = Rails.root.join('static', 'awesomer')

  def call(awesome_list:, star_threshold: nil)
    @star_threshold = star_threshold || awesome_list.sync_threshold_value
    # Validate that all GitHub items have star data before generating markdown
    validate_github_items_have_stars!(awesome_list)
    # Skip if no categories with items
    # Order categories alphabetically by name for consistent ordering
    categories_with_items = awesome_list.categories.joins(:category_items).distinct.order(:name)

    if categories_with_items.empty?
      Rails.logger.info "ProcessCategoryServiceEnhanced: No categories with items for #{awesome_list.github_repo}"
      return cleanup_empty_file(awesome_list)
    end

    # Generate content
    file_content = generate_content(awesome_list, categories_with_items)

    # Check if content is meaningful (more than just headers)
    if file_content.lines.count < 5 || file_content.length < 100
      Rails.logger.info "ProcessCategoryServiceEnhanced: Generated content too small for #{awesome_list.github_repo}"
      return cleanup_empty_file(awesome_list)
    end

    # Write file
    file_path = TARGET_DIR.join(generate_filename(awesome_list.github_repo))
    ensure_target_directory_exists

    File.write(file_path, file_content, encoding: 'UTF-8')
    Rails.logger.info "ProcessCategoryServiceEnhanced: Generated #{file_path}"

    Success(file_path)
  rescue MissingStarsError
    # Re-raise MissingStarsError - this is a validation error that should propagate
    raise
  rescue StandardError => e
    Rails.logger.error "ProcessCategoryServiceEnhanced error: #{e.message}"
    Failure("Failed to process categories: #{e.message}")
  end

  private

  def cleanup_empty_file(awesome_list)
    file_path = TARGET_DIR.join(generate_filename(awesome_list.github_repo))

    if File.exist?(file_path)
      File.delete(file_path)
      Rails.logger.info "ProcessCategoryServiceEnhanced: Deleted empty file #{file_path}"
    end

    Success(:deleted)
  end

  def generate_filename(repo_identifier)
    clean_identifier = repo_identifier.gsub(%r{^https?://github\.com/}, '')
    clean_identifier = clean_identifier.gsub(/\.git$/, '')
    repo_name = clean_identifier.split('/').last
    "#{repo_name}.md"
  end

  def generate_content(awesome_list, categories)
    content = []

    # Add title if available
    if awesome_list.name.present?
      content << "# #{awesome_list.name}"
      content << ''
    end

    # Add description if available
    if awesome_list.description.present?
      content << awesome_list.description
      content << ''
    end

    # Add source link to original repository
    content << "**Source:** [#{awesome_list.github_repo}](https://github.com/#{awesome_list.github_repo})"
    content << ''

    # Process each category first to determine which have visible items
    category_sections = categories.filter_map do |category|
      category_content = generate_category_content(category)
      {content: category_content, name: category.name} if category_content.present?
    end

    # Add table of contents using only categories that produced content
    visible_names = category_sections.map { |s| s[:name] }
    toc = TableOfContentsGenerator.generate(visible_names)
    content << toc if toc.present?

    # Append category sections
    category_sections.each { |s| content << s[:content] }

    content.join("\n")
  end

  def generate_category_content(category)
    # Skip empty categories
    items = category.category_items.where.not(primary_url: [nil, ''])
    return nil if items.empty?

    # Filter out GitHub items below star threshold
    items = items.reject do |item|
      item.primary_url&.include?('github.com') && !item.stars.nil? && item.stars < @star_threshold
    end
    return nil if items.empty?

    content = []
    content << "## #{category.name}"
    content << ''

    # Sort items by stars (descending, nil stars last)
    sorted_items = items.sort do |a, b|
      stars_a = a.stars.to_i
      stars_b = b.stars.to_i
      if stars_a == stars_b
        # Secondary sort by name (ascending) if stars are equal
        a.name.downcase <=> b.name.downcase
      else
        stars_b <=> stars_a # Descending for stars
      end
    end

    # Check if we have any items with stats
    items_with_stats = sorted_items.reject { |item| item.stars.nil? }

    if items_with_stats.any?
      # Prepare table data
      table_rows = sorted_items.map do |item|
        name_md = item.primary_url.present? ? "[#{item.name}](#{item.primary_url})" : item.name
        description_md = item.display_description.to_s.gsub("\n", '<br>')

        # Show stars and last commit, or N/A if not available
        stars_md = item.stars.nil? ? 'N/A' : item.stars.to_s
        last_commit_md = item.last_commit_at.nil? ? 'N/A' : item.last_commit_at.strftime('%Y-%m-%d')

        [name_md, description_md, stars_md, last_commit_md]
      end

      # Create table using terminal-table in markdown mode
      table = Terminal::Table.new do |t|
        t.headings = ['Name', 'Description', 'Stars', 'Last Commit']
        table_rows.each { |row| t.add_row(row) }
        t.style = {border: :markdown}
      end

      content << table.to_s
    else
      # Fallback to simple list if no stats
      sorted_items.each do |item|
        desc = item.display_description
        content << if item.primary_url.present?
                     "- [#{item.name}](#{item.primary_url})#{desc.present? ? " - #{desc}" : ''}"
                   else
                     "- #{item.name}#{desc.present? ? " - #{desc}" : ''}"
                   end
      end
    end

    content << ''
    content << '[Back to Top](#table-of-contents)'
    content << ''
    content.join("\n")
  end

  def ensure_target_directory_exists
    FileUtils.mkdir_p(TARGET_DIR)
  end

  def validate_github_items_have_stars!(awesome_list)
    # Find all GitHub items that are missing star data
    # Reload to get fresh data from database
    awesome_list.reload

    # Use the through association and filter for GitHub URLs without stars
    items_missing_stars = awesome_list.category_items
                                      .where('primary_url LIKE ?', '%github.com%')
                                      .where(stars: nil)

    return if items_missing_stars.empty?

    # Build error message with item names
    item_names = items_missing_stars.pluck(:name).join(', ')
    raise MissingStarsError, "Missing star data for GitHub items: #{item_names}. " \
      "Ensure GitHub stats have been fetched before generating markdown."
  end
end
