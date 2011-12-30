class HomeController < ApplicationController
  def index
    args = {
      :state_id => State.accepted
    }
    @recentlyadded = Widget.where(args).order("released_on desc").limit(5)
    @toprated = Widget.where(args).order("average_rating desc").limit(5)
    @mostpopular = Widget.where(args).order("random()").limit(16)
  end
end
