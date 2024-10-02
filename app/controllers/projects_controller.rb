class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :change_status]
  before_action :authorize_admin!, only: [:edit, :update, :destroy, :change_status]

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    @comments = @project.comments.order(created_at: :asc).page(params[:page]).per(10)
    if params[:page].blank?
      @comments = @project.comments.order(:created_at).page(@comments.total_pages).per(10)
    end

    respond_to do |format|
      format.html # renders show.html.erb
      format.turbo_stream # renders the turbo frame response
    end
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
      @project.comments.create!(
        content: "Project status changed to #{@project.status&.humanize} by #{current_user.email}",
        user: current_user
      )
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

  def authorize_admin!
    redirect_to projects_path, alert: 'You are not authorized to perform this action.' unless current_user.admin?
  end
end
