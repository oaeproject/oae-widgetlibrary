class Icon < ActiveRecord::Base
  has_attached_file :image, :styles => { :thumb => ["100x80!", :png], :large => ["800x800", :png] }
end
