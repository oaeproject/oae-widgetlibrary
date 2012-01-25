require 'test_helper'

class StateTest < ActiveSupport::TestCase
  # These should all be defined in db/seeds.rb
  test "all states should exist" do
    assert_not_nil State.accepted, "State.accepted exists"
    assert_not_nil State.pending, "State.pending exists"
    assert_not_nil State.declined, "State.declined exists"
    assert_not_nil State.superseded, "State.superseded exists"
  end
end
