class ProjectsController < ApplicationController
  load_and_authorize_resource
  # before_action :require_manager, only: [ :new, :create, :destroy ]
  def index
    if current_user.manager?
      @pagy, @projects = pagy(current_user.managed_projects)

    elsif current_user.qa?
      @pagy, @projects = pagy(current_user.projects)
    elsif current_user.developer?
      @pagy, @projects = pagy(Project.joins(:bugs).where(bugs: { assigned_to_id: current_user.id }).distinct)
      @bugs = Bug.where(assigned_to: current_user)
    else
      redirect_to root_path, alert: "Access denied."
    end
  end

  def show
    @project
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
