# frozen_string_literal: true

# Ensure octokit gem is in Gemfile and bundled
# require 'net/http' # No longer needed
# require 'uri'      # No longer needed
require "json"     # Potentially needed if Octokit response needs manual parsing for some edge cases, usually not.
require "base64"   # Still needed for explicit decoding if Octokit provides raw base64 content.
require "time"
require "octokit"  # Added

class FetchReadmeOperation
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  GITHUB_REPO_REGEX = %r{https?://(?:www\.)?github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}
  # GITHUB_API_BASE_URL not directly used with Octokit client in this way

  def call(repo_identifier:)
    owner, repo_name = yield parse_repo_identifier(repo_identifier)
    repo_full_name = "#{owner}/#{repo_name}"

    client = Octokit::Client.new(access_token: ENV["GITHUB_API_KEY"])

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
      Success([ match[:owner], match[:repo] ])
    elsif identifier.count("/") == 1
      Success(identifier.split("/", 2))
    else
      Failure("Invalid GitHub repository identifier: #{identifier}. Expected 'owner/repo' or full URL.")
    end
  end

  def fetch_repo_data(client, repo_full_name)
    repo_details = client.repository(repo_full_name)
    Success(repo_details) # repo_details is an Octokit::Resource (Sawyer::Resource)
  rescue Octokit::NotFound
    Failure("Repository not found: #{repo_full_name}")
  rescue Octokit::Error => e # Catches Octokit-specific API errors
    Failure("GitHub API error fetching repo data for #{repo_full_name}: #{e.message}")
  rescue StandardError => e # Catch other unexpected errors during this step
    Failure("Unexpected error fetching repo data for #{repo_full_name}: #{e.message}")
  end

  def fetch_readme_content_from_github(client, repo_full_name)
    readme_info = client.readme(repo_full_name) # This gets Sawyer::Resource with .content as base64
    content_decoded = Base64.decode64(readme_info.content).force_encoding("UTF-8")
    return Failure("Decoded README content is not valid UTF-8 for #{repo_full_name}") unless content_decoded.valid_encoding?

    Success({content: content_decoded, encoding: readme_info.encoding, name: readme_info.name})
  rescue Octokit::NotFound
    Failure("README not found for repository: #{repo_full_name}")
  rescue Octokit::Error => e
    Failure("GitHub API error fetching README for #{repo_full_name}: #{e.message}")
  rescue ArgumentError => e # For Base64 decoding issues if content is not base64
    Failure("Failed to decode base64 content for README of #{repo_full_name}: #{e.message}")
  rescue StandardError => e # Catch other unexpected errors
    Failure("Unexpected error fetching README content for #{repo_full_name}: #{e.message}")
  end

  # decode_readme_content method is now integrated or handled by Octokit/above method

  def fetch_readme_last_commit_date(client, repo_full_name, readme_path)
    return Success(nil) if readme_path.blank?
    commits = client.commits(repo_full_name, page: 1, path: readme_path, per_page: 1)
    if commits.is_a?(Array) && commits.first
      commit_info = commits.first.commit
      committer_info = commit_info&.committer
      date_obj = committer_info&.date
      Success(date_obj)
    else
      Success(nil) # No commit data found for the README path
    end
  rescue Octokit::NotFound # If path doesn't exist or repo is empty, commits might 404
    puts "WARN: Could not fetch last commit date for README '#{readme_path}' in #{repo_full_name} (path not found or no commits)."
    Success(nil)
  rescue Octokit::Error => e
    puts "WARN: GitHub API error fetching last commit date for README '#{readme_path}' in #{repo_full_name}: #{e.message}"
    Success(nil)
  rescue StandardError => e
    puts "WARN: Error parsing last commit date for README '#{readme_path}' in #{repo_full_name}: #{e.message}"
    Success(nil)
  end
end
