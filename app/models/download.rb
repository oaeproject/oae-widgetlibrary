class Download < ActiveRecord::Base
  belongs_to :version
  belongs_to :widget
  belongs_to :user
end
