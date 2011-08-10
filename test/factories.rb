include ActionDispatch::TestProcess

Factory.define :category do |f|
  f.sequence(:title) { |n| "Category #{n}" }
end

class Icon
  attr_accessor :image_file_name
  attr_accessor :image_file_size
  has_attached_file :image, :styles => { :thumb => ["50x50!", :png], :medium => ["100x100!", :png], :large => ["800x800", :png]},
    :url  => "/test_can_be_deleted/:attachment/:id/:style/:filename",
    :path => ":rails_root/public/test_can_be_deleted/:attachment/:id/:style/:filename"
end

Factory.define :icon do |f|
  f.association :widget
  f.image { fixture_file_upload('test.png', 'image/png') }
end

Factory.define :language do |f|
  f.title "English (US)"
  f.code "en"
  f.region "us"
end

Factory.define :rating do |f|
  f.review "This is a super awesome widget, I use it every day and get a warm fuzzy feeling"
  f.stars 5
  f.association :widget
end

class Screenshot
  attr_accessor :image_file_name
  attr_accessor :image_file_size
  has_attached_file :image, :styles => { :thumb => ["100x57!", :png], :medium => ["540x310!"], :large => ["800x800", :png]},
    :url  => "/test_can_be_deleted/:attachment/:id/:style/:filename",
    :path => ":rails_root/public/test_can_be_deleted/:attachment/:id/:style/:filename"
end

Factory.define :screenshot do |f|
  f.association :widget
  f.image { fixture_file_upload('test.png', 'image/png') }
end

Factory.define :state do |f|
  f.title "accepted"
  f.after_create { |s| Factory(:widget, :state => s) }
end

Factory.define :widget do |f|
  f.title "Awesome Widget"
  f.description "A widget that gives you a warm fuzzy feeling."
  f.features "warmth, fuzziness"
  f.average_rating 5.0
  f.association :state
  f.after_create { |w| Factory(:rating, :widget => w) }
  f.after_create { |w| Factory(:screenshot, :widget => w) }
end
