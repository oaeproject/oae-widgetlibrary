require 'test_helper'

class BrowseControllerTest < ActionController::TestCase
  test "should show featured content" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version,
      :widget_id => widget.id,
      :state_id => State.accepted)
    widget.version_id = version.id
    widget.save

    get :index
    assert_equal 1,
      assigns(:featured).size,
      "Correctly assigns one featured item"

    assert_select "#featured .wl-widget-item_widgetname", version.title
  end

  test "should find a widget when searching" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version,
      :widget_id => widget.id,
      :state_id => State.accepted)
    widget.version_id = version.id
    widget.save

    get :index, {:q => version.title[0..2]}
    assert_equal 1, assigns(:widgets).size, "Correctly returned one widget"
    assert_select "#widget_list .wl-widget-item_widgetname", version.title
  end

  test "should return a widget in a category" do
    widget = FactoryGirl.create(:widget)
    category = Category.first
    version = FactoryGirl.create(:version,
      :widget_id => widget.id,
      :state_id => State.accepted,
      :category_ids => [category.id])
    widget.version_id = version.id
    widget.save

    get :index, {:category_title => category.url_title}
    assert_equal 1, assigns(:widgets).size, "Correctly returned one widget"
    assert_select "#widget_list .wl-widget-item_widgetname", version.title
    assert_nil assigns(:featured), "No featured items in categories"
  end

  test "should return a widget in a category with search" do
    widget = FactoryGirl.create(:widget)
    category = Category.first
    version = FactoryGirl.create(:version,
      :widget_id => widget.id,
      :state_id => State.accepted,
      :category_ids => [category.id])
    widget.version_id = version.id
    widget.save

    get :index, {
      :category_title => category.url_title,
      :q => version.title[0..2]
    }
    assert_equal 1, assigns(:widgets).size, "Correctly returned one widget"
    assert_select "#widget_list .wl-widget-item_widgetname", version.title
    assert_nil assigns(:featured), "No featured items in categories"
  end
end
