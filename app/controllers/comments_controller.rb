# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize_comment_owner_or_admin!, only: [:edit, :update, :destroy]

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
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('comment_form', partial: 'comments/form',
                                                                    locals: { comment: @comment })
        end
      end
    end
  end

  def edit
    # `@comment` is already set by `set_comment`
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to @project, notice: 'Comment was successfully updated.' }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("comment_#{@comment.id}", partial: 'comments/comment', locals: { comment: @comment })
        end
      end
    end
  end

  def destroy
    @project = @comment.project
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @project, notice: 'Comment was successfully deleted.' }
      format.turbo_stream
    end
  end


  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_comment
    @comment = @project.comments.find(params[:id])
  end

  def authorize_comment_owner_or_admin!
    unless current_user == @comment.user || current_user.admin?
      redirect_to @project, alert: 'You are not authorized to perform this action.'
    end
  end
end
