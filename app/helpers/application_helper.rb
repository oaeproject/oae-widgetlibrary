# encoding: utf-8

module ApplicationHelper
  def show_login
    !(params[:controller].gsub("/", "_").eql?("devise_registrations") || params[:controller].gsub("/", "_").eql?("registrations"))
  end

  def custom_ago(date)
    date.strftime("%e %B")
  end

  def round_to_fraction(number, fraction = 0.5)
    multiplier = 1.0 / fraction
    (multiplier*number).round / multiplier
  end

  def get_rating(stars)
    ret = round_to_fraction(stars).to_s.delete(".")
    if ret.eql? "00"
      ret = 0
    end
    ret
  end

end
