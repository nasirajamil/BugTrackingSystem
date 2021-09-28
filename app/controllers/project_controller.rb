class ProjectController < ApplicationController
  before_action :authenticate_user!, :set_user
  def index
    @projects = Project.all
    authorize @projects
  end

  def show
    @project = Project.find(params[:id])
    @owners = @project.users
    @developers = User.developers
    @QAs = User.QAs
    @bugs = @project.bugs.newly.or(@project.bugs.started)
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      @user.projects << @project
      flash[:notice] = "New project successfully created!"
      redirect_to project_index_path
    else
      flash.now[:error] = "New project failed to be created."
      render :new
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project
    @project.destroy
    redirect_to project_index_path
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to project_index_path
    else
      render 'edit'
    end
  end

  def menu
    @projects = Project.all
  end

  def developer_menu
    @projects=@user.projects
  end
  
  def change_status
    @project = Project.find(params[:project_id])
    @bug = Bug.find(params[:bug_id])
    @new_status=params[:status]
    if @bug.update_attribute(:status, @new_status)
      redirect_to project_path(@project)
    else
      render 'edit'
    end
  end
  
  def assign_bug
    @project = Project.find(params[:project_id])
    @bug = Bug.find(params[:bug_id])
    @user.bugs << @bug
    redirect_to project_path(@project)
  end

  def add_user_to_project
    @project = Project.find(params[:id])
    authorize @project
    @user_id = params[:user_roles]
    @assigned_user = User.where(id: @user_id)
    @project.users << @assigned_user
    redirect_to project_path(@project)
  end

  def remove_user_from_project
    @project_user = UserProject.where(user_id: params[:Uid],project_id:params[:Pid])
    @project_user.destroy(@project_user.ids)
    redirect_to project_path(params[:Pid])
  end

  private

  def project_params
    params.require(:project).permit(:name, :desc, :start_date, :end_date)
  end

  def set_user
    @user=current_user
  end
end
