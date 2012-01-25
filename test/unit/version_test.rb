require 'test_helper'

class VersionTest < ActiveSupport::TestCase
  test "should not create version without required attributes" do
    version = Version.new
    assert !version.save, "Version created without required attributes"
  end

  test "should create version" do
    version = FactoryGirl.create(:version)
    assert version, "version successfully created"
  end

  test "should verify reviewer" do
    version = FactoryGirl.create(:version)
    assert version.reviewer, "version has a reviewer"
  end

  test "should verify widget relationship to version" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :widget_id => widget.id)
    assert_equal version.widget.id, widget.id, "version has a widget"
  end
end
