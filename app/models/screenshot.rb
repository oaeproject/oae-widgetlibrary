class Screenshot < ActiveRecord::Base
  belongs_to :version
  has_attached_file :image, :styles => { :thumb => ["100x57#", :png], :medium => ["540x310#"], :large => ["800x800", :png] }
end
