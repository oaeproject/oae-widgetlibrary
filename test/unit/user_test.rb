require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save new user without required attributes" do
    user = User.new
    assert !user.save, "Saved the user without any required attributes"
  end
end
