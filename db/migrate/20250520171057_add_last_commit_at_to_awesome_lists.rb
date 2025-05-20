# frozen_string_literal: true

class AddLastCommitAtToAwesomeLists < ActiveRecord::Migration[8.0]
  def change
    add_column :awesome_lists, :last_commit_at, :datetime
  end
end
