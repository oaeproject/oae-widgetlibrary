class CreateScreenshots < ActiveRecord::Migration
  def self.up
    create_table :screenshots do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.string :image_updated_at
      t.references :widget
      t.timestamps
    end
  end

  def self.down
    drop_table :screenshots
  end
end
