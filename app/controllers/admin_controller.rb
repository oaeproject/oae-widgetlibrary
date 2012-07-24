class AdminController < ApplicationController
  before_filter :authenticate
  layout 'admin'
  WillPaginate.per_page = 24
  include AdminHelper

  before_filter :get_language_config, :only => [:options, :edit_language]
  before_filter :get_category_config, :only => [:categories, :edit_category]

  def widgets
    state = params[:state] ? params[:state] : State.pending
    widgets = Widget.includes(:versions).where("versions.state_id = ?", state).order("versions.created_at desc")
    @widgets = widgets

    if state.eql? State.pending
      @widgets = []
      widgets.each do |widget|
        if (widget.versions.size == 1 || widget.latest_version != widget.version) && widget.latest_version.state_id.eql?(state)
          @widgets.push(widget)
        end
      end
    end
  end

  def users
    @users = User.find(:all, :order => 'last_name')
  end

  def adminusers
    @users = User.find(:all, :conditions => ["admin = ?", true], :order => 'last_name')
  end

  def user_update
    user = User.find(params[:user_id])
    user.admin = params["chk_user_admin" + params[:user_id]]
    user.reviewer = params["chk_user_reviewer" + params[:user_id]]
    user.save
    head :ok
  end

  def options
    @results = Language.find(:all, :order => "title")
    get_used_items(Language)
    @item = Language.new
  end

  def edit_language
    @item = Language.find(params[:id])
  end

  def save_language
    fail_render = params[:add_new] == "true" ? "options" : "edit_language"
    save_item(Language, ["title", "code", "region"], :admin_options, fail_render, get_language_config)
  end

  def remove_language
    Language.find(params[:id]).destroy
    redirect_to :admin_options
  end

  def categories
    @results = Category.find(:all, :order => "title")
    get_used_items(Category)
    @item = Category.new
  end

  def edit_category
    @item = Category.find(params[:id])
  end

  def save_category
    fail_render = params[:add_new] == "true" ? "categories" : "edit_category"
    save_item(Category, ["title", "url_title"], :admin_categories, fail_render, get_category_config)
  end

  def remove_category
    Category.find(params[:id]).destroy
    redirect_to :admin_categories
  end

  def reviewed
    version = Version.find(params[:version_id])
    new_state = State.where(:title => params[:review]).first
    version.state_id = new_state.id
    version.notes = params[:notes]
    version.user_id = current_user.id
    version.reviewed_on = Time.now

    widget = Widget.find(version.widget_id)

    if new_state.id.eql? State.accepted
      version.released_on = Time.now
      widget.active = true
      widget.version_id = version.id
    end

    unless widget.version_id.nil?
      saved = version.save && widget.save
    else
      saved = version.save
    end

    if saved
      render :json => {"success" => true}.to_json
      WidgetMailer.delay.reviewed(version, widget)
    else
      render :json => {"success" => false}.to_json
    end
  end

  def statistics
    @user_count = User.count()
    @users_login_ranking = User.order("sign_in_count desc").limit(5)
    @users_widget_ranking = User.joins(:widgets).select("users.id, users.name, users.url_title, count(*) as total").group("user_id").order("total desc").limit(5)
    @widget_count = Widget.count()
    @rating_average = Widget.average("average_rating").round(2)
    @rating_count = Rating.count()
  end

  private

    def authenticate
      if !can_view_admin_area?
        redirect_to :root
      end
    end

end
