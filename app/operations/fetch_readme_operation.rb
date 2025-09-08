# frozen_string_literal: true

# Ensure octokit gem is in Gemfile and bundled
# require 'net/http' # No longer needed
# require 'uri'      # No longer needed
require 'json'     # Potentially needed if Octokit response needs manual parsing for some edge cases, usually not.
require 'base64'   # Still needed for explicit decoding if Octokit provides raw base64 content.
require 'time'
require 'octokit'  # Added

class FetchReadmeOperation
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  GITHUB_REPO_REGEX = %r{https?://(?:www\.)?github\.com/(?<owner>[^/]+)/(?<repo>[^/#]+?)(?:/|\.git|#|$)}
  # GITHUB_API_BASE_URL not directly used with Octokit client in this way

  def call(repo_identifier:)
    owner, repo_name = yield parse_repo_identifier(repo_identifier)
    repo_full_name = "#{owner}/#{repo_name}"

    # Use the helper with timeout configuration if available
    client = if defined?(OctokitHelper)
               OctokitHelper.client_with_timeout(timeout: 30)
             else
               Octokit::Client.new(
                 access_token: ENV.fetch('GITHUB_API_KEY', nil),
                 connection_options: {
                   request: {
                     open_timeout: 10,
                     timeout: 30
                   }
                 }
               )
             end

    repo_data_result = yield fetch_repo_data(client, repo_full_name)
    repo_main_description = repo_data_result.description

    readme_details_hash = yield fetch_readme_content_from_github(client, repo_full_name)
    readme_filename = readme_details_hash[:name]
    decoded_content = readme_details_hash[:content]
    # encoding = readme_details_hash[:encoding] # Available if needed

    readme_last_commit_date = yield fetch_readme_last_commit_date(client, repo_full_name, readme_filename)

    Success({
      content: decoded_content,
      last_commit_at: readme_last_commit_date,
      name: readme_filename,
      owner:,
      repo: repo_name,
      repo_description: repo_main_description
    })
  end

  private

  def parse_repo_identifier(identifier)
    match = GITHUB_REPO_REGEX.match(identifier)
    if match
      Success([match[:owner], match[:repo]])
    elsif identifier.count('/') == 1
      Success(identifier.split('/', 2))
    else
      Failure("Invalid GitHub repository identifier: #{identifier}. Expected 'owner/repo' or full URL.")
    end
  end

  def fetch_repo_data(client, repo_full_name)
    # Check cache first
    cache_key = "github_repo_data:#{repo_full_name}"
    cached_repo_data = Rails.cache.read(cache_key)

    if cached_repo_data
      Rails.logger.info "Using cached repo data for #{repo_full_name}"
      return Success(cached_repo_data)
    end

    # Make API call
    Rails.logger.info "Fetching fresh repo data for #{repo_full_name}"
    repo_details = client.repository(repo_full_name)

    # Cache successful response
    Rails.cache.write(cache_key, repo_details, expires_in: 1.hour)

    Success(repo_details) # repo_details is an Octokit::Resource (Sawyer::Resource)
  rescue Octokit::NotFound
    Failure("Repository not found: #{repo_full_name}")
  rescue Octokit::Error => e # Catches Octokit-specific API errors
    Failure("GitHub API error fetching repo data for #{repo_full_name}: #{e.message}")
  rescue StandardError => e # Catch other unexpected errors during this step
    Failure("Unexpected error fetching repo data for #{repo_full_name}: #{e.message}")
  end

  def fetch_readme_content_from_github(client, repo_full_name)
    # Check cache first
    cache_key = "github_readme_content:#{repo_full_name}"
    cached_readme = Rails.cache.read(cache_key)

    if cached_readme
      Rails.logger.info "Using cached README content for #{repo_full_name}"
      return Success(cached_readme)
    end

    # Make API call
    Rails.logger.info "Fetching fresh README content for #{repo_full_name}"
    readme_info = client.readme(repo_full_name)

    # Check if content exists before trying to decode
    return Failure("README content is empty for #{repo_full_name}") if readme_info.content.nil?

    content_decoded = Base64.decode64(readme_info.content).force_encoding('UTF-8')
    return Failure("README for #{repo_full_name} not valid UTF-8") unless content_decoded.valid_encoding?

    readme_data = {content: content_decoded, encoding: readme_info.encoding, name: readme_info.name}

    # Cache successful response
    Rails.cache.write(cache_key, readme_data, expires_in: 1.hour)

    Success(readme_data)
  rescue Octokit::NotFound
    Failure("README not found for repository: #{repo_full_name}")
  rescue Octokit::Error => e
    Failure("GitHub API error fetching README for #{repo_full_name}: #{e.message}")
  rescue ArgumentError => e
    Failure("Failed to decode base64 content for README of #{repo_full_name}: #{e.message}")
  rescue StandardError => e
    Failure("Unexpected error fetching README content for #{repo_full_name}: #{e.message}")
  end

  # decode_readme_content method is now integrated or handled by Octokit/above method

  def fetch_readme_last_commit_date(client, repo_full_name, readme_path)
    return Success(nil) if readme_path.blank?

    # Check cache first
    cache_key = "github_readme_commit:#{repo_full_name}:#{readme_path}"
    cached_commit_date = Rails.cache.read(cache_key)

    if cached_commit_date
      Rails.logger.info "Using cached README commit date for #{repo_full_name}/#{readme_path}"
      return Success(cached_commit_date)
    end

    # Make API call
    Rails.logger.info "Fetching fresh README commit date for #{repo_full_name}/#{readme_path}"
    commits = client.commits(repo_full_name, page: 1, path: readme_path, per_page: 1)

    commit_date = if commits.is_a?(Array) && commits.first
                    commit_info = commits.first.commit
                    committer_info = commit_info&.committer
                    committer_info&.date
                  end

    # Cache successful response (including nil results)
    Rails.cache.write(cache_key, commit_date, expires_in: 1.hour)

    Success(commit_date)
  rescue Octokit::NotFound
    Rails.logger.warn "Could not fetch last commit for README '#{readme_path}' in " \
                      "#{repo_full_name} (path not found/no commits)."
    Success(nil)
  rescue Octokit::Error => e
    Rails.logger.warn "GitHub API error fetching README commit for '#{readme_path}' in " \
                      "#{repo_full_name}: #{e.message}"
    Success(nil)
  rescue StandardError => e
    Rails.logger.warn "Error parsing last commit date for README '#{readme_path}' in " \
                      "#{repo_full_name}: #{e.message}"
    Success(nil)
  end
end
