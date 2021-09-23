class BugPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    @user.role=="2" || @user.role=="3"
  end
  
end
