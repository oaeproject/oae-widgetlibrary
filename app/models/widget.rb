class Widget < ActiveRecord::Base
  has_one :icon
  belongs_to :state
  has_many :ratings
  has_many :screenshots
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :languages
end
