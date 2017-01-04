class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_token_valid_user

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:account_name])
  end

  def set_token_valid_user
    if (not current_user.nil?) && (not Usertoken.where(user_id: current_user[:id]).empty?) then
      @is_token_valid_user = true
    else
      @is_token_valid_user = false
    end
  end
end
