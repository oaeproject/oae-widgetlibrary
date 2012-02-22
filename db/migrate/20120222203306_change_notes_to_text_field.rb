class ChangeNotesToTextField < ActiveRecord::Migration
  def up
    change_column :versions, :notes, :text
  end

  def down
    change_column :versions, :notes, :string
  end
end
