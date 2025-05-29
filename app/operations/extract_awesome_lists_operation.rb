# frozen_string_literal: true

class ExtractAwesomeListsOperation
  include Dry::Monads[:result, :do]

  def call(markdown_content:)
    return Failure("Markdown content is required") if markdown_content.nil?
    return Success([]) if markdown_content.blank?

    # Extract GitHub repository links from markdown
    repo_links = extract_github_repos(markdown_content)

    Rails.logger.info "ExtractAwesomeListsOperation: Found #{repo_links.size} repository links"

    Success(repo_links)
  end

  private

  def extract_github_repos(content)
    repo_links = []

    # Pattern to match GitHub repository links in markdown
    # Matches: [text](https://github.com/owner/repo) or [text](https://github.com/owner/repo/)
    github_link_regex = %r{\[([^\]]+)\]\(https://github\.com/([^/\s]+)/([^/\s)]+)/?[^)]*\)}

    content.scan(github_link_regex) do |link_text, owner, repo_name|
      # Clean up repo name - remove any trailing characters
      clean_repo = repo_name.gsub(/[.#].*$/, "") # Remove .git, #anchor, etc.

      repo_identifier = "#{owner}/#{clean_repo}"

      # Skip duplicates and invalid patterns
      next if repo_links.include?(repo_identifier)
      next if owner.blank? || clean_repo.blank?
      next if owner.include?(".") # Skip URLs that aren't repo links

      Rails.logger.debug "ExtractAwesomeListsOperation: Found repo link: #{repo_identifier} (#{link_text})"
      repo_links << repo_identifier
    end

    # Also extract from plain GitHub URLs without markdown link format
    plain_github_regex = %r{https://github\.com/([^/\s]+)/([^/\s\#)]+)/?}

    content.scan(plain_github_regex) do |owner, repo_name|
      clean_repo = repo_name.gsub(/[.#].*$/, "")
      repo_identifier = "#{owner}/#{clean_repo}"

      next if repo_links.include?(repo_identifier)
      next if owner.blank? || clean_repo.blank?
      next if owner.include?(".")

      Rails.logger.debug "ExtractAwesomeListsOperation: Found plain repo link: #{repo_identifier}"
      repo_links << repo_identifier
    end

    repo_links.uniq.sort
  end
end
