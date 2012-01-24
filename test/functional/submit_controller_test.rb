require 'test_helper'

class SubmitControllerTest < ActionController::TestCase
  test "ensure version deletion works" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending)
    get :destroy, :id => version.id
    # Verify the version was deleted
    assert_raise ActiveRecord::RecordNotFound do
      Version.find(version.id)
    end
    # Verify the widget was also deleted
    assert_raise ActiveRecord::RecordNotFound do
      Widget.find(widget.id)
    end
  end

  test "deleting a version does not delete a widget if the widget has two versions" do
    widget = FactoryGirl.create(:widget)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.accepted)
    version_two = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending)
    get :destroy, :id => version_two.id
    # Verify the version was deleted
    assert_raise ActiveRecord::RecordNotFound do
      Version.find(version_two.id)
    end
    assert_not_nil Version.find(version.id), "Previous version is in tact"
    assert_not_nil Widget.find(widget.id), "Deleting the pending version did not delete the widget"
  end
end
