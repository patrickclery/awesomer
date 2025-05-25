# frozen_string_literal: true

class CreateGithubApiRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :github_api_requests do |t|
      t.string :endpoint
      t.datetime :requested_at
      t.integer :response_status
      t.string :owner
      t.string :repo

      t.timestamps
    end
  end
end
