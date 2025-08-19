# frozen_string_literal: true

class BaseParserAdapter
  include Dry::Monads[:result]

  # Check if this adapter can handle the given README content
  # @param content [String] The README content to check
  # @return [Boolean] true if this adapter can parse the content
  def matches?(content)
    raise NotImplementedError, "Subclasses must implement matches?"
  end

  # Parse the README content into categories and items
  # @param content [String] The README content to parse
  # @param skip_external_links [Boolean] Whether to skip non-GitHub links
  # @return [Dry::Monads::Result] Success with array of category hashes or Failure
  def parse(content, skip_external_links: false)
    raise NotImplementedError, "Subclasses must implement parse"
  end

  # Priority for this adapter (higher number = higher priority)
  # Used when multiple adapters match
  # @return [Integer] Priority value
  def priority
    0
  end

  protected

  # Common utility methods that adapters can use

  def extract_github_repo(url)
    # Only extract repo info if URL points to repository root, not files/directories
    return nil unless url

    # Pattern for repository root URLs:
    # - https://github.com/owner/repo
    # - https://github.com/owner/repo/
    # - https://github.com/owner/repo.git
    # - https://github.com/owner/repo#readme
    #
    # Should NOT match:
    # - https://github.com/owner/repo/tree/branch/path
    # - https://github.com/owner/repo/blob/branch/file.md
    # - https://github.com/owner/repo/releases
    # - https://github.com/owner/repo/issues

    repo_root_regex = %r{^https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/#?]+?)(?:\.git|#[^/]*|\?[^/]*|/?$)}
    match = repo_root_regex.match(url)
    return nil unless match

    # Additional check: ensure the URL doesn't contain paths that indicate it's not a repo root
    path_indicators = %r{/(tree|blob|releases|issues|pull|wiki|actions|projects|security|pulse|graphs|settings|commit|commits|branches|tags|compare|network|insights)/}
    return nil if path_indicators.match(url)

    "#{match[:owner]}/#{match[:repo]}"
  end

  def extract_source_code_url(description)
    return nil unless description

    source_code_link_regex = /\[Source Code\]\(([^)]+)\)/i
    match = source_code_link_regex.match(description)
    match ? match[1] : nil
  end

  def extract_demo_url(description)
    return nil unless description

    demo_link_regex = /\[Demo\]\(([^)]+)\)/i
    match = demo_link_regex.match(description)
    match ? match[1] : nil
  end

  def clean_description(description)
    return nil unless description

    # Remove source code and demo links from description
    cleaned = description.dup
    cleaned.gsub!(/\[Source Code\]\([^)]+\)/i, "")
    cleaned.gsub!(/\[Demo\]\([^)]+\)/i, "")
    cleaned.strip!
    cleaned.empty? ? nil : cleaned
  end
end
