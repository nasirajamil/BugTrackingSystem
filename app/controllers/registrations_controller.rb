class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
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
