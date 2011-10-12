class BrowseController < ApplicationController
  def index
    @featured = Widget.limit(3)
    @widgets_in_category = Widget.limit(16)
    render :layout => 'lhnavcontent'
  end
end
