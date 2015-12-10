class TopicsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action only: [:edit, :update, :destroy] do
    @topic = Topic.find params[:id]
    correct_user @topic.user
  end

  def index
    # 根据分页显示问题
    @topics= Topic.page params[:page]
  end

  def new
    @topic= Topic.new
  end

  def create
    @topic = current_user.topics.new(topic_params)
    if @topic.save
      flash[:success] = '发布话题成功'
      redirect_to topics_url
    else
      render 'new'
    end
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def destroy
    Topic.find(params[:id]).destroy
    flash[:success] = '话题删除成功'
    redirect_to topics_url
  end

  def edit
    @topic= Topic.find(params[:id])
  end

  def update
    @topic= Topic.find(params[:id])
    if @topic.update_attributes(update_params)
      flash[:success] = '修改话题成功'
      redirect_to @topic
    else
      render 'edit'
    end
  end

  private
  def topic_params
    params.require(:topic).permit(:title, :content)
  end

  def update_params
    params.require(:topic).permit(:title, :content)
  end

end
