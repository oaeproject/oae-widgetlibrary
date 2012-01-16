class CreateDownloads  < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.integer     :widget_id
      t.integer     :version_id
      t.integer     :user_id
      t.string      :ip_address
      t.string      :unique_id
      t.string      :file
      t.timestamps
    end
    add_column :widgets, :num_downloads, :integer, :default => 0
    add_column :widgets, :num_ratings, :integer, :default => 0
  end
end
