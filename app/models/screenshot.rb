class Screenshot < ActiveRecord::Base
  include ValidatesAsImage

  belongs_to :version
  has_attached_file :image, :styles => {
    :thumb => ["100x57#", :png],
    :medium => ["540x310#"],
    :large => ["800x800", :png]
  }

  validates_as_image :image
  validates_attachment_size :image,
                            :less_than=>5.megabytes,
                            :message => 'file must be less than 5 megabytes',
                            :unless => Proc.new {|m| m[:image].nil?}
end
