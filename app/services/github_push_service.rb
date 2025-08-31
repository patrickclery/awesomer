# frozen_string_literal: true

require 'English'
class GithubPushService
  include Dry::Monads[:result, :do]

  def initialize(commit_message: nil, files_changed: [])
    @files_changed = files_changed
    @commit_message = commit_message || generate_commit_message
  end

  def perform
    Rails.logger.info 'GithubPushService: Preparing to push changes to GitHub'

    return Failure('No files to push') if @files_changed.empty?

    begin
      # Ensure we're in a git repository
      return Failure('Not in a git repository') unless Dir.exist?('.git')

      # Get current branch
      current_branch = `git rev-parse --abbrev-ref HEAD`.strip
      Rails.logger.info "Current branch: #{current_branch}"

      # Check for uncommitted changes in static/ directory
      status = `git status --porcelain static/`
      if status.empty?
        Rails.logger.info 'No changes to commit in static/ directory'
        return Success('No changes to push')
      end

      # Stage the changed files
      @files_changed.each do |file|
        if File.exist?(file)
          `git add #{file}`
          Rails.logger.info "Staged: #{file}"
        end
      end

      # If no specific files, stage all changes in static/
      if @files_changed.empty?
        `git add static/`
        Rails.logger.info 'Staged all changes in static/'
      end

      # Create commit
      commit_result = `git commit -m "#{@commit_message}" 2>&1`
      commit_success = $CHILD_STATUS.success?

      if commit_success
        # Get commit SHA
        commit_sha = `git rev-parse HEAD`.strip
        Rails.logger.info "Created commit: #{commit_sha}"

        # Push to remote
        push_result = `git push origin #{current_branch} 2>&1`
        push_success = $CHILD_STATUS.success?

        if push_success
          Rails.logger.info 'Successfully pushed to GitHub'

          # Update last_pushed_at for all synced lists
          AwesomeList.where.not(last_synced_at: nil)
                     .where('last_synced_at > last_pushed_at OR last_pushed_at IS NULL')
                     .update_all(last_pushed_at: Time.current)

          Success({
            branch: current_branch,
            commit_sha:,
            files_count: @files_changed.count
          })
        else
          Rails.logger.error "Failed to push: #{push_result}"
          # Try to reset the commit
          `git reset HEAD~1`
          Failure("Failed to push to GitHub: #{push_result}")
        end
      else
        Rails.logger.error "Failed to commit: #{commit_result}"
        Failure("Failed to create commit: #{commit_result}")
      end
    rescue StandardError => e
      Rails.logger.error "GithubPushService error: #{e.message}"
      Rails.logger.error e.backtrace.first(5).join("\n")
      Failure("GitHub push failed: #{e.message}")
    end
  end

  private

  def generate_commit_message
    timestamp = Time.current.strftime('%Y-%m-%d %H:%M')
    updated_count = @files_changed.count

    if updated_count == 1
      list_name = File.basename(@files_changed.first, '.md')
      "📊 Update #{list_name} awesome list [#{timestamp}]"
    else
      "📊 Update #{updated_count} awesome lists [#{timestamp}]"
    end
  end
end
