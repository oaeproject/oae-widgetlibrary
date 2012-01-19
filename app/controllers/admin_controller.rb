class AdminController < ApplicationController
  before_filter :authenticate
  layout 'admin'
  WillPaginate.per_page = 24

  def widgets
    state = params[:state] ? params[:state] : State.pending
    widgets = Widget.includes(:versions).where("versions.state_id = ?", state).order("versions.created_at desc")
    @widgets = widgets

    if state.eql? State.pending
      @widgets = []
      widgets.each do |widget|
        if (widget.versions.size == 1 || widget.latest_version != widget.version) && widget.latest_version.state_id.eql?(state)
          @widgets.push(widget)
        end
      end
    end
  end

  def users
  end

  def options
  end

  def reviewed
    version = Version.find(params[:version_id])
    new_state = State.where(:title => params[:review]).first
    version.state_id = new_state.id
    version.notes = params[:notes]
    version.user_id = current_user.id
    version.reviewed_on = Time.now

    widget = Widget.find(version.widget.id)

    if new_state.id.eql? State.accepted
      version.released_on = Time.now
      widget.active = true
      widget.version_id = version.id
    end

    unless widget.version_id.nil?
      saved = version.save && widget.save
    else
      saved = version.save
    end

    if saved
      render :json => {"success" => true}.to_json
      WidgetMailer.reviewed(version, widget).deliver
    else
      render :json => {"success" => false}.to_json
    end
  end

  private

    def authenticate
      if !can_view_admin_area?
        redirect_to :root
      end
    end

end
