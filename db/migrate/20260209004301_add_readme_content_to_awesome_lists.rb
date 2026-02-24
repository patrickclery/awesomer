class AddReadmeContentToAwesomeLists < ActiveRecord::Migration[8.0]
  def change
    add_column :awesome_lists, :readme_content, :text
  end
end
