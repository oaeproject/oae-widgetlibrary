class WidgetController < ApplicationController
  def show
    widget_title = params[:widget_title]
    @widget = Widget.first( :conditions => { :title => widget_title } )
    if not @widget.state.title.eql? "accepted" and @widget.user != current_user
      redirect_to :root
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
