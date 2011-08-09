class CreateCategoryWidgetJoinTable < ActiveRecord::Migration
  def self.up
    create_table :categories_widgets, :id => false do |t|
      t.references :category
      t.references :widget
    end
  end

  def self.down
    drop_table :categories_widgets
  end
end
