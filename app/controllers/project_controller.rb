class ProjectController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects=Project.all
    @user = current_user
  end

  def show

  end

  def new
    @project=Project.new
    @user = current_user
  end

  def create
    @project = Project.new(project_params)
    @user = current_user
    #@current_user.projects << @project
    if @project.save
      flash[:notice] = "New project successfully created!"
      redirect_to project_index_path
    else
      flash.now[:error] = "New project failed to be created."
      render :new
    end
  end

  def destroy

  end

  def edit

  end

  def update

  end

  def menu

  end

  private

  def project_params
    params.require(:project).permit(:name, :desc, :start_date, :end_date, user_ids: [])
  end


end
