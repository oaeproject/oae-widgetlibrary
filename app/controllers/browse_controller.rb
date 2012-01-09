class BrowseController < ApplicationController
  def index

    args = {
      :active => true
    }

    order = get_sort("average_rating desc")

    if params[:category_title]
      cat = Category.first(:conditions => {:url_title => params[:category_title]})
      @widgets = Widget.where(args).includes(:version => :categories).where("categories_versions.category_id = ?", cat.id).order(order).page(params[:page])
      @cat_title = cat.title
    else
      @widgets = Widget.where(args).includes(:versions).order(order).page(params[:page])
    end

    if request.xhr?
      render :partial => "pagewidgets/widget_list"
    else
      @categories = Category.all
      @featured = Widget.includes(:versions).where(args).order(order).limit(3)

      render :layout => 'lhnavigation'
    end
  end
end
