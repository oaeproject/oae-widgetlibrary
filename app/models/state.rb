class State < ActiveRecord::Base
  has_many :versions
  def self.accepted
    State.where(:title => "accepted").first.id
  end
  def self.declined
    State.where(:title => "declined").first.id
  end
  def self.pending
    State.where(:title => "pending").first.id
  end
  def self.superseded
    State.where(:title => "superseded").first.id
  end
end
