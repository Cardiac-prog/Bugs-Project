class BugsController < ApplicationController
  load_and_authorize_resource
    before_action :find_project
  # before_action :find_bug, only: [ :edit, :update, :destroy ]
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
    # @bug.assigned_to = User.find(params[:bug][:assigned_to_id]) if params[:bug][:assigned_to_id].present?
    # it first check the params if there is an id given, then it uses that id and finds the user in database, if user is present than it assigns the user to assigned_to column

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

  def find_project
    @project = Project.find(params[:project_id])
  end

  # def find_bug
  #   @bug = @project.bugs.find(params[:id])
  # end

  def bug_params
    params.require(:bug).permit(:title, :description, :category, :priority, :project_id, :assigned_to_id, :reported_by_id)
  end
end
