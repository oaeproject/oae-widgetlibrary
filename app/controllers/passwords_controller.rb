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
      @errors = resource.errors
      respond_to do |format|
        format.js { render 'users/passwords/error' }
      end
    end
  end
end