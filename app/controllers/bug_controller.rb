class BugController < ApplicationController
  before_action :set_project, :set_user
  
  def new
    @bug = Bug.new
    authorize @bug
    @id = params[:project_id]
  end

  def create
    @bug = @project.bugs.create(bug_params)
    if @bug.save
      @user.bugs << @bug
      flash.now[:notice] = "New bug successfully created!"
      redirect_to project_path(@project)
    else
      flash.now[:error] = "New bug failed to be created."
      render :new
    end
  end

  def show
    @bug = Bug.find(params[:id])
  end

  def destroy
    @bug = @project.bugs.find(params[:id])
    @bug.destroy
    redirect_to project_path(@project)
  end
  
  private

  def bug_params
    params.require(:bug).permit(:title, :deadline, :bugtype, :status, :avatar)
  end
  
  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_user
    @user=current_user
  end

end
