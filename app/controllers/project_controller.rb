class ProjectController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all
    authorize @projects
    @user = current_user
  end

  def show
    @project = Project.find(params[:id])
    @user = current_user
    @owners = @project.users
    @developers = User.where(role: '1')
    @QAs = User.where(role: '3')
    @new_bugs = @project.bugs.where(status:"new")
    @started_bugs = @project.bugs.where(status:"started")
    @completed_bugs = @project.bugs.where(status:"completed")
    @bugs = @project.bugs.where(status:"new").or(@project.bugs.where(status:"started"))
  end

  def new
    @project = Project.new
    authorize @project
    @user = current_user
  end

  def create
    @project = Project.new(project_params)
    @user = current_user
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
    puts @project
    @project.destroy
    redirect_to project_index_path
  end

  def edit
    @user = current_user
    @project = Project.find(params[:id])
    authorize @project
  end

  def update
    @user = current_user
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to project_index_path
    else
      render 'edit'
    end

  end

  def menu
    @user = current_user
    @projects = Project.all
  end

  def developer_menu
    @user=current_user
    @projects=Project.all
  end
  
  def change_status
    @project = Project.find(params[:project_id])
    @bug = Bug.find(params[:bug_id])
    @newStatus=params[:status]
    if @bug.update_attribute(:status, @newStatus)
      redirect_to project_path(@project)
    else
      render 'edit'
    end
  end
  
  def assign_bug
    @user = current_user
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
    @user = current_user
    @project.users << @assigned_user
    redirect_to project_path(@project)
  end

  def remove_user_from_project
    @Puser = UserProject.where(user_id: params[:Uid],project_id:params[:Pid])
    @Puser.destroy(@Puser.ids)
    redirect_to project_path(params[:Pid])
  end

  private

  def project_params
    params.require(:project).permit(:name, :desc, :start_date, :end_date)
  end
end
