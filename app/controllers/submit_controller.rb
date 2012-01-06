class SubmitController < ApplicationController
  def index
    @widget = Widget.new
    @version = Version.new
    3.times { @version.screenshots.build }
  end

  def create
    @widget = Widget.new
    @widget[:user_id] = current_user[:id]
    @widget[:url_title] = params[:version][:title].split(" ").collect{|t| t.downcase}.join("-")
    @widget[:active] = false
    @widget.save

    version = Version.new(params[:version])
    version[:state_id] = State.pending
    version[:widget_id] = @widget.id
    version.save

    respond_to do |format|
      format.js
    end

  end

  def edit
    @widget = Widget.find(params[:widget_id])
    @version = Version.where(:widget_id => params[:widget_id]).order("created_at desc").limit(1).first
  end

  def new_version
  end
end
