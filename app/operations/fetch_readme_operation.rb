# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "base64"
require "time" # Ensure Time is available for parsing

class FetchReadmeOperation
  include Dry::Monads[:result, :do]

  GITHUB_REPO_REGEX = %r{https?://(?:www\.)?github\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(?:/|\.git|$)}
  GITHUB_API_BASE_URL = "https://api.github.com/repos"

  def call(repo_identifier:)
    owner, repo_name = yield parse_repo_identifier(repo_identifier)

    # Fetch general repo data first for description and default branch (if needed for README path)
    repo_data = yield fetch_repo_data(owner:, repo_name:)
    repo_main_description = repo_data["description"]
    # default_branch = repo_data['default_branch'] # Could be used if README path needs branch

    readme_api_response = yield fetch_readme_from_github(owner:, repo_name:)
    readme_filename = readme_api_response["name"]
    decoded_content = yield decode_readme_content(content: readme_api_response["content"], encoding: readme_api_response["encoding"])

    readme_last_commit_date = yield fetch_readme_last_commit_date(owner:, readme_path: readme_filename, repo_name:)

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

  def fetch_repo_data(owner:, repo_name:)
    uri = URI.parse("#{GITHUB_API_BASE_URL}/#{owner}/#{repo_name}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")

    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = "AwesomeListDetailsFetcher/1.0"
    request["Accept"] = "application/vnd.github.v3+json"
    # Add Authorization header if GITHUB_TOKEN is available for higher rate limits
    # request['Authorization'] = "token #{ENV['GITHUB_TOKEN']}" if ENV['GITHUB_TOKEN']

    response = http.request(request)

    case response
    when Net::HTTPSuccess
      Success(JSON.parse(response.body))
    else
      Failure("Failed to fetch repo data for #{owner}/#{repo_name}: #{response.code} #{response.message}")
    end
  rescue StandardError => e
    Failure("Error fetching repo data for #{owner}/#{repo_name}: #{e.message}")
  end

  def fetch_readme_from_github(owner:, repo_name:)
    uri = URI.parse("#{GITHUB_API_BASE_URL}/#{owner}/#{repo_name}/readme")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")

    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = "AwesomeListReadmeFetcher/1.0"
    request["Accept"] = "application/vnd.github.v3+json"
    # Add Authorization header if GITHUB_TOKEN is available for higher rate limits
    # request['Authorization'] = "token #{ENV['GITHUB_TOKEN']}" if ENV['GITHUB_TOKEN']

    response = http.request(request)

    case response
    when Net::HTTPSuccess
      Success(JSON.parse(response.body))
    when Net::HTTPNotFound
      Failure("README not found for repository: #{owner}/#{repo_name}")
    else
      Failure("GitHub API request for README failed for #{owner}/#{repo_name}: #{response.code} #{response.message} - #{response.body.truncate(100)}")
    end
  rescue SocketError, Errno::ECONNREFUSED, Net::OpenTimeout, Net::ReadTimeout => e
    Failure("Network error while fetching README for #{owner}/#{repo_name}: #{e.message}")
  rescue JSON::ParserError => e
    Failure("Failed to parse JSON response for README from GitHub API for #{owner}/#{repo_name}: #{e.message}")
  rescue StandardError => e
    Failure("Unexpected error fetching README for #{owner}/#{repo_name}: #{e.message}")
  end

  def decode_readme_content(content:, encoding:)
    return Failure("README content is missing from API response") unless content
    return Failure("Unsupported README encoding: #{encoding}") unless encoding == "base64"

    decoded_string = Base64.decode64(content)
    # Assume the decoded content from GitHub is UTF-8. Force encoding and check validity.
    decoded_string.force_encoding("UTF-8")
    unless decoded_string.valid_encoding?
      # If it's not valid UTF-8, it might be another encoding, or corrupted.
      # For now, we fail. A more robust solution might try to detect/convert known encodings.
      return Failure("Decoded README content is not valid UTF-8")
    end
    Success(decoded_string)
  rescue ArgumentError => e # For invalid base64
    Failure("Failed to decode base64 content for README: #{e.message}")
  end

  def fetch_readme_last_commit_date(owner:, readme_path:, repo_name:)
    return Success(nil) if readme_path.blank? # No path, no commit date
    uri = URI.parse("#{GITHUB_API_BASE_URL}/#{owner}/#{repo_name}/commits?path=#{CGI.escape(readme_path)}&page=1&per_page=1")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")

    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = "AwesomeListReadmeFetcher/1.0"
    request["Accept"] = "application/vnd.github.v3+json"
    # Add Authorization header if GITHUB_TOKEN is available for higher rate limits
    # request['Authorization'] = "token #{ENV['GITHUB_TOKEN']}" if ENV['GITHUB_TOKEN']

    response = http.request(request)

    case response
    when Net::HTTPSuccess
      commits_data = JSON.parse(response.body)
      if commits_data.is_a?(Array) && commits_data.first && commits_data.first.dig("commit", "committer", "date")
        Success(Time.parse(commits_data.first["commit"]["committer"]["date"]))
      else
        Success(nil) # No commit data found for the README path
      end
    else
      # Don't make this a hard failure for the whole operation, just return nil for commit date
      puts "WARN: Could not fetch last commit date for README '#{readme_path}' in #{owner}/#{repo_name}: #{response.code}"
      Success(nil)
    end
  rescue StandardError => e # Catch broader errors, return nil for commit date
    puts "WARN: Error fetching last commit date for README '#{readme_path}' in #{owner}/#{repo_name}: #{e.message}"
    Success(nil)
  end
end
