class User < ActiveRecord::Base
  include ValidatesAsImage
  before_save :calculate_fields

  has_attached_file :avatar,
                    :styles => {
                      :thumb => ["50x50!", :png],
                      :medium => ["100x100!", :png],
                      :large => ["800x800", :png] },
                    :default_url => "register_default_image.jpg"
  has_many :widgets
  has_many :downloads

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :username, :first_name, 
                  :last_name, :info, :homepage, :occupation,
                  :summary, :location, :avatar, :name, :url_title

  validates_presence_of :username, :first_name, :last_name
  validates_uniqueness_of :username, :email
  validates_as_image :avatar

  validates_attachment_size :avatar,
                            :less_than=>5.megabytes,
                            :message => 'file must be less than 5 megabytes',
                            :if => lambda { avatar.dirty? }

  def widgets
    args = {
      :active => true,
      :user_id => self.id
    }
    Widget.includes(:version).where(args)
  end

  def widget_average_rating
    rating = 0.0
    args = {
      :active => true,
      :user_id => self.id
    }
    widgets = Widget.includes(:version).where(args)
    if widgets.size > 0
      widgets.each do |widget|
        rating += widget.average_rating
      end
      rating.to_f / widgets.size.to_f
    else
      rating
    end
  end

  private
  def calculate_fields
    self.name = "#{self.first_name} #{self.last_name}"
    self.url_title = "#{self.first_name.to_s.downcase}-#{self.last_name.to_s.downcase}"
  end

end
