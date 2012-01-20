class PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication
  include Devise::Controllers::InternalHelpers

  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])
    if successfully_sent?(resource)
      @url = after_sending_reset_password_instructions_path_for(resource_name)
      respond_to do |format|
        format.js { render 'users/passwords/success' }
      end
    else
      @resource = resource
      respond_to do |format|
        format.js { render 'users/passwords/error' }
      end
    end
  end

  def update
    # Since the login box already has a user_password id, we're using password_label instead
    # We do need to remap it to :password since that is what devise uses
    params[resource_name][:password] = params[resource_name][:password_label]

    self.resource = resource_class.reset_password_by_token(params[resource_name])

    if resource.errors.empty?
      sign_in(resource_name, resource)
      @url = after_sign_in_path_for(resource)
      respond_to do |format|
        format.js { render 'users/passwords/success' }
      end
    else
      @resource = resource
      respond_to do |format|
        format.js { render 'users/passwords/error' }
      end
    end
  end

end