# frozen_string_literal: true

class RenameStatusToStateInAwesomeLists < ActiveRecord::Migration[8.0]
  def change
    rename_column :awesome_lists, :status, :state
  end
end
