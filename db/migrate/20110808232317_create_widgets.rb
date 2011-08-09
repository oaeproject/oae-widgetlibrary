class CreateWidgets < ActiveRecord::Migration
  def self.up
    create_table :widgets do |t|
      t.string :title
      t.text :description
      t.text :features
      t.datetime :released_on
      t.float :average_rating
      t.references :state
      t.references :icon
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :widgets
  end
end
