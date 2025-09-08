# frozen_string_literal: true

class ListValidationService
  include Dry::Monads[:result]

  STALE_DAYS_THRESHOLD = 365 # Default: 365 days since last update

  def initialize(stale_days: STALE_DAYS_THRESHOLD)
    @stale_days = stale_days
  end

  # Check if a list should be kept based on quality criteria
  def valid_list?(awesome_list)
    return false unless awesome_list

    # List must not be archived
    return false if awesome_list.archived?

    # List must have been updated recently
    return false if stale?(awesome_list)

    # List must have GitHub repositories
    return false unless has_github_repos?(awesome_list)

    # List must be referenced in another awesome list
    return false unless referenced_in_awesome_list?(awesome_list)

    true
  end

  # Check if list is stale (not updated within threshold)
  def stale?(awesome_list)
    return true unless awesome_list.updated_at

    awesome_list.updated_at < @stale_days.days.ago
  end

  # Check if list has any GitHub repositories
  def has_github_repos?(awesome_list)
    awesome_list.category_items
                .where.not(github_repo: [nil, ''])
                .exists?
  end

  # Check if this repository is mentioned in any awesome list
  def referenced_in_awesome_list?(awesome_list)
    repo = awesome_list.github_repo
    return false unless repo

    # Check if this repo appears as a CategoryItem in any other awesome list
    CategoryItem.joins(:category)
                .where(github_repo: repo)
                .where.not(categories: {awesome_list_id: awesome_list.id})
                .exists?
  end

  # Get all lists that should be deleted
  def lists_to_delete
    AwesomeList.find_each.reject { |list| valid_list?(list) }
  end

  # Get all orphaned items (not in any awesome list)
  def orphaned_items
    # Find all GitHub repos in CategoryItems
    all_item_repos = CategoryItem.where.not(github_repo: [nil, '']).pluck(:github_repo).uniq

    # Find all repos that are AwesomeLists
    all_list_repos = AwesomeList.pluck(:github_repo).compact.uniq

    # Find repos that are AwesomeLists but not in any CategoryItem
    orphaned_repos = all_list_repos - all_item_repos

    AwesomeList.where(github_repo: orphaned_repos)
  end

  # Delete invalid lists and their associated data
  def prune!(dry_run: false)
    stats = {
      no_repos: [],
      orphaned: [],
      stale: [],
      total_deleted: 0
    }

    # Find stale lists
    AwesomeList.find_each do |list|
      if stale?(list)
        stats[:stale] << list.github_repo
        delete_list!(list) unless dry_run
      elsif !has_github_repos?(list)
        stats[:no_repos] << list.github_repo
        delete_list!(list) unless dry_run
      elsif !referenced_in_awesome_list?(list)
        stats[:orphaned] << list.github_repo
        delete_list!(list) unless dry_run
      end
    end

    stats[:total_deleted] = stats[:stale].size + stats[:no_repos].size + stats[:orphaned].size

    Success(stats)
  rescue StandardError => e
    Failure("Prune failed: #{e.message}")
  end

  private

  def delete_list!(awesome_list)
    # Delete associated markdown file
    delete_markdown_file(awesome_list)

    # Delete associated records
    awesome_list.categories.destroy_all
    awesome_list.destroy
  end

  def delete_markdown_file(awesome_list)
    filename = "#{awesome_list.github_repo.split('/').last}.md"
    file_path = Rails.root.join('static', 'awesomer', filename)

    FileUtils.rm_f(file_path)
  end
end
