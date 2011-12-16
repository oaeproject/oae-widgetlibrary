class Widget < ActiveRecord::Base
  has_attached_file :icon, :styles => { :thumb => ["50x50!", :png], :medium => ["100x100!", :png], :large => ["800x800", :png] }
  has_attached_file :code

  belongs_to :state
  belongs_to :user
  has_many :ratings
  has_many :screenshots
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :languages
  accepts_nested_attributes_for :screenshots

  # Validations
  validates_attachment_presence :icon
  validates_attachment_presence :code
  validates_attachment_content_type :code, :content_type => [ 'application/zip', 'application/x-zip', 'application/x-zip-compressed', 'application/octet-stream', 'application/x-compress', 'application/x-compressed', 'multipart/x-zip' ],
                                    :message => 'file must be a .zip file'

end
