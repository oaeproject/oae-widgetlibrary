require 'test_helper'

class WidgetGeneratorControllerTest < ActionController::TestCase
  test "should get index" do
    get(:zippedwidget, {:widgetbuilder_skeletontype => "skeleton"}, {:widgetbuilder_title => "widgettitle"}, {:widgetbuilder_description => "Description"})
    assert_response :success
  end

end
