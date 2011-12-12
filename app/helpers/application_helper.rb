# encoding: utf-8

module ApplicationHelper
  def show_login
    !(params[:controller].gsub("/", "_").eql?("devise_registrations") || params[:controller].gsub("/", "_").eql?("registrations"))
  end
end
