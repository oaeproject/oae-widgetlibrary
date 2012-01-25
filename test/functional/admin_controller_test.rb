require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should deny users view rights to rejected widgets" do
    request.env["devise.mapping"] = Devise.mappings[:user]
    submitter = FactoryGirl.create(:user)
    reviewer = FactoryGirl.create(:user, :reviewer => true)
    third_user = FactoryGirl.create(:user)
    widget = FactoryGirl.create(:widget, :user_id => submitter.id)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending, :released_on => nil)
    sign_in reviewer
    post :reviewed, {
      :version_id => version.id,
      :review => "declined",
      :notes => "can't stand this widget!"
    }
    sign_out reviewer
    sign_in third_user
  end
end
