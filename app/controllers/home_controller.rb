class HomeController < ApplicationController
  def index
  end
  def widget
    @location = "library"
    @widget = params[:id]
  end
end
