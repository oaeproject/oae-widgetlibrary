class BrowseController < ApplicationController
  def index
    @featured = Widget.find_accepted(:limit => 3)
    @widgets_in_category = Widget.find_accepted(:limit => 16)
    render :layout => 'lhnavcontent'
  end
end
