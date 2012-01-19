require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  test "rating should not save without it's required attributes" do
    rating = Rating.new
    assert !rating.save, "Saved the rating without any required attributes"
    rating.stars = 4
    assert !rating.save, "Saved the rating without the review"
    rating.review = "So awesome"
    assert rating.save, "Rating successfully saves after stars and review are present"
  end
end
