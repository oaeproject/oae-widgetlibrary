class Widget < ActiveRecord::Base
  include ValidatesAsImage

  has_attached_file :icon, :styles => { :thumb => ["50x50!", :png], :medium => ["100x100!", :png], :large => ["800x800", :png] }, :whiny => false
  has_attached_file :code

  belongs_to :state
  belongs_to :user
  has_many :ratings
  has_many :screenshots, :dependent => :destroy
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :languages

  accepts_nested_attributes_for :screenshots, :allow_destroy => true
  attr_accessible :title, :description, :features, :screenshots_attributes, :code, :widget_repo, :widget_backend_repo, :icon, :category_ids, :language_ids

  # Validations
  validates_presence_of :title, :description, :features
  validates_attachment_presence :icon
  validates_attachment_presence :code
  validates_attachment_content_type :code, :content_type => [ 'application/zip', 'application/x-zip', 'application/x-zip-compressed', 'application/octet-stream', 'application/x-compress', 'application/x-compressed', 'multipart/x-zip' ],
                                    :message => 'file must be a .zip file'

  validates_as_image :icon


  def self.find_accepted(args = {})
    conditions = args[:conditions] || {}
    order = args[:order] || "created_at desc"
    limit = args[:limit] || nil

    conditions[:state_id] = State.where(:title => "accepted").first.id

    if limit
      Widget.where(conditions).order(order).limit(limit)
    elsif args[:count]
      Widget.count(:conditions => conditions)
    else
      Widget.where(conditions).order(order)
    end
  end
end
