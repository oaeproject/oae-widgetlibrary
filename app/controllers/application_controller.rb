class ApplicationController < ActionController::Base
  protect_from_forgery

  def search
    @searchresults = Widget.where("title LIKE '%" + params["q"] + "%'").order("created_at desc")
    render :partial => 'core/searchresults'
  end
end
