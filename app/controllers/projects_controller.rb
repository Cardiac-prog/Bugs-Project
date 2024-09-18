class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    if can?(:manage, Project)
      @projects = current_user.managed_projects             # accessbile built in cancan
      if params[:query].present?                                     # If user has entered text in search box then  projects will be filtered using sql LIKE
        @projects = @projects.where("title LIKE ?", "%#{params[:query]}%")
      else
        @projects = current_user.managed_projects                # otherwise all projects related to manager are displayed
      end

      @pagy, @projects = pagy(@projects)                # After filtering the pagy gem is applied for pagination

      respond_to do |format|
        format.html # For normal page load
      format.json do
        render json: { projects: @projects.map { |project| { title: project.title, url: project_path(project) } } }   # used to display live search results in dropdown when JS fetch request is made
        # <%# this will map all the projects to create names and urls for creating links using JavaScript..  %>
      end
      end
    elsif can?(:manage, Bug) && can?(:read, Project)     # if current_user.qa?
      redirect_to bugs_path
    elsif can?(:read, Bug) && can?(:update, Bug)        # if current_user.developer?
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
