class CommentsController < ApplicationController
  def index

  end

  def create
    type = params[:type]
    @item = type.camelize.constantize.find(params["#{type.downcase}_id"])
    @comment = @item.comments.new(comment_params.merge(user_id: current_user.id, comment_to: type))
    if @comment.save
      flash[:success] = '评论成功！'
      redirect_item @item
    else
      flash[:danger] = '评论不可为空'
      redirect_item @item
    end
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
