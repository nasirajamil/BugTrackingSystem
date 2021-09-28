class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :configure_account_update_params, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :email, :password, :password_confirmation])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :email, :password, :password_confirmation])
  end

  def after_sign_in_path_for(resource)
    if current_user.developer?
      developer_menu_path
    elsif current_user.qa?
      menu_path
    else
      project_index_path
    end
  end

  private

  def user_not_authorized
    flash[:notice] = "You are not authorized to perform this action."
    redirect_to(request.referrer || home_error_page_path)
  end
end
