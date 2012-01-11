class WidgetController < ApplicationController
  def show
    widget_title = params[:title]
    @widget = Widget.first( :conditions => { :url_title => widget_title } )

    if !@widget || (!can_view_admin_area? && (!@widget.active_version && @widget.user != current_user))
      not_found
    end

    if can_view_in_progress_widget
      if (@widget.latest_version != @widget.version) || (@widget.versions.size == 1 && !@widget.state.id.eql?(State.accepted))
        @latest_version = @widget.latest_version
      end

      if !@widget.version
        @widget.version = Version.where(:widget_id => @widget.id).order("created_at desc").limit(1).first
      end
    end

    @versions = @widget.approved_versions.order("version_number desc")
    @related = Widget.where(:active => true).order("random()").limit(5)
    if user_signed_in?
      @rating = Rating.where(:user_id => current_user.id, :widget_id => @widget.id).first || Rating.new
    end
  end

  def update_average_rating(widget_id)
    ratings = Rating.where(:widget_id => widget_id)
    widget = Widget.where(:id => widget_id).first

    total_stars = 0

    ratings.each do |rating|
      total_stars += rating.stars
    end

    widget.average_rating = total_stars.to_f / ratings.size.to_f

    widget.save
  end

  def rating_create
    if Widget.find(params[:rating][:widget_id]).user.id != current_user.id
      @rating = Rating.new(params[:rating])
      if @rating.save
        update_average_rating(params[:rating][:widget_id])
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def rating_update
    @rating = Rating.where(:user_id => current_user.id, :widget_id => params[:rating][:widget_id]).first
    if @rating
      @rating.update_attributes(params[:rating])
      if @rating.save
        update_average_rating(params[:rating][:widget_id])
      end
    end

    respond_to do |format|
      format.js
    end
  end

  protected
  def can_view_in_progress_widget
    @widget.user == current_user || can_view_admin_area?
  end

end
