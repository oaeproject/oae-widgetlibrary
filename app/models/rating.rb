class Rating < ActiveRecord::Base
  belongs_to :widget
  belongs_to :user

  default_scope :order => "created_at DESC"

  # Validation
  validates :review,  :presence => true,
                      :length => { :minimum => 2 }
  validates :stars,   :presence => true,
                      :numericality => { :only_integer => true,
                                         :greater_than_or_equal_to => 1,
                                         :less_than_or_equal_to => 5,
                                         :message => "Please enter a star rating"}

end
