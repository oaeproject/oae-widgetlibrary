class AddUrlTitleToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :url_title, :string
  end
end
