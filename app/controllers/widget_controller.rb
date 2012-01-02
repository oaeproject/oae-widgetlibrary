class WidgetController < ApplicationController
  def show
    widget_title = params[:widget_title]
    @widget = Widget.first( :conditions => { :url_title => widget_title } )
    if !can_view_admin_area? && (!@widget.state_id.eql?(State.accepted) && @widget.user != current_user)
      not_found
    end
    @related = Widget.order("random()").limit(5)
  end

  def new

  end

  def edit

  end

  def update

  end

  def destroy

  end

  def create

  end
end
