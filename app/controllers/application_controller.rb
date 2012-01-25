class ApplicationController < ActionController::Base
  protect_from_forgery
  WillPaginate.per_page = 16

  helper_method :is_admin?, :can_view_admin_area?

  def search
    @searchresults = Widget.includes(:versions).where("widgets.active = ? AND versions.title LIKE '%#{params[:q]}%'", true).order("versions.created_at DESC")
    render :partial => 'core/searchresults'
  end

  $version_sorts = ["title"]

  def get_sort(default = "average_rating desc")
    ret = default
    if params[:s] && params[:d]
      if $version_sorts.include?(params[:s])
        ret = "versions.#{params[:s]} #{params[:d]}"
      elsif params[:s].eql? "popularity"
        ret = "num_downloads #{params[:d]}, num_ratings #{params[:d]}, average_rating #{params[:d]}"
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

  def redirect_to_back(default = root_path)
    unless request.env["HTTP_REFERER"].blank? || request.env["HTTP_REFERER"].eql?(request.env["REQUEST_URI"])
      redirect_to :back
    else
      redirect_to default
    end
  end

  # Error handling
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from ActionController::UnknownAction, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  private
  def render_404(error)
    @not_found_path = error.message
    @error = true
    respond_to do |format|
      format.html { render 'errors/e404', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_500(error)
    @error = error
    respond_to do |format|
      format.html { render 'errors/e500', status: 500 }
      format.all { render nothing: true, status: 500}
    end
  end


end
