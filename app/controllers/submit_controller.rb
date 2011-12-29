class SubmitController < ApplicationController
  def index
    @widget = Widget.new
    3.times { @widget.screenshots.build }
  end

  def create
    @widget = Widget.new(params[:widget])
    @widget[:user_id] = current_user[:id]
    @widget[:state_id] = State.where(:title => "pending").first.id
    @widget[:url_title] = @widget.title.split(" ").collect!{|t| t.downcase}.join("-")
    respond_to do |format|
      @widget.save
      format.js
    end
  end

  def edit
  end
end
