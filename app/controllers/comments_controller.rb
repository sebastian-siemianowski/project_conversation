# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create
    @comment = @project.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @project, notice: 'Comment was successfully added.' }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to @project, alert: 'Failed to add comment.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: 'comments/form', locals: { comment: @comment }) }
      end
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
