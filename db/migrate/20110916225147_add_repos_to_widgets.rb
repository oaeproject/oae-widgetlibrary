class AddReposToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :widget_repo, :string
    add_column :widgets, :widget_backend_repo, :string
  end
end
