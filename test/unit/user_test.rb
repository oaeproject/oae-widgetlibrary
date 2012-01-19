require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user should not save without it's required attributes" do
    user = User.new
    assert !user.save, "Saved the user without any required attributes"
  end
end
