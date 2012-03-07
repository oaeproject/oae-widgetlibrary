class SdkController < ApplicationController
  def index
    render :layout => 'application'
  end
  def sdk_section
    render params[:section].split('/').last, :layout => request.xhr? ? 'sdkxhr' : 'lhnavigation'
  end
end
