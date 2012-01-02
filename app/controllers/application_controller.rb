class ApplicationController < ActionController::Base
  protect_from_forgery
  WillPaginate.per_page = 16

  helper_method :is_admin?, :can_view_admin_area?

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

  def can_view_admin_area?
    user_signed_in? && ( current_user.admin || current_user.reviewer )
  end

  def is_admin?
    user_signed_in? && current_user.admin
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
