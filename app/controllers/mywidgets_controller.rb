class MywidgetsController < ApplicationController

  def index
    if !user_signed_in?
      redirect_to :root
    else
      @states = []
      @widgets_in_state = {}
      @declined = false
      State.all.each do |state|
        @states.push(state)
        widgets_in_filter = Widget.count(:conditions => {:state_id => state.id, :user_id => current_user.id})
        @widgets_in_state[state.id] = widgets_in_filter
        if state.title.downcase.eql?("declined") && widgets_in_filter > 0
          @declined = true
        end
      end

      if params[:filter]
        filterstate = State.where(:title => params[:filter]).first
        @widgets = Widget.where(:state_id => filterstate.id, :user_id => current_user.id).limit(20)
        @count = @widgets_in_state[filterstate.id]
      else
        @widgets = Widget.where(:user_id => current_user.id).limit(20)
        @count = Widget.count(:conditions => {:user_id => current_user.id})
      end

      render :layout => 'lhnavcontent'
    end
  end

end
