require 'test_helper'

class WidgetApprovalTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "verify that a user cannot view an unapproved widget" do
    submitter = FactoryGirl.create(:user)
    reviewer = FactoryGirl.create(:user, :reviewer => true, :admin => true)
    third_user = FactoryGirl.create(:user)
    widget = FactoryGirl.create(:widget, :user_id => submitter.id, :active => false)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending, :released_on => nil)
    sign_in_as_user(reviewer)
    visit widget_path(widget.url_title)
    assert page.has_content?('pending review'), "Reviewer can view pending widget"
    sign_out
    sign_in_as_user(third_user)
    visit widget_path(widget.url_title)
    assert_equal 404, page.status_code, "Non-reviewer cannot see pending widget"
    sign_out
    sign_in_as_user(reviewer)
    visit admin_review_widget_path(:review => "declined", :version_id => version.id)
    visit widget_path(widget.url_title)
    assert page.has_content?('has been declined'), "Reviewer can view rejected widget"
    sign_out
    sign_in_as_user(third_user)
    visit widget_path(widget.url_title)
    assert_equal 404, page.status_code, "Non-reviewer cannot view rejected widget"
  end

  test "verify that a user view an approved widget" do
    submitter = FactoryGirl.create(:user)
    reviewer = FactoryGirl.create(:user, :reviewer => true, :admin => true)
    third_user = FactoryGirl.create(:user)
    widget = FactoryGirl.create(:widget, :user_id => submitter.id, :active => false)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending, :released_on => nil)
    sign_in_as_user(reviewer)
    visit admin_review_widget_path(:review => "accepted", :version_id => version.id)
    sign_out
    sign_in_as_user(third_user)
    visit widget_path(widget.url_title)
    assert page.has_content?(version.title), "Non-reviewer can view approved widget"
  end

end
