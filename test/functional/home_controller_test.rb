require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "objects created for views exist and have the correct number of elements in them" do
    16.times do
      widget = FactoryGirl.create(:widget)
      version = FactoryGirl.create(:version, :widget_id => widget.id)
      widget.version_id = version.id
      widget.save
    end
    get :index
    assert_not_nil assigns(:recentlyadded), "@recentlyadded has been assigned"
    assert_not_nil assigns(:toprated), "@toprated has been assigned"
    assert_not_nil assigns(:mostpopular), "@mostpopular has been assigned"
    assert_equal 5, assigns(:recentlyadded).size, "recentlyadded has 5 results"
    assert_equal 16, assigns(:toprated).size, "toprated has 16 results"
    assert_equal 5, assigns(:mostpopular).size, "mostpopular has 5 results"
  end
end
