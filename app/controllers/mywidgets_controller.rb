class MywidgetsController < ApplicationController

  def index
    if !user_signed_in?
      redirect_to :root
    else
      @states = State.all
      @widgets_in_state = []
      @declined = false

      @states.each do |state|
        @widgets_in_state[state.id] = Widget.count_by_state(state.id, current_user.id)
        if state.title.downcase.eql?("declined") && @widgets_in_state[state.id].size > 0
          @declined = true
        end
      end

      order = get_sort("average_rating desc")

      if params[:filter]
        @widgets = Widget.find_by_state(params[:filter], order, current_user.id)
        @count = @widgets.size
      else
        @widgets = Widget.where(:user_id => current_user.id).order(order).page(params[:page])
        @count = Widget.count(:conditions => {:user_id => current_user.id})
      end

      if request.xhr?
        render :partial => "pagewidgets/widget_list"
      else
        render :layout => 'lhnavigation'
      end
    end
  end

end
