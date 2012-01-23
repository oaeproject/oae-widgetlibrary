class RegistrationsController < Devise::RegistrationsController

  # override the Devise::RegistrationsController#create method completely
  # extended for recaptcha and xhr handling
  def create
    build_resource
    recaptcha_valid = verify_recaptcha
    if resource.valid? && recaptcha_valid
      if resource.save
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_in(resource_name, resource)
          @url = after_sign_in_path_for(resource)

          respond_to do |format|
            format.js { render 'users/registrations/create' }
          end

        else
          set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
          expire_session_data_after_sign_in!
          @url = after_inactive_sign_up_path_for(resource)

          respond_to do |format|
            format.js { render 'users/registrations/create' }
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
    @resource = resource
    if !recaptcha_valid then
      @resource.errors[:recaptcha] = "invalid response"
    end
    # respond with json if xhr
    respond_to do |format|
      format.js { render 'users/registrations/error' }
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

  # Overwrite the Devise::RegistrationsController#update method
  # extended for xhr handling
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated if is_navigational_format?
      sign_in resource_name, resource, :bypass => true
      @url = after_sign_in_path_for(resource)

      respond_to do |format|
        format.js { render 'users/registrations/create' }
      end
    else
      error(resource, true)
    end
  end

end
