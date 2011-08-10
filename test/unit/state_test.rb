require 'test_helper'

class StateTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "state factory" do
    state = Factory.create(:state)
    assert state != nil
  end
end
