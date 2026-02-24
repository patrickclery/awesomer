# frozen_string_literal: true

class AddGithubDescriptionToCategoryItems < ActiveRecord::Migration[8.0]
  def change
    add_column :category_items, :github_description, :text
  end
end
