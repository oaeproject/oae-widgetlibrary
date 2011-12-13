class DeveloperdetailsController < ApplicationController
  def index
    @developer = User.find_by_name(params[:developer_name])
    @widgets = @developer.widgets
  end
end
