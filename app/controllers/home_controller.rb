class HomeController < ApplicationController
  def index
    @location = "index"
  end
  def library
    @location = "library"
  end
end
