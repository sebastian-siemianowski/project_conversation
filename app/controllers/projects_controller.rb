class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :change_status]

  def index
    @projects = Project.all
  end

  def show
    @comments = @project.comments
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted.'
  end

  def change_status
    @project.status = params[:status]
    if @project.save
      StatusChange.create!(project: @project, user: current_user, status: @project.status, changed_at: Time.current)
      redirect_to @project, notice: 'Project status was successfully changed.'
    else
      redirect_to @project, alert: 'Unable to change project status.'
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :status)
  end
end
