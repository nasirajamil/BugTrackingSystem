class BugController < ApplicationController
  before_action :set_project
  
  def new
    @bug = Bug.new
    authorize @bug
    @user = current_user
    @id = params[:project_id]
  end

  def create
    @bug = @project.bugs.create(bug_params)
    @user = current_user
    if @bug.save
      @user.bugs << @bug
      flash.now[:notice] = "New bug successfully created!"
      redirect_to project_path(@project)
    else
      flash.now[:error] = "New bug failed to be created."
      render :new
    end
  end
  
  private

  def bug_params
    params.require(:bug).permit(:title, :deadline, :bugtype, :status)
  end
  
  def set_project
    @project = Project.find(params[:project_id])
  end

end
