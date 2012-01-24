# encoding: utf-8

module WidgetHelper

  def review_description(review)
    output = h truncate(review.review, :length => 250, :separator => ' ', :omission => ' ')
    output += button_tag("read more", :type => 'button', :class => 'review_read_more wl-link-button') if review.review.size > 250
    output.html_safe
  end

end
