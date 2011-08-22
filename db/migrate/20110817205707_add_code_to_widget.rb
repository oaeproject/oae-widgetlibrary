class AddCodeToWidget < ActiveRecord::Migration
  def self.up
    add_column :widgets, :code_file_name, :string
    add_column :widgets, :code_content_type, :string
    add_column :widgets, :code_file_size, :string
    add_column :widgets, :code_updated_at, :string
  end

  def self.down
    remove_column :widgets, :code_file_name
    remove_column :widgets, :code_content_type
    remove_column :widgets, :code_file_size
    remove_column :widgets, :code_updated_at
  end
end
