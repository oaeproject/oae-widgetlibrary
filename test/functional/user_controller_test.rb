require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should find user" do
    user = FactoryGirl.create(:user)
    get :index, {:id => user.id, :url_title => user.url_title}
    assert_equal user, assigns(:user), "@user was populated correctly"
  end

  test "should find widgets for a user" do
    user = FactoryGirl.create(:user)
    widget = FactoryGirl.create(:widget, :user_id => user.id)
    version = FactoryGirl.create(:version, :widget_id => widget.id)
    widget.version_id = version.id
    widget.save

    get :index, {:id => user.id, :url_title => user.url_title}
    assert_equal 1, assigns(:widgets).size, "User's widgets were assigned"
  end
end
