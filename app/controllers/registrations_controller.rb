class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    if current_user.role=="2"
      puts current_user.role
      puts "i am manager"
      project_index_path
    elsif current_user.role=="3"
      puts current_user.role
      puts "i am QA or developer"
      menu_path
    else
      developer_menu_path
    end
  end

  def after_update_path_for(resource)

    @myparams=params.require(:user)
    if @myparams[:role]=="2"
      puts @myparams[:role]
      puts "i am manager in update"
      project_index_path
    elsif @myparams[:role]=="3"
      puts @myparams[:role]
      puts "i am QA or developer in update"
      menu_path
    else
      developer_menu_path
    end
  end


end
