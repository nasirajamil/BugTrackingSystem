class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    not @user.developer?
  end

  def destroy?
    not @user.qa?
  end

  def new?
    not @user.qa?
  end

  def edit?
    not @user.qa?
  end

  def add_user_to_project?
    not @user.developer?
  end

end
