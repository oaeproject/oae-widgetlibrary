class AddUrlTitleToWidgetsAndUsers < ActiveRecord::Migration
  def change
    add_column :widgets, :url_title, :string
    add_column :users, :url_title, :string
  end
end
