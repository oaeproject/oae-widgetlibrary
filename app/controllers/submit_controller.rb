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

    @version = Version.new(params[:version])
    @version[:state_id] = State.pending

    valid = @widget.valid? && @version.valid?

    if valid
      @widget.save
      @version[:widget_id] = @widget.id
      @version.save
    end

    respond_to do |format|
      format.js
    end

    if valid
      WidgetMailer.new_submission(@version, @widget).deliver
    end

  end

  def edit
    @widget = Widget.find(params[:id])
    @version = Version.where(:widget_id => params[:id]).order("created_at desc").limit(1).first
    (3-@version.screenshots.size).times { @version.screenshots.build }
  end

  def update
    old_version = Version.find(params[:id])
    widget_id = old_version.widget_id
    @widget = Widget.find(widget_id)

    screenshots = params[:version][:screenshots_attributes]
    params[:version].delete(:screenshots_attributes)

    @version = Version.new
    @version.widget_id = widget_id
    @version.code = old_version.code
    @version.icon = old_version.icon
    @version[:state_id] = State.pending
    @version.attributes = params[:version]

    # Some special hackery is necessary to update the screenshots
    @version.screenshots << old_version.screenshots.collect do |ss|
      update = false
      screenshots.each do |new_ss|
        # Check to see if the new screenshots are an update to an existing one
        if new_ss[1][:id].to_i.eql?(ss.id) && new_ss[1].key?(:image)
          update = new_ss[1]
          update.delete(:id)
          break
        end
      end
      unless update
        Screenshot.new(:image => ss.image.to_file)
      else
        Screenshot.new(update)
      end
    end

    if @version.save
      if old_version.state_id.eql?(State.pending)
        old_version.state_id = State.superseded
        old_version.notes = "Superseded by the submission on #{Time.now.strftime("%B %e, %Y at %l:%M%P")}"
        old_version.save
      end
      WidgetMailer.new_submission(@version, @widget).deliver
    end

    respond_to do |format|
      format.js
    end

  end

end
