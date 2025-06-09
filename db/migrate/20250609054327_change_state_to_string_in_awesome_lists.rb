# frozen_string_literal: true

class ChangeStateToStringInAwesomeLists < ActiveRecord::Migration[8.0]
  def up
    # Add a temporary string column
    add_column :awesome_lists, :state_temp, :string, default: 'pending', null: false

    # Convert existing integer values to strings in the temporary column
    execute <<-SQL.squish
      UPDATE awesome_lists#{' '}
      SET state_temp = CASE#{' '}
        WHEN state = 0 THEN 'pending'
        WHEN state = 1 THEN 'in_progress'
        WHEN state = 2 THEN 'completed'
        WHEN state = 3 THEN 'failed'
        ELSE 'pending'
      END
    SQL

    # Remove the old integer column
    remove_column :awesome_lists, :state

    # Rename the temporary column to state
    rename_column :awesome_lists, :state_temp, :state

    # Re-add the index
    add_index :awesome_lists, :state
  end

  def down
    # Add a temporary integer column
    add_column :awesome_lists, :state_temp, :integer, default: 0, null: false

    # Convert strings back to integers
    execute <<-SQL.squish
      UPDATE awesome_lists#{' '}
      SET state_temp = CASE#{' '}
        WHEN state = 'pending' THEN 0
        WHEN state = 'in_progress' THEN 1
        WHEN state = 'completed' THEN 2
        WHEN state = 'failed' THEN 3
        ELSE 0
      END
    SQL

    # Remove the old string column
    remove_column :awesome_lists, :state

    # Rename the temporary column to state
    rename_column :awesome_lists, :state_temp, :state

    # Re-add the index
    add_index :awesome_lists, :state
  end
end
