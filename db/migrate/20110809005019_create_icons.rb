class CreateIcons < ActiveRecord::Migration
  def self.up
    create_table :icons do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.string :image_updated_at
      t.references :user
      t.references :widget
      t.timestamps
    end
    remove_column :widgets, :icon_id
  end

  def self.down
    drop_table :icons
    add_column :widgets, :icon_id, :integer
  end
end
