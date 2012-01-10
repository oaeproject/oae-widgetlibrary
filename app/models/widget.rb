class Widget < ActiveRecord::Base

  belongs_to :user
  belongs_to :version
  has_many :ratings
  has_many :versions, :order => "created_at desc"
  has_many :screenshots

  accepts_nested_attributes_for :versions, :screenshots, :allow_destroy => true

  attr_accessible :url_title

  validates_uniqueness_of :url_title

  def self.find_by_state(state_title, order = "released_on desc", page = 1, userid = nil)
    filterstate = State.where(:title => state_title).first
    conditions = {:state_id => filterstate.id}
    if userid
      conditions[:user_id] = userid
    end
    Version.where(conditions).joins(:widget).order(order).page(page)
  end

  def self.count_by_state(state_id, userid = nil)
    conditions = {:state_id => state_id}
    if userid
      conditions[:user_id] = userid
    end
    Widget.count(:conditions => conditions)
  end

  def approved_versions
    Version.where(:state_id => State.accepted, :widget_id => self.id)
  end

  def active_version
    self.version
  end

  def latest_version
    Version.where(:widget_id => self.id).order("created_at desc").limit(1).first
  end

  # I'm sure there is a better way to do this. For now, we'll just do a pass-through here
  def title
    self.active_version.title unless !self.active_version
  end

  def description
    self.active_version.description unless !self.active_version
  end

  def features
    self.active_version.features unless !self.active_version
  end

  def icon
    self.active_version.icon unless !self.active_version
  end

  def code
    self.active_version.code unless !self.active_version
  end

  def bundle
    self.active_version.bundle unless !self.active_version
  end

  def state
    self.active_version.state unless !self.active_version
  end

  def code_file_name
    self.active_version.code_file_name unless !self.active_version
  end

  def code_content_type
    self.active_version.code_content_type unless !self.active_version
  end

  def code_file_size
    self.active_version.code_file_size unless !self.active_version
  end

  def code_updated_at
    self.active_version.code_updated_at unless !self.active_version
  end

  def categories
    self.active_version.categories unless !self.active_version
  end

  def languages
    self.active_version.languages unless !self.active_version
  end

  def screenshots
    self.active_version.screenshots unless !self.active_version
  end

  def version_number
    self.active_version.version_number unless !self.active_version
  end

  def version_number_title
    self.active_version.version_number_title unless !self.active_version
  end

  def widget_repo
    self.active_version.widget_repo unless !self.active_version
  end

  def widget_backend_repo
    self.active_version.widget_backend_repo unless !self.active_version
  end

  def released_on
    self.active_version.released_on unless !self.active_version
  end

  def created_at
    self.active_version.created_at unless !self.active_version
  end

  def approved_by
    self.active_version.approved_by unless !self.active_version
  end

end
