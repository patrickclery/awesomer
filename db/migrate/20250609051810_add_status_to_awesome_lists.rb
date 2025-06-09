# frozen_string_literal: true

class AddStatusToAwesomeLists < ActiveRecord::Migration[8.0]
  def change
    add_column :awesome_lists, :status, :integer, default: 0, null: false
    add_column :awesome_lists, :processing_started_at, :datetime
    add_column :awesome_lists, :processing_completed_at, :datetime

    # Add index for efficient querying by status
    add_index :awesome_lists, :status
  end
end
