# frozen_string_literal: true

class AddArchivedToAwesomeLists < ActiveRecord::Migration[8.0]
  def change
    add_column :awesome_lists, :archived, :boolean, default: false, null: false
    add_column :awesome_lists, :archived_at, :datetime

    add_index :awesome_lists, :archived
    add_index :awesome_lists, %i[archived updated_at]
  end
end
