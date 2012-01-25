require 'test_helper'

class WidgetControllerTest < ActionController::TestCase
  test "should default to showing screenshots" do
    request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.accepted)
    widget.version_id = version.id
    widget.save
    screenshot = FactoryGirl.create(:screenshot, :version_id => version.id)

    sign_in user
    get :show, {:title => widget.url_title}
    assert_select ".wl-inpage-tab.selected", "Screenshots"
    assert_select "#widgetdetails_screenshots.selected"
  end

  test "should not show any screenshots when they do not exist" do
    request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.accepted)
    widget.version_id = version.id
    widget.save

    sign_in user
    get :show, {:title => widget.url_title}
    assert_select ".wl-inpage-tab.selected", "Reviews"
    assert_select "#widgetdetails_reviews.selected"
  end

  test "should select correct tab when show param is passed in" do
    request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.accepted)
    widget.version_id = version.id
    widget.save
    screenshot = FactoryGirl.create(:screenshot, :version_id => version.id)
    sign_in user

    get :show, {:title => widget.url_title, :show => "screenshots"}
    assert_select ".wl-inpage-tab.selected", "Screenshots"
    assert_select "#widgetdetails_screenshots.selected"

    get :show, {:title => widget.url_title, :show => "reviews"}
    assert_select ".wl-inpage-tab.selected", "Reviews"
    assert_select "#widgetdetails_reviews.selected"

    get :show, {:title => widget.url_title, :show => "versions"}
    assert_select ".wl-inpage-tab.selected", "Uploaded versions"
    assert_select "#widgetdetails_versions.selected"
  end
end
