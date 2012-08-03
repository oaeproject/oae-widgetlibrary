class Language < ActiveRecord::Base
  has_and_belongs_to_many :versions
  validates_presence_of :title, :code, :region
  validates :title, :uniqueness => true
  validates :code, :region, :length => { :is => 2 }
end
