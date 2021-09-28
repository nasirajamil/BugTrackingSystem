class RegistrationsController < Devise::RegistrationsController
  
  def after_sign_up_path_for(resource)
    if current_user.developer?
      developer_menu_path
    elsif current_user.qa?
      menu_path
    else
      project_index_path
    end
  end

  def after_update_path_for(resource)
    @myparams=params.require(:user)
    if @myparams[:role]=="manager"
      project_index_path
    elsif @myparams[:role]=="qa"
      menu_path
    else
      developer_menu_path
    end
  end
end
