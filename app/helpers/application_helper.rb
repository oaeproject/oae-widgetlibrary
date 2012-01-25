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

  $paperclip_validations = ['_content_type', '_file_size']

  def translate_errors(record)
    ret = {}
    record.errors.each do |key, message|
      keystring = key.to_s

      # check for any paperclip validations
      paperclip_validation = "_" + keystring.split("_")[1..-1].join("_")
      if $paperclip_validations.include? paperclip_validation
        keystring.gsub!(paperclip_validation, '')
        key = keystring.to_sym
      end
      # Happens when you try to submit an invalid file (e.g. zip) as a screenshot
      if keystring.include? '.'
        keystring.gsub!('.', '_')
        key = keystring.to_sym
        message = message.split(".")[0]
      end

      ret[key] = {
        :title => record.class.human_attribute_name(key),
        :message => message
      }
    end
    ret
  end

end
