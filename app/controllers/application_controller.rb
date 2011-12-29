class ApplicationController < ActionController::Base
  protect_from_forgery

  def search
    @searchresults = Widget.where("title LIKE '%" + params["q"] + "%'").order("created_at desc")
    render :partial => 'core/searchresults'
  end


  def get_sort(default = "average_rating desc")
    ret = default
    if params[:s] && params[:d]
      case params[:s]
      when "popular"
        # not sure how to measure popularity just yet
      else
        ret = "#{params[:s]} #{params[:d]}"
      end
    end
    ret
  end

end
