class AdminController < ApplicationController
  before_filter :authenticate
  layout 'admin'
  WillPaginate.per_page = 24

  def widgets
    @states = State.all
    @widgets_in_state = {}
    this_count = 0
    @states.each do |state|
      @widgets_in_state[state.id] = Widget.count_by_state(state.id)
      if state.title.eql? params[:filter]
        this_count = @widgets_in_state[state.id]
      end
    end

    order = "created_at desc"

    if params[:filter]
      @widgets = Widget.find_by_state(params[:filter], order, params[:page])
      @count = this_count
    else
      @widgets = Widget.order(order).page(params[:page])
      @count = Widget.count
    end
  end

  def users
  end

  def options
  end

  def reviewed
    widget = Widget.find(params[:widget_id])
    render :json => {"success" => true}.to_json
  end

  private

    def authenticate
      if !can_view_admin_area?
        redirect_to :root
      end
    end

end
