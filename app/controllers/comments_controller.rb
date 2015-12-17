class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action only: [:edit, :update, :destroy] do
    @comment = Comment.find params[:id]
    correct_user @comment.user
  end

  def create
    type = params[:type]
    @item = type.camelize.constantize.find(params["#{type.downcase}_id"])
    @comment = @item.comments.new(comment_params.merge(user_id: current_user.id, comment_to: type))
    if @comment.save
      flash[:success] = '评论成功！'
      create_comment_notification @comment
      #create_followers_notification @comment
      redirect_item @item
    else
      flash[:danger] = '评论不可为空'
      redirect_item @item
    end
  end

  def edit
    @comment = Comment.find params[:id]
  end

  def update
    @comment= Comment.find(params[:id])
    if @comment.update_attributes(comment_params)
      flash[:success] = '评论修改成功'
      case @comment.comment_to
      when "Topic"
        redirect_to topic_path @comment.topic
      when "Answer"
        redirect_to question_path @comment.answer.question
      end
    else
      render 'edit'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:success] = '评论删除成功'
    redirect_to :back
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end

  def redirect_item item
    if item.class == Answer
      redirect_to item.question
    else
      redirect_to item
    end
  end
end
