class WidgetController < ApplicationController
  def show
    widget_title = params[:widget_title]
    @widget = Widget.find_by_title(widget_title)
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
