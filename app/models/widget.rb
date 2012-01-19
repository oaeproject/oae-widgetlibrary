class Widget < ActiveRecord::Base

  belongs_to :user
  belongs_to :version
  has_many :ratings
  has_many :versions, :order => "created_at desc"
  has_many :downloads

  accepts_nested_attributes_for :versions, :allow_destroy => true

  attr_accessible :url_title, :downloads

  validates_presence_of :url_title
  validates_uniqueness_of :url_title

  def approved_versions
    Version.where(:state_id => State.accepted, :widget_id => self.id)
  end

  def active_version
    self.version
  end

  def latest_version
    Version.where(:widget_id => self.id).order("created_at desc").limit(1).first
  end

  def method_missing(m, *args, &block)
    # pass through any methods that the active_version has
    if !self.active_version.nil? && self.active_version.respond_to?(m)
      self.active_version.method(m).call(*args, &block)
    elsif self.respond_to?(m)
      super(m, *args, &block)
    else
      nil
    end
  end

end
