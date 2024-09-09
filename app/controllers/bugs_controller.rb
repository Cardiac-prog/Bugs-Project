class BugsController < ApplicationController
  def show
    find_project
    @bug = @project.bugs.find(params[:id])
  end
  def new
    find_project
    @bug = @project.bugs.new
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
      render :new, status: :unprocessable_entity
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :category, :priority, :project_id, :assigned_to_id, :reported_by_id)
  end
end
