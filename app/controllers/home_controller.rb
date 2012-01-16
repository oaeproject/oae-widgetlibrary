class HomeController < ApplicationController
  def index
    args = {
      :active => true
    }
    @recentlyadded = Widget.where(args).includes(:versions).order("versions.released_on desc").limit(5)
    @toprated = Widget.where(args).order("average_rating desc").limit(16)
    @mostpopular = Widget.where(:active => true).order("num_downloads desc, num_ratings desc, average_rating desc").limit(5)
  end
end
