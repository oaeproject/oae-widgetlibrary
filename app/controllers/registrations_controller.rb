class RegistrationsController < Devise::RegistrationsController

  # override the Devise::RegistrationsController create method completely
  # extended for recaptcha and xhr handling
  def create
    build_resource
    recaptcha_valid = verify_recaptcha
    if resource.valid? && recaptcha_valid
      resource.name = "#{resource.first_name} #{resource.last_name}"
      if resource.save
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_in(resource_name, resource)
          if request.xhr?
            render :json => {"success" => true, "url" => redirect_location(resource_name, resource)}
          else
            respond_with resource, :location => redirect_location(resource_name, resource)
          end
        else
          set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
          expire_session_data_after_sign_in!
          if request.xhr?
            render :json => {"success" => true, "url" => after_inactive_sign_up_path_for(resource)}
          else
            respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          end
        end
      else
        error(resource, recaptcha_valid)
      end
    else
      error(resource, recaptcha_valid)
    end
  end

  def error(resource, recaptcha_valid)
    clean_up_passwords(resource)
    # determine the errors
    errors = {}
    if resource.errors
      errors = resource.errors.messages
    end
    if !recaptcha_valid then
      errors[:recaptcha] = ["invalid response"]
    end
    # respond with json if xhr
    if request.xhr?
      render :json => {"success" => false, "errors" => errors}
    else
      render_with_scope :new
    end
  end

  # GET /register/check_username/:username
  # check for the availability of a username
  # Only handles AJAX requests
  def check_username
    user = User.where(:username => params[:username]).first
    text = "is not available"
    if (user.nil?)
      user = false
      text = "is available"
    else
      user = true
    end
    render :json => {"user_found" => user, "text" => text}
  end

end
