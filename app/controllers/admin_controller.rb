class AdminController < ApplicationController
  before_filter :authenticate
  layout 'admin'
  WillPaginate.per_page = 24

  def widgets
    state = params[:state] ? params[:state] : State.pending
    logger.debug "state --- #{state} ---"
    @widgets = Widget.includes(:versions).where("versions.state_id = ?", state).order("versions.created_at desc")
  end

  def users
  end

  def options
  end

  def reviewed
    widget = Widget.find(params[:widget_id])
    render :json => {"success" => true}.to_json
  end

  private

    def authenticate
      if !can_view_admin_area?
        redirect_to :root
      end
    end

end
