class CreateWidgetVersion < ActiveRecord::Migration
  def up
    create_table :versions do |t|
      t.integer :widget_id
      t.string :title
      t.text :description
      t.text :features
      t.datetime :released_on
      t.datetime :reviewed_on
      t.integer :state_id
      t.string :version_number
      t.datetime :created_at
      t.datetime :updated_at
      t.string :user_id
      t.string :icon_file_name
      t.string :icon_content_type
      t.string :icon_file_size
      t.string :icon_updated_at
      t.string :code_file_name
      t.string :code_content_type
      t.string :code_file_size
      t.string :code_updated_at
      t.string :widget_repo
      t.string :widget_backend_repo
      t.string :notes
    end

    drop_table :widgets
    create_table :widgets do |t|
      t.integer :user_id
      t.integer :average_rating
      t.string :url_title
      t.integer :version_id
      t.boolean :active, :default => false
    end

    drop_table :languages_widgets
    drop_table :categories_widgets

    create_table :languages_versions, :id => false, :force => true do |t|
      t.integer :language_id
      t.integer :version_id
    end

    create_table :categories_versions, :id => false, :force => true do |t|
      t.integer :category_id
      t.integer :version_id
    end

    rename_column :screenshots, :widget_id, :version_id
  end

  def down
    drop_table :versions
    drop_table :widgets
    drop_table :categories_versions
    drop_table :languages_versions
    rename_column :screenshots, :version_id, :widget_id

    create_table :categories_widgets, :id => false, :force => true do |t|
      t.integer :category_id
      t.integer :widget_id
    end

    create_table :languages_widgets, :id => false, :force => true do |t|
      t.integer :language_id
      t.integer :widget_id
    end
    create_table :widgets, :force => true do |t|
      t.string :title
      t.text :description
      t.text :features
      t.datetime :released_on
      t.integer :state_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string :icon_file_name
      t.string :icon_content_type
      t.string :icon_file_size
      t.string :icon_updated_at
      t.string :code_file_name
      t.string :code_content_type
      t.string :code_file_size
      t.string :code_updated_at
      t.string :widget_repo
      t.string :widget_backend_repo
      t.string :url_title
      t.float :average_rating
      t.integer :user_id
    end
  end
end
