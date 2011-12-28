class BrowseController < ApplicationController
  def index
    @featured = Widget.find_accepted(:limit => 3)
    @widgets = Widget.find_accepted(:limit => 16)
    @count = Widget.find_accepted(:count => true)
    render :layout => 'lhnavcontent'
  end
end
