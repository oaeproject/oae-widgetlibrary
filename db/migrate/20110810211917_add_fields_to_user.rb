class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :info, :text
    add_column :users, :summary, :text
    add_column :users, :occupation, :string
    add_column :users, :homepage, :string
    add_column :users, :location, :string
    add_column :users, :icon_id, :integer
  end

  def self.down
    remove_column :users, :username
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :info
    remove_column :users, :summary
    remove_column :users, :occupation
    remove_column :users, :homepage
    remove_column :users, :location
    remove_column :users, :icon_id
  end
end
