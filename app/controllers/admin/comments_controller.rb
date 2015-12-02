class Admin::CommentsController < Admin::AdminController
  def edit
    @comment= Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(comment_params)
      flash[:success] = '评论修改成功'
      case @comment.comment_to
      when "Topic"
        redirect_to admin_topic_show_comments_path(@comment.topic)
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

end
