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

  test "widget shows up in mywidgets submissions after approval" do
    submitter = FactoryGirl.create(:user)
    reviewer = FactoryGirl.create(:user, :reviewer => true, :admin => true)
    widget = FactoryGirl.create(:widget, :user_id => submitter.id, :active => false)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending, :released_on => nil)

    sign_in_as_user(reviewer)
    visit admin_review_widget_path(:review => "accepted", :version_id => version.id)
    sign_out

    sign_in_as_user(submitter)
    visit mywidgets_path
    assert page.has_content?(version.title), "Approved widget correctly shows up in My Widgets"
    visit browse_path
    assert page.has_content?(version.title), "Approved widget correctly shows up in Browse"
  end

  test "widget info updates during the review process" do
    submitter = FactoryGirl.create(:user)
    reviewer = FactoryGirl.create(:user, :reviewer => true, :admin => true)
    third_user = FactoryGirl.create(:user)
    widget = FactoryGirl.create(:widget, :user_id => submitter.id, :active => false)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending, :released_on => nil, :title => "First Title 123")

    sign_in_as_user(reviewer)
    visit admin_review_widget_path(:review => "accepted", :version_id => version.id)
    sign_out

    sign_in_as_user(submitter)
    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version.title), "Initial widget title is correct"
    sign_out

    version_update = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending, :released_on => nil, :title => "New Title 456")

    sign_in_as_user(reviewer)
    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version_update.title), "Reviewer can view updated widget title"
    sign_out

    sign_in_as_user(submitter)
    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version_update.title), "Submitter can view updated widget title"
    sign_out

    sign_in_as_user(third_user)
    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version.title), "Non-admin user who is not the submitter cannot view the latest pending version"
    sign_out

    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version.title), "Anonymous user cannot view the latest pending version"

    sign_in_as_user(reviewer)
    visit admin_review_widget_path(:review => "accepted", :version_id => version_update.id)
    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version_update.title), "Approved widget shows updated title"

    version_to_decline = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending, :released_on => nil, :title => "Best Version 789")

    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version_to_decline.title), "Third version has correct title for reviewer"
    visit admin_review_widget_path(:review => "declined", :version_id => version_to_decline.id)
    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version_update.title), "After decline, reviewer sees the approved version"
    sign_out

    sign_in_as_user(submitter)
    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version_update.title), "After decline, submitter sees the approved version"
    sign_out

    sign_in_as_user(third_user)
    visit widget_path(widget.url_title)
    assert find("#widget_description h1").has_content?(version_update.title), "Non-admin user who is not the submitter sees the correct version after decline"
    sign_out

  end

  test "ensure screenshots update when submitting a new version" do
    submitter = FactoryGirl.create(:user)
    reviewer = FactoryGirl.create(:user, :reviewer => true, :admin => true)
    widget = FactoryGirl.create(:widget, :user_id => submitter.id, :active => false)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending, :released_on => nil)
    screenshot = FactoryGirl.create(:screenshot, :version_id => version.id)

    # Sign in as submitter and verify the original screenshot has the correct path
    sign_in_as_user(submitter)
    visit widget_path(widget.url_title)
    screenshot_page_src = find("#widgetdetails_main_screenshot")["src"].split("?")[0]
    screenshot_src = screenshot.image.url(:medium).split("?")[0]
    assert_equal screenshot_src, screenshot_page_src, "Original screenshot has the correct path"
    sign_out

    # Approve the widget
    sign_in_as_user(reviewer)
    visit admin_review_widget_path(:review => "accepted", :version_id => version.id)
    sign_out

    # Submit a new version and check to see that the new version screenshot
    # shows on the widget page
    sign_in_as_user(submitter)
    visit edit_version_path(version)
    attach_file("version_screenshots_attributes_0_image", Rails.root.to_s + '/test/fixtures/images/2.png')
    click_button "Save and Upload Widget"
    visit widget_path(widget.url_title)
    # a little hacky, I know, so watch out for the second split not working
    screenshot_page_file_name = find("#widgetdetails_main_screenshot")["src"].split("?")[0].split("/system/images/2/medium/")[1]
    assert_equal "2.png", screenshot_page_file_name, "Updated screenshot has the correct path"
    sign_out

    # Decline the widget and check to see that the screenshot reverts back to
    # the originally uploaded one
    new_version = Version.where(:widget_id => widget.id).order("created_at desc").first
    sign_in_as_user(reviewer)
    visit admin_review_widget_path(:review => "declined", :version_id => new_version.id)
    visit widget_path(widget.url_title)
    screenshot_page_src = find("#widgetdetails_main_screenshot")["src"].split("?")[0]
    screenshot_src = screenshot.image.url(:medium).split("?")[0]
    assert_equal screenshot_src, screenshot_page_src, "After declining, the screenshot has the correct path"
  end

  test "ensure code and icons update when submitting a new version" do
    submitter = FactoryGirl.create(:user)
    reviewer = FactoryGirl.create(:user, :reviewer => true, :admin => true)
    widget = FactoryGirl.create(:widget, :user_id => submitter.id, :active => false)
    version = FactoryGirl.create(:version, :widget_id => widget.id, :state_id => State.pending, :released_on => nil)

    # Approve the widget
    sign_in_as_user(reviewer)
    visit admin_review_widget_path(:review => "accepted", :version_id => version.id)
    sign_out

    # Sign in as submitter and submit a new version
    sign_in_as_user(submitter)
    visit edit_version_path(version)
    attach_file("version_code", Rails.root.to_s + '/test/fixtures/zip/2.png.zip')
    attach_file("version_icon", Rails.root.to_s + '/test/fixtures/images/2.png')
    click_button "Save and Upload Widget"
    visit widget_path(widget.url_title)
    sign_out

    new_version = Version.where(:widget_id => widget.id).order("created_at desc").first
    assert_equal "2.png.zip", new_version.code_file_name, "New version has updated code"
    assert_equal "2.png", new_version.icon_file_name, "New version has updated icon"

    # Decline the widget
    sign_in_as_user(reviewer)
    visit admin_review_widget_path(:review => "declined", :version_id => new_version.id)
    sign_out

    final_version = Version.find(version.id)
    assert_equal "1.png.zip", version.code_file_name, "Final version has original code"
    assert_equal "1.png", version.icon_file_name, "Final version has original icon"
  end

end
