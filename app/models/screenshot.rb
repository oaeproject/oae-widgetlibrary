class Screenshot < ActiveRecord::Base
  include ValidatesAsImage

  belongs_to :version
  has_attached_file :image, :styles => {
    :thumb => [Proc.new { |instance| instance.thumb_style }, :png],
    :medium => ["540x310>", :png],
    :large => ["800x800>", :png]
  }

  validates_as_image :image
  validates_attachment_size :image,
                            :less_than=>5.megabytes,
                            :message => 'file must be less than 5 megabytes',
                            :if => lambda { image.dirty? }

  def thumb_style
    geo = Paperclip::Geometry.from_file(image.to_file(:original))
    ratio = 100.0/60.0
    # if the ratio is higher than the container, that means the image is
    # wider than the container, so we prioritize the height and let the width
    # overflow as it would
    if geo.width.to_f/geo.height.to_f > ratio
      "x60"
    else
      "100x"
    end
  end
end
