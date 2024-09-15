class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    if can?(:manage, Project)
      @pagy, @projects = pagy(current_user.managed_projects)
    elsif can?(:manage, Bug) && can?(:read, Project)
      redirect_to bugs_path
    elsif can?(:read, Bug) && can?(:update, Bug)
      redirect_to bugs_path
    end
  end

  def show
    @project = Project.find(params[:id])
    @qas = @project.qas
    @pagy, @bugs = pagy(@project.bugs.where(reported_by: current_user))
  end

  def new
    @project = Project.new
    @qas = User.where(role: :qa)           # all the QAs will be included in the dropdown menu while creating project
  end

  def create
    @project = Project.new(project_params)
    @project.manager = current_user               # assigning the current user id to manager column so that the project table will have the manager id for that specific project created by that specific manager

    if @project.save
      redirect_to @project
    else
      @qas = User.where(role: :qa)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @qas = User.where(role: :qa)
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      @qas = User.where(role: :qa)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to root_path, status: :see_other
  end

  private
    def project_params
      params.require(:project).permit(:title, :description, :start_date, :end_date, qa_ids: [])
    end
end
