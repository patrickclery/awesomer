class AddSortPreferenceToAwesomeLists < ActiveRecord::Migration[8.0]
  def change
    add_column :awesome_lists, :sort_preference, :string, default: 'stars', null: false
  end
end
