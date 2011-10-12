class HomeController < ApplicationController
  def index
    @recentlyadded = Widget.order("created_at desc").limit(5)
    @toprated = Widget.order("average_rating desc").limit(5)
    @mostpopular = Widget.limit(16)
  end
end
