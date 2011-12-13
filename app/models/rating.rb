class Rating < ActiveRecord::Base
  belongs_to :widget
  belongs_to :user

  default_scope :order => "created_at DESC"
end
