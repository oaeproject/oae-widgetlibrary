class BrowseController < ApplicationController
  def index

    args = {}
    if params[:category_title]
      args[:category_id] = Category.find(:first, :conditions => {:url_title => params[:category_title]})
    end

    args[:order] = get_sort("average_rating desc")

    @widgets = Widget.find_accepted({:limit => 16}.merge(args))

    if request.xhr?
      render :partial => "pagewidgets/widget_list"
    else
      @categories = Category.all
      @featured = Widget.find_accepted({:limit => 3}.merge(args))
      @count = Widget.find_accepted({:count => true}.merge(args))
      render :layout => 'lhnavigation'
    end
  end
end
