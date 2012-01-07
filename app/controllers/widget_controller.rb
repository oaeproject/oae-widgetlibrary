class WidgetController < ApplicationController
  def show
    widget_title = params[:title]
    @widget = Widget.first( :conditions => { :url_title => widget_title } )

    if !can_view_admin_area? && (!@widget.active_version && @widget.user != current_user)
      not_found
    elsif !@widget.active_version && @widget.user == current_user
      @widget.version = Version.where(:widget_id => @widget.id).order("created_at desc").limit(1).first
    end

    @versions = @widget.approved_versions.order("version_number desc")
    @related = Widget.where(:active => true).order("random()").limit(5)
    if user_signed_in?
      @rating = Rating.where(:user_id => current_user.id, :widget_id => @widget.id).first || Rating.new
    end
  end

  def rating_create
    if Widget.find(params[:rating][:widget_id]).user.id != current_user.id
      @rating = Rating.new(params[:rating])
      @rating.save!
    end
    redirect_to :action => :show
  end
  
  def rating_update
    @rating = Rating.where(:user_id => current_user.id, :widget_id => params[:rating][:widget_id]).first
    if @rating
      @rating.update_attributes(params[:rating])
      @rating.save!
    end
    redirect_to :action => :show
  end

end
