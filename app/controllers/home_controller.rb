class HomeController < ApplicationController
  def index
    @recentlyadded = Widget.find_accepted(:order => "released_on desc", :limit => 5)
    @toprated = Widget.find_accepted(:order => "average_rating desc", :limit => 5)
    @mostpopular = Widget.find_accepted(:order => "random()", :limit => 16)
  end
end
