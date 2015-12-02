class StuhomeworksController < ApplicationController
  before_action :logged_in_user

  def index
    @stuhomeworks = Stuhomework.page params[:page]
  end

  def new
    @stuhomework = Stuhomework.new
  end

  def show
  end

  def create
    @homework = Homework.find(params[:homework_id])
    @stuhomework = @homework.stuhomeworks.new(stuhomework_params.merge(user_id: current_user.id))
    if @stuhomework.save
      # success
      flash[:success] = '提交作业成功'
      redirect_to @homework
    else
      redirect_to @homework
    end
  end

  def edit
    @homework = Homework.find(params[:homework_id])
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

  def check
    @homework = Homework.find(params[:homework_id])
    @stuhomework = Stuhomework.find(params[:id])
  end

  def check_complete
    @stuhomework = Stuhomework.find(params[:id])
    if @stuhomework.update_attributes(checked_params)
      flash[:success] = '作业修改成功'
      @stuhomework.ischecked = true
      @homework = @stuhomework.homework
      redirect_to @homework
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
end
