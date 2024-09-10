class BugsController < ApplicationController
  def show
    find_project
    find_bug
  end
  def new
    find_project
    @bug = @project.bugs.new
    @developers = User.where(role: :developer)   # fetch only developer while creating project
  end
  def create
    find_project
    @bug = @project.bugs.new(bug_params)
    @bug.reported_by = current_user
    @bug.assigned_to = User.find(params[:bug][:assigned_to_id]) if params[:bug][:assigned_to_id].present?


    if @bug.save
      redirect_to @project, notice: "Bug was successfully reported."
    else
      puts @bug.errors.full_messages
      @developers = User.where(role: :developer)   # Re-fetch only developer while creating project
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    find_project
    find_bug
    @developers = User.where(role: :developer)   # fetch only developer while creating project
  end

  def update
    find_project
    find_bug
    if @bug.update(bug_params)
      redirect_to project_bug_path(@project, @bug), notice: "Bug was successfully updated."
    else
      @developers = User.where(role: :developer)   # fetch only developer while creating project
      puts @bug.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    find_project
    find_bug
    @bug.destroy
    redirect_to @project, notice: "Bug was successfully deleted."
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_bug
    @bug = @project.bugs.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :category, :priority, :project_id, :assigned_to_id, :reported_by_id)
  end
end
