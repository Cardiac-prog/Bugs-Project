class BugsController < ApplicationController
  load_and_authorize_resource
  before_action :set_project, only: %i[new create edit update destroy]
  def index
    if can?(:manage, Bug) && can?(:read, Project) # QA role
      @projects = current_user.projects
      @pagy, @projects = pagy(@projects)
      render "projects/index"

    elsif can?(:read, Bug) && can?(:update, Bug) # Developer role
      @pagy, @bugs = pagy(Bug.where(assigned_to: current_user))
      @bugs = @bugs.where("title LIKE ?", "%#{params[:query]}%") if params[:query].present?

      respond_to do |format|
        format.html { render :index } # Full page render
        format.json do
          render json: @bugs.map { |bug| { title: bug.title, url: project_bug_path(bug.project, bug) } }
        end
      end
    end
  end


  def show
    @bug
  end
  def new
    @bug = @project.bugs.new
    @developers = User.where(role: :developer)   # fetch only developer while creating project
  end
  def create
    @bug = @project.bugs.new(bug_params)
    @bug.reported_by = current_user

    if @bug.save
      redirect_to @project, notice: "Bug was successfully reported."
    else
      @developers = User.where(role: :developer)   # Re-fetch only developer while creating project
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @developers = User.where(role: :developer)   # fetch only developer while creating project
  end

  def update
    if @bug.update(bug_params)
      redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully updated."
    else
      @developers = User.where(role: :developer)   # fetch only developer while creating project
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bug.destroy
    redirect_to @project, notice: "Bug was successfully deleted."
  end

  private

  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id].present?
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :category, :priority, :project_id, :assigned_to_id, :reported_by_id)
  end
end
