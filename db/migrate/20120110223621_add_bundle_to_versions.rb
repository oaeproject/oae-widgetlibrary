class AddBundleToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :bundle_file_name, :string
    add_column :versions, :bundle_content_type, :string
    add_column :versions, :bundle_file_size, :string
    add_column :versions, :bundle_updated_at, :string
  end
end
