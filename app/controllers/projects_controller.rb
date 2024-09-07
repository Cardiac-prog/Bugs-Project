class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def show
    find_project
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project
    else
      render :new, status: :unprocessable_entity  
    end
  end

  def edit
    find_project
  end

  def update
    find_project

    if @project.update(project_params)
      redirect_to @project
    else
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
      params.require(:project).permit(:title, :description, :start_date, :end_date)
    end

    def find_project
      @project = Project.find(params[:id])
    end
end
