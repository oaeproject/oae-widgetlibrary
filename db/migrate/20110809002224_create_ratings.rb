class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.text :review
      t.integer :stars
      t.references :widget
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
