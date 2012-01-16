class UserController < ApplicationController
  def index
    # because of the - in url_title, Rails assumes that the id is up until the
    # last -, which isn't what we want, so we manually parse it here
    id = params[:id].split("-")[0]
    @user = User.find(id)
    @widgets = @user.widgets
  end
end
