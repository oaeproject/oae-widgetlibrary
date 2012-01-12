class ErrorsController < ApplicationController
  def e404
    @not_found_path = params[:not_found]
  end

  def e500
  end
end
