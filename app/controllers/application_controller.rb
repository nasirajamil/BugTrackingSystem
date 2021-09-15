class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :configure_account_update_params, if: :devise_controller?
  #before_action after_sign_up_path_for(@user), if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :email, :password, :password_confirmation])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :email, :password, :password_confirmation])
  end

  def after_sign_in_path_for(resource)
    if current_user.role=="2"
      puts current_user.role
      puts "i am manager"
      project_index_path
    else
      puts current_user.role
      puts "i am QA or developer"
      menu_path
    end
  end

end
