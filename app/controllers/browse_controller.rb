class BrowseController < ApplicationController
  def index

    args = {
      :active => true
    }

    order = get_sort

    if params[:category_title]
      @cat = Category.first(:conditions => {:url_title => params[:category_title]})
      @widgets = Widget.includes(:version => :categories).where("widgets.active = ? AND versions.title LIKE '%#{params[:q]}%'", true).where("categories_versions.category_id = ?", @cat.id).order(order).page(params[:page])
    else
      @widgets = Widget.includes(:versions).where("widgets.active = ? AND versions.title LIKE '%#{params[:q]}%'", true).order(order).page(params[:page])
      @featured = Widget.includes(:versions).where(args).order(order).limit(3)
    end

    @categories = Category.includes(:versions => :widget).where("widgets.active = ?", true)
    if request.xhr?
      render :partial => "browse/livesearch"
    else
      render :layout => 'lhnavigation'
    end
  end
end
