class User < ActiveRecord::Base
  include ValidatesAsImage

  has_attached_file :avatar, :styles => { :thumb => ["50x50!", :png], :medium => ["100x100!", :png], :large => ["800x800", :png] }
  has_many :widgets

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :username, :first_name, 
                  :last_name, :info, :homepage, :occupation,
                  :summary, :location, :avatar, :name, :url_title

  validates_presence_of :username, :first_name, :last_name
  validates_uniqueness_of :username, :email, :url_title
  validates_as_image :avatar

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
end
