class WidgetController < ApplicationController
  def show
    widget_title = params[:widget_title]
    @widget = Widget.first( :conditions => { :url_title => widget_title } )
    if !can_view_admin_area? && (!@widget.state_id.eql?(State.accepted) && @widget.user != current_user)
      not_found
    end
    @related = Widget.order("random()").limit(5)

    if user_signed_in?
      @rating = Rating.where(:user_id => current_user.id, :widget_id => @widget.id).first || Rating.new
    end
  end

  def rating_create
    @rating = Rating.new(params[:rating])
    @rating.save!

    redirect_to :action => :show
  end
  
  def rating_update
    @rating = Rating.where(:user_id => current_user.id, :widget_id => params[:rating][:widget_id]).first
    @rating.update_attributes(params[:rating])
    @rating.save!

    redirect_to :action => :show
  end

  def new

  end

  def edit

  end

  def update

  end

  def destroy

  end

  def create

  end
end
