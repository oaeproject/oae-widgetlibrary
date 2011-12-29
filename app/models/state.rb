class State < ActiveRecord::Base
  has_many :widgets
  def self.accepted
    State.where(:title => "accepted").first.id
  end
end
