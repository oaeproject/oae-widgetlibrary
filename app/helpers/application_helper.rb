# encoding: utf-8

module ApplicationHelper
  def show_login
    !(params[:controller].gsub("/", "_").eql?("devise_registrations") || params[:controller].gsub("/", "_").eql?("registrations"))
  end

  def urlize(str)
    str.downcase.gsub(" ", "-").html_safe
  end

  def custom_ago(date)
    date.strftime("%e %B")
  end

  def round_to_fraction(number, fraction = 0.5)
    multiplier = 1.0 / fraction
    (multiplier*number).round / multiplier
  end

  def get_rating(stars)
    round_to_fraction(stars).to_s.delete(".")
  end

end
