require 'test_helper'

class VersionTest < ActiveSupport::TestCase
  test "version shouldn't save without :title, :description, :features, :version_number, :icon, and :code" do
    version = Version.new
    assert !version.save, "Version created without required attributes"
  end

  test "create version" do
    version = FactoryGirl.create(:version)
    assert version, "version successfully created"
  end

  test "verify reviewer" do
    version = FactoryGirl.create(:version)
    assert version.reviewer, "version has a reviewer"
  end

  test "verify widget relationship" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :widget_id => widget.id)
    assert_equal version.widget.id, widget.id, "version has a widget"
  end
end
