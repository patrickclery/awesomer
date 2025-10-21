# frozen_string_literal: true

require 'octokit'
require 'dry/monads/result'
require 'dry/monads/do'

module Operations
  class FetchReadme
    extend Dry::Monads[:result, :do]

    def self.call(repo_name:)
      client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
      readme = yield fetch_readme(client, repo_name)
      file_path = file_path_for(repo_name)
      FileUtils.mkdir_p('tmp')
      File.write(file_path, readme, encoding: 'UTF-8', mode: 'w')
      Success(file_path)
    end

    def self.fetch_readme(client, repo_name)
      readme = client.readme(repo_name)
      content = Base64.decode64(readme.content).force_encoding('UTF-8')
      Success(content)
    rescue Octokit::NotFound
      Failure(:not_found)
    rescue StandardError => e
      Failure(e)
    end

    def self.file_path_for(repo_name)
      owner, repo = repo_name.split('/', 2)
      "tmp/#{owner}__#{repo}.md"
    end
  end
end
