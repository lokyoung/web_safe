class Admin::TopicsController < Admin::AdminController
  def index
    @topics = Topic.page params[:page]
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      flash[:success] = '话题修改成功'
      redirect_to admin_topics_url
    else
      render 'edit'
    end
  end

  def destroy
    Topic.find(params[:id]).destroy
    flash[:success] = '话题删除成功'
    redirect_to admin_topics_url
  end

  def show_comments
    @topic = Topic.find(params[:id])
    @comments = @topic.comments.page params[:page]
    render 'admin/comments/show_comments'
  end

  private
  def topic_params
    params.require(:topic).permit(:title, :content)
  end
end
