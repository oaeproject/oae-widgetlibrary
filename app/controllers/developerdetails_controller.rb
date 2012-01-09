class DeveloperdetailsController < ApplicationController
  def index
    @developer = User.find(:first, :conditions => {:url_title => params[:url_title]})
    @widgets = @developer.widgets
  end
end
