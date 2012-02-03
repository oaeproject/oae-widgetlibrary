class RemoveSummaryToUser < ActiveRecord::Migration
  def up
    remove_column :users, :summary
  end

  def down
    add_column :users, :summary, :text
  end
end
