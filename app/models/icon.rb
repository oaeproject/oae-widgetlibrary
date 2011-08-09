class Icon < ActiveRecord::Base
  belongs_to :widget
  has_attached_file :image, :styles => { :thumb => ["50x50!", :png], :medium => ["100x100!", :png], :large => ["800x800", :png] }
end
