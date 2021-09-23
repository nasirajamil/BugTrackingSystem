class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :configure_account_update_params, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :email, :password, :password_confirmation])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :email, :password, :password_confirmation])
  end

  def after_sign_in_path_for(resource)
    if current_user.role == "2"
      project_index_path
    elsif current_user.role == "3"
      menu_path
    else
      developer_menu_path
    end
  end  

end
