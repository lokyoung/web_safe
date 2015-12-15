class StuhomeworksController < ApplicationController
  before_action :logged_in_user
  before_action :ischecked, only: [:edit, :update]
  before_action only: [:check, :check_complete] do
    if !teacher_admin?
      flash[:warning] = '权限不够，无法操作'
      redirect_to root_url
    end
  end
  before_action only: [:create] do
    @homework = Homework.find(params[:homework_id])
    notcreated? @homework
  end
  before_action only: [:edit, :update] do
    @stuhomework = Stuhomework.find params[:id]
    correct_user @stuhomework.user
  end

  def index
    @stuhomeworks = Stuhomework.page params[:page]
  end

  def create
    @homework = Homework.find(params[:homework_id])
    @stuhomework = @homework.stuhomeworks.new(stuhomework_params.merge(user_id: current_user.id))
    if @stuhomework.save
      # success
      flash[:success] = '提交作业成功'
      redirect_to @homework
    else
      flash[:warning] = '提交失败'
      redirect_to @homework
    end
  end

  def edit
    @stuhomework = Stuhomework.find(params[:id])
  end

  def update
    @stuhomework = Stuhomework.find(params[:id])
    if @stuhomework.update_attributes(stuhomework_params)
      flash[:success] = '作业修改成功'
      @homework = @stuhomework.homework
      redirect_to @homework
    else
      render 'edit'
    end
  end

  def destroy
    @stuhomework = Stuhomework.find(params[:id])
    @homework = @stuhomework.homework
    @stuhomework.destroy
    flash[:success] = '作业已删除'
    redirect_to @homework
  end

  def check
    @stuhomework = Stuhomework.find(params[:id])
  end

  def check_complete
    @stuhomework = Stuhomework.find(params[:id])
    if @stuhomework.update_attributes(checked_params.merge(ischecked: true))
      flash[:success] = '作业批改成功'
      redirect_to @stuhomework.homework
    else
      render 'check'
    end
  end

  private
  def stuhomework_params
    params.require(:stuhomework).permit(:stuhomeworkfile)
  end

  def checked_params
    params.require(:stuhomework).permit(:mark, :remark)
  end

  def ischecked
    @stuhomework = Stuhomework.find params[:id]
    if @stuhomework.ischecked?
      @homework = @stuhomework.homework
      flash[:danger] = '已经批改过，无法进行修改'
      redirect_to @homework
    end
  end

end
