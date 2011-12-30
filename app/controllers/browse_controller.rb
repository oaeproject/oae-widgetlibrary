class BrowseController < ApplicationController
  def index

    args = {
      :state_id => State.accepted
    }

    order = get_sort("average_rating desc")

    if params[:category_title]
      @widgets = Category.first(:conditions => {:url_title => params[:category_title]}).widgets.where(args).order(order).page(params[:page])
      @count = Category.first(:conditions => {:url_title => params[:category_title]}).widgets.count(:conditions => args)
    else
      @widgets = Widget.where(args).order(order).page(params[:page])
      @count = Widget.count(:conditions => args)
    end

    if request.xhr?
      render :partial => "pagewidgets/widget_list"
    else
      @categories = Category.all
      @featured = Widget.where(args).order(order).limit(3)

      render :layout => 'lhnavigation'
    end
  end
end
