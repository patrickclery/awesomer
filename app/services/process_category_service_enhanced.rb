# frozen_string_literal: true

require 'fileutils'
require 'pathname'

class ProcessCategoryServiceEnhanced
  include Dry::Monads[:result, :do]

  TARGET_DIR = Rails.root.join('static', 'awesomer')

  def call(awesome_list:)
    # Skip if no categories with items
    categories_with_items = awesome_list.categories.joins(:category_items).distinct
    
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

  def generate_content(awesome_list, categories)
    content = []
    
    # Add title if available
    if awesome_list.name.present?
      content << "# #{awesome_list.name}"
      content << ""
    end
    
    # Add description if available
    if awesome_list.description.present?
      content << awesome_list.description
      content << ""
    end
    
    # Process each category
    categories.each do |category|
      category_content = generate_category_content(category)
      content << category_content if category_content.present?
    end
    
    content.join("\n")
  end

  def generate_category_content(category)
    # Skip empty categories
    items = category.category_items.where.not(primary_url: [nil, ''])
    return nil if items.empty?
    
    content = []
    content << "## #{category.name}"
    content << ""
    
    # Check if we have items with stats
    items_with_stats = items.where.not(stars: nil)
    
    if items_with_stats.any?
      # Generate table with stats
      content << "| Name | Description | Stars | Last Commit |"
      content << "|------|-------------|-------|-------------|"
      
      items_with_stats.each do |item|
        name_with_link = item.primary_url.present? ? "[#{item.name}](#{item.primary_url})" : item.name
        stars = item.stars || 'N/A'
        last_commit = item.last_commit_at&.strftime('%Y-%m-%d') || 'N/A'
        description = item.description&.truncate(100) || ''
        
        content << "| #{name_with_link} | #{description} | #{stars} | #{last_commit} |"
      end
    else
      # Fallback to simple list if no stats
      items.each do |item|
        if item.primary_url.present?
          content << "- [#{item.name}](#{item.primary_url})#{item.description.present? ? " - #{item.description}" : ""}"
        else
          content << "- #{item.name}#{item.description.present? ? " - #{item.description}" : ""}"
        end
      end
    end
    
    content << ""
    content.join("\n")
  end

  def ensure_target_directory_exists
    FileUtils.mkdir_p(TARGET_DIR) unless Dir.exist?(TARGET_DIR)
  end

  def generate_filename(repo_identifier)
    clean_identifier = repo_identifier.gsub(%r{^https?://github\.com/}, '')
    clean_identifier = clean_identifier.gsub(/\.git$/, '')
    repo_name = clean_identifier.split('/').last
    "#{repo_name}.md"
  end
end