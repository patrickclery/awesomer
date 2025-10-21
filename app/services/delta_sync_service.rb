# frozen_string_literal: true

class DeltaSyncService
  include Dry::Monads[:result, :do]

  def initialize(awesome_list:, threshold: nil)
    @awesome_list = awesome_list
    @threshold = threshold || awesome_list.sync_threshold_value
  end

  def call
    Rails.logger.info "DeltaSyncService: Starting delta sync for #{@awesome_list.github_repo}"

    sync_log = create_sync_log
    items_to_update = []
    items_checked = 0
    items_updated = 0

    begin
      # Get all category items for this awesome list
      @awesome_list.category_items.find_each do |item|
        items_checked += 1

        # Skip non-GitHub items
        next unless item.github_repo.present?

        # Check if item needs update based on star delta OR if it has no stars yet
        if item.stars.nil? || item.needs_update?(@threshold)
          items_to_update << item
          reason = item.stars.nil? ? 'no stars yet' : "#{item.star_delta} star change"
          Rails.logger.info "Item #{item.name} needs update: #{reason}"
        end
      end

      Rails.logger.info "DeltaSyncService: Found #{items_to_update.count} items needing update"

      # Only sync if there are items to update
      if items_to_update.any?
        result = sync_items(items_to_update)

        if result.success?
          items_updated = result.value!

          # Update previous_stars for synced items
          items_to_update.each(&:update_previous_stars!)

          # Update awesome list timestamps
          @awesome_list.update!(last_synced_at: Time.current)

          # Complete sync log
          sync_log.update!(
            completed_at: Time.current,
            items_checked:,
            items_updated:,
            status: SyncLog::STATUSES[:completed]
          )

          Success({items_checked:, items_updated:})
        else
          sync_log.update!(
            completed_at: Time.current,
            error_message: result.failure,
            items_checked:,
            items_updated: 0,
            status: SyncLog::STATUSES[:failed]
          )

          Failure("Sync failed: #{result.failure}")
        end
      else
        Rails.logger.info 'DeltaSyncService: No items need updating'

        sync_log.update!(
          completed_at: Time.current,
          items_checked:,
          items_updated: 0,
          status: SyncLog::STATUSES[:completed]
        )

        # Still update last_synced_at even if no items were updated
        @awesome_list.update!(last_synced_at: Time.current)

        Success({items_checked:, items_updated: 0})
      end
    rescue StandardError => e
      Rails.logger.error "DeltaSyncService error: #{e.message}"
      Rails.logger.error e.backtrace.first(5).join("\n")

      sync_log.update!(
        completed_at: Time.current,
        error_message: e.message,
        items_checked:,
        items_updated:,
        status: SyncLog::STATUSES[:failed]
      )

      Failure("Delta sync failed: #{e.message}")
    end
  end

  private

  def create_sync_log
    @awesome_list.sync_logs.create!(
      started_at: Time.current,
      status: SyncLog::STATUSES[:started]
    )
  end

  def sync_items(items)
    updated_count = 0
    rate_limiter = GithubRateLimiterService.new if defined?(GithubRateLimiterService)

    items.each do |item|
      # Extract owner and repo from github_repo
      if item.github_repo.match?(%r{^[^/]+/[^/]+$})
        item.github_repo.split('/')

        # Wait if rate limited
        rate_limiter&.wait_if_needed

        # Fetch updated stats from GitHub
        client = Octokit::Client.new(
          access_token: ENV.fetch('GITHUB_API_KEY', nil),
          auto_paginate: false
        )

        repo_data = client.repository(item.github_repo)

        # Update item with new stats
        item.update!(
          github_description: repo_data.description,
          last_commit_at: repo_data.pushed_at,
          stars: repo_data.stargazers_count
        )

        updated_count += 1
        Rails.logger.info "Updated #{item.name}: #{repo_data.stargazers_count} stars"

      end
    rescue Octokit::NotFound
      Rails.logger.warn "Repository not found: #{item.github_repo}"
    rescue Octokit::TooManyRequests
      Rails.logger.warn 'Rate limited, waiting...'
      sleep(60)
      retry
    rescue StandardError => e
      Rails.logger.error "Error updating #{item.name}: #{e.message}"
    end

    Success(updated_count)
  end
end
