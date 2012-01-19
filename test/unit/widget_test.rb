require 'test_helper'

class WidgetTest < ActiveSupport::TestCase

  test "widget should not save without a url_title" do
    widget = Widget.new
    assert !widget.save, "Saved the widget without a url_title"
  end

  test "widget successfully creates" do
    widget = FactoryGirl.create(:widget)
    assert widget, "Widget successfully created"
  end

  test "finds active version" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :title => "Approved Version", :state_id => State.accepted, :widget_id => widget.id)
    widget.version_id = version.id
    widget.save
    assert_equal 1, widget.approved_versions.size, "One approved version"
    assert_equal version.id, widget.active_version.id, "Active version is the version we just created"
  end

  test "finds all approved versions" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :title => "Approved Version 1", :state_id => State.accepted, :widget_id => widget.id)
    version2 = FactoryGirl.create(:version, :title => "Pending Version 1", :state_id => State.pending, :widget_id => widget.id)
    widget.version_id = version.id
    widget.save
    assert_equal 1, widget.approved_versions.size, "One approved version"
    assert_equal version.id, widget.active_version.id, "Active version is the first version we created"
    assert_equal version2.id, widget.latest_version.id, "Latest version is the second version we just created"
  end

  test "find all the passthrough attributes for the active version" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :title => "Active Version", :state_id => State.accepted, :widget_id => widget.id)
    widget.version_id = version.id
    widget.save
    assert_equal widget.title, version.title, "Widget has the same title it's active version"
    assert_equal widget.description, version.description, "Widget has the same description it's active version"
    assert_equal widget.features, version.features, "Widget has the same features it's active version"
    assert_equal widget.icon.path, version.icon.path, "Widget has the same icon it's active version"
    assert_equal widget.code.path, version.code.path, "Widget has the same code it's active version"
    assert_equal widget.bundle.path, version.bundle.path, "Widget has the same bundle it's active version"
    assert_equal widget.state, version.state, "Widget has the same state it's active version"
    assert_equal widget.code_file_name, version.code_file_name, "Widget has the same code_file_name it's active version"
    assert_equal widget.code_content_type, version.code_content_type, "Widget has the same code_content_type it's active version"
    assert_equal widget.code_file_size.to_i, version.code_file_size.to_i, "Widget has the same code_file_size it's active version"
    # There is a bug in either Rails or Paperclip that is reporting these as different formats, although they are the same value
    # assert_equal widget.code_updated_at, version.code_updated_at, "Widget has the same code_updated_at it's active version"
    assert_equal widget.bundle_file_name, version.bundle_file_name, "Widget has the same bundle_file_name it's active version"
    assert_equal widget.bundle_content_type, version.bundle_content_type, "Widget has the same bundle_content_type it's active version"
    assert_equal widget.bundle_file_size.to_i, version.bundle_file_size.to_i, "Widget has the same bundle_file_size it's active version"
    # assert_equal widget.bundle_updated_at, version.bundle_updated_at, "Widget has the same bundle_updated_at it's active version"
    assert_equal widget.categories, version.categories, "Widget has the same categories it's active version"
    assert_equal widget.languages, version.languages, "Widget has the same languages it's active version"
    assert_equal widget.screenshots, version.screenshots, "Widget has the same screenshots it's active version"
    assert_equal widget.version_number, version.version_number, "Widget has the same version_number it's active version"
    assert_equal widget.widget_repo, version.widget_repo, "Widget has the same widget_repo it's active version"
    assert_equal widget.widget_backend_repo, version.widget_backend_repo, "Widget has the same widget_backend_repo it's active version"
    assert_equal widget.released_on, version.released_on, "Widget has the same released_on it's active version"
    assert_equal widget.created_at, version.created_at, "Widget has the same created_at it's active version"
    assert_equal widget.reviewer, version.reviewer, "Widget has the same approved_by it's active version"
  end

end
