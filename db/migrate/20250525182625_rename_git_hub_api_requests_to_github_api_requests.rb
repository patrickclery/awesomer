# frozen_string_literal: true

class RenameGitHubApiRequestsToGithubApiRequests < ActiveRecord::Migration[8.0]
  def change
    rename_table :git_hub_api_requests, :github_api_requests
  end
end
