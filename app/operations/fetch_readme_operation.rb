# frozen_string_literal: true

require "octokit"
require "dry/monads/result"
require "dry/monads/do"

class FetchReadmeOperation
  extend Dry::Monads[:result, :do]

  def self.call(repo_name:)
    client = Octokit::Client.new
    readme = yield fetch_readme(client, repo_name)
    file_path = file_path_for(repo_name)
    FileUtils.mkdir_p(Rails.root.join("tmp", "md"))
    File.write(file_path, readme, encoding: "UTF-8", mode: "w")
    Success(file_path)
  end

  def self.fetch_readme(client, repo_name)
    readme = client.readme(repo_name)
    content = Base64.decode64(readme.content).force_encoding("UTF-8")
    Success(content)
  rescue Octokit::NotFound => e
    Failure(:not_found)
  rescue StandardError => e
    Failure(e)
  end

  def self.file_path_for(repo_name)
    owner, repo = repo_name.split("/", 2)
    Rails.root.join("tmp", "md", "#{owner}__#{repo}.md")
  end
end
