class DeveloperdetailsController < ApplicationController
  def index
    @developer = User.find(:first, :conditions => {:url_title => params[:developer_name]})
    @widgets = @developer.widgets
  end
end
