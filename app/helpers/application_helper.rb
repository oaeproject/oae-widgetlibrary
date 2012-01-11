# encoding: utf-8

module ApplicationHelper
  def show_login
    controller = params[:controller].gsub("/", "_")
    !((controller.eql?("devise_registrations") || controller.eql?("registrations")) && !params[:action].eql?("edit"))
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
    ret.to_i * 2
  end

  def get_stars(rating)
    rating.to_i / 20
  end

  def page_js
    controller = params[:controller].gsub("devise\/", "")
    javascript_include_tag controller if SakaiWidgetlibrary::Application.assets.find_asset("#{controller}.js")
  end

  def page_css
    controller = params[:controller].gsub("devise\/", "")
    stylesheet_link_tag controller if SakaiWidgetlibrary::Application.assets.find_asset("#{controller}.css")
  end

end
