class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.role=="2" || @user.role=="3"
  end

  def destroy?
    @user.role=="1" || @user.role=="2"
  end

  def new?
    @user.role=="1" || @user.role=="2"
  end

  def edit?
    @user.role=="1" || @user.role=="2"
  end

  def add_user_to_project?
    @user.role=="2" || @user.role=="3"
  end

end
