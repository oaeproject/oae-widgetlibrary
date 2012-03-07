class ChangeDataTypeOfAvgRating < ActiveRecord::Migration
  def up
    change_column :widgets, :average_rating, :float, :default => 0.0
  end

  def down
    change_column :widgets, :average_rating, :integer
  end
end
