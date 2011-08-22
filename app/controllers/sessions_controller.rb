class SessionsController < Devise::SessionsController

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in_and_redirect(resource_name, resource)
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource)
    render :json => { :success => true, :redirect  => stored_location_for(scope) || after_sign_in_path_for(resource) }
  end

  # JSON login failure message
  def failure
    render :json => {:success => false, :errors => {:reason => "Login failed. Try again"}}, :status => 401
  end

end