class User < ActiveRecord::Base
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
                  :summary, :location, :avatar

  validates_presence_of :username, :first_name, :last_name
  validates_uniqueness_of :username, :email

  def name
    "#{self.first_name} #{self.last_name}"
  end
end
