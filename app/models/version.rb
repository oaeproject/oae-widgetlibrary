class Version < ActiveRecord::Base
  include ValidatesAsImage

  before_destroy :clean_widgets

  has_attached_file :icon,
  :styles => {
    :smaller => ["40x40#", :png],
    :thumb => ["50x50#", :png],
    :medium => ["100x100#", :png]
  },
  :whiny => false

  has_attached_file :code
  has_attached_file :bundle

  belongs_to :widget
  belongs_to :state
  belongs_to :user
  has_many :screenshots, :dependent => :destroy
  has_many :downloads
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :languages

  accepts_nested_attributes_for :screenshots, :allow_destroy => true
  attr_accessible :title, :description, :features, :screenshots_attributes,
                  :code, :widget_repo, :widget_backend_repo, :icon,
                  :category_ids, :language_ids, :version_number, :bundle

  # Validations
  validates_presence_of :title, :description, :features, :version_number
  validates_attachment_presence :icon
  validates_attachment_presence :code

  zip_types = [
    'application/zip',
    'application/x-zip',
    'application/x-zip-compressed',
    'application/octet-stream',
    'application/x-compress',
    'application/x-compressed',
    'multipart/x-zip'
  ]

  validates_attachment_content_type :code,
                                    :content_type => zip_types,
                                    :message => 'file must be a .zip file'

  validates_attachment_content_type :bundle,
                                    :content_type => zip_types,
                                    :message => 'file must be a .zip file'

  validates_as_image :icon

  validates_attachment_size :code,
                            :less_than=>20.megabytes,
                            :message => 'file must be less than 20 megabytes',
                            :if => lambda { code.dirty? }

  validates_attachment_size :bundle,
                            :less_than=>20.megabytes,
                            :message => 'file must be less than 20 megabytes',
                            :if => lambda { bundle.dirty? }

  validates_attachment_size :icon,
                            :less_than=>5.megabytes,
                            :message => 'file must be less than 5 megabytes',
                            :if => lambda { icon.dirty? }

  def reviewer
    self.user
  end

  private
  def clean_widgets
    widget = self.widget
    if widget.versions.size.eql? 1
      widget.destroy
    end
  end

end
