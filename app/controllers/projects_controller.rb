class ProjectsController < ApplicationController
  def index
    @projects = Project.where(manager: current_user)      # Only show projects created by the current manager
  end

  def show
    find_project
  end

  def new
    @project = Project.new
    # @qas = User.where(role: :qa)
  end

  def create
    @project = Project.new(project_params)
    @project.manager = current_user               # assigning the current user id to manager column so that the project table will have the manager id for that specific project created by that specific manager

    if @project.save
      redirect_to @project
    else
      #   @qas = User.where(role: :qa)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    find_project
    # @qas = User.where(role: :qa)
  end

  def update
    find_project

    if @project.update(project_params)
      redirect_to @project
    else
      #  @qas = User.where(role: :qa)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    find_project
    @project.destroy
    redirect_to root_path, status: :see_other
  end

  private
    def project_params
      params.require(:project).permit(:title, :description, :start_date, :end_date, qa_ids: [])
    end

    def find_project
      @project = Project.find(params[:id])
    end
end
