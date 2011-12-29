class BrowseController < ApplicationController
  def index
    @categories = Category.all
    args = {}
    if params[:category_title]
      args[:category_id] = Category.find(:first, :conditions => {:url_title => params[:category_title]})
    end
    @featured = Widget.find_accepted({:limit => 3}.merge(args))
    @widgets = Widget.find_accepted({:limit => 16}.merge(args))
    @count = Widget.find_accepted({:count => true}.merge(args))

    render :layout => 'lhnavigation'
  end
end
