class AnnouncesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :new, :edit, :update, :show]
  before_action :teacher_admin_user, only: [:new, :create, :destroy, :edit, :update]
  before_action only: [:edit, :update, :destroy] do
    @announce = Announce.find params[:id]
    correct_user @announce.user
  end

  def index
    @announces = Announce.page params[:page]
  end

  def new
    @announce = Announce.new
  end

  def create
    @announce = current_user.announces.new(announce_params)
    if @announce.save
      flash[:success] = '发布公告成功！'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    Announce.find(params[:id]).destroy
    flash[:success] = '公告删除成功！'
    redirect_to announces_url
  end

  def show
    @announce = Announce.find(params[:id])
  end

  def edit
    @announce = Announce.find(params[:id])
  end

  def update
    @announce = Announce.find(params[:id])
    if @announce.update_attributes(announce_params)
      flash[:success] = '公告修改成功！'
      redirect_to @announce
    else
      render 'edit'
    end
  end

  private

  def announce_params
    params.require(:announce).permit(:title, :content)
  end
end
