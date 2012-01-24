require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  test "should register a user" do
    flexmock(User).new_instances.should_receive(:verify_recaptcha).and_return(true)
    request.env["devise.mapping"] = Devise.mappings[:user]
    post :create, {
      :user => {
        :first_name => "Jackson",
        :last_name => "Teller",
        :email => "jax@tellermorrow.invalid",
        :username => "jax",
        :password => "test",
        :password_confirmation => "test"
      }
    }
    assert_equal "http://test.host/", response.header["Location"], "Redirected to the correct host"
    assert_response 302, "successfully registered a user"
  end

  test "should not register without matching passwords" do
    flexmock(User).new_instances.should_receive(:verify_recaptcha).and_return(true)
    request.env["devise.mapping"] = Devise.mappings[:user]
    post :create, {
      :user => {
        :first_name => "Gemma",
        :last_name => "Teller",
        :email => "gemma@tellermorrow.invalid",
        :username => "gemma",
        :password => "test",
        :password_confirmation => "nottest"
      }
    }
    assert_equal 1, assigns(:resource).errors.messages[:password].size, "Passwords must match"
  end

end
