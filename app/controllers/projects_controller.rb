class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :change_status]
  before_action :authorize_admin!, only: [:edit, :update, :destroy, :change_status]

  def index
    @projects = Project.all.order(created_at: :asc) # Ensure projects are ordered for consistency
  end

  def show
    @project = Project.find(params[:id])
    @comments = @project.comments.order(created_at: :asc).page(params[:page]).per(10)
    if params[:page].blank?
      @comments = @project.comments.order(:created_at).page(@comments.total_pages).per(10)
    end

    respond_to do |format|
      format.html # renders show.html.erb
      format.turbo_stream # renders turbo stream response, if needed
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      @projects = Project.all.order(created_at: :asc) # Make sure to fetch all projects

      respond_to do |format|
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.turbo_stream # This will render create.turbo_stream.erb
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_project_form', partial: 'form', locals: { project: @project }) }
      end
    end
  end
  def edit
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('projects_list', partial: 'projects/show', locals: { project: @project }) }
      format.html # Fallback for non-Turbo requests
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path, notice: 'Project was successfully deleted.' }
      format.turbo_stream
    end
  end

  def change_status
    @project.status = params[:status]
    if @project.save
      StatusChange.create!(project: @project, user: current_user, status: @project.status, changed_at: Time.current)
      @project.comments.create!(
        content: "Project status changed to #{@project.status&.humanize} by #{current_user.email}",
        user: current_user
      )

      respond_to do |format|
        format.html { redirect_to @project, notice: 'Project status was successfully changed.' }
        format.turbo_stream # Add this to handle Turbo Stream responses
      end
    else
      respond_to do |format|
        format.html { redirect_to @project, alert: 'Unable to change project status.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('status_errors', partial: 'shared/errors', locals: { errors: @project.errors }) }
      end
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
