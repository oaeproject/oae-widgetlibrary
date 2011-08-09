class CreateLanguageWidgetJoinTable < ActiveRecord::Migration
  def self.up
    create_table :languages_widgets, :id => false do |t|
      t.references :language
      t.references :widget
    end
  end

  def self.down
    drop_table :languages_widgets
  end
end
