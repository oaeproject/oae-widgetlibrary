class SubmitController < ApplicationController
  def new
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

    @version = Version.new(params[:version])
    @version[:state_id] = State.pending
    @version[:widget_id] = @widget.id
    @version.save

    respond_to do |format|
      format.js
    end

  end

  def edit
    @widget = Widget.find(params[:id])
    @version = Version.where(:widget_id => params[:id]).order("created_at desc").limit(1).first
  end

  def update
    old_version = Version.find(params[:id])
    @version = old_version.dup
    widget_id = @version.widget_id
    @widget = Widget.find(widget_id)

    # Update attachments manually
    @version.code = old_version.code
    @version.icon = old_version.icon
    @version.screenshots = old_version.screenshots

    @version[:state_id] = State.pending
    @version.update_attributes!(params[:version])

    if old_version.state_id.eql?(State.pending)
      old_version.state_id = State.superseded
      old_version.notes = "Superseded by the submission on #{Time.now.strftime("%B %e, %Y at %l:%M%P")}"
      old_version.save!
    end

    respond_to do |format|
      format.js
    end

  end

end
