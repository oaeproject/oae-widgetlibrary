class AddIconsToUsersAndWidgets < ActiveRecord::Migration
  def self.up
    drop_table :icons

    remove_column :users, :icon_id

    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size, :string
    add_column :users, :avatar_updated_at, :string

    add_column :widgets, :icon_file_name, :string
    add_column :widgets, :icon_content_type, :string
    add_column :widgets, :icon_file_size, :string
    add_column :widgets, :icon_updated_at, :string
  end

  def self.down
    create_table :icons do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.string :image_updated_at
      t.references :user
      t.references :widget
      t.timestamps
    end

    add_column :users, :icon_id, :integer

    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_updated_at

    remove_column :widgets, :icon_file_name
    remove_column :widgets, :icon_content_type
    remove_column :widgets, :icon_file_size
    remove_column :widgets, :icon_updated_at
  end
end
