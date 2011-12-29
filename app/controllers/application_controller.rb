class ApplicationController < ActionController::Base
  protect_from_forgery

  def search
    w = Widget.scoped
    @searchresults = w.where(w.table[:title].matches("%#{params[:q]}%").and(w.table[:state_id].eq(State.accepted))).order("created_at desc")
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
