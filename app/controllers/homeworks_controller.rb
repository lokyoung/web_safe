class HomeworksController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_admin_user, only: [:new, :create, :edit, :update, :destroy]
  before_action only: [:edit, :update, :destroy] do
    @homework = Homework.find params[:id]
    correct_user @homework.user
  end

  def index
    @homeworks = Homework.page params[:page]
  end

  def new
    @homework = Homework.new
  end

  def create
    @homework = current_user.homeworks.new(homework_params)
    if @homework.save
      # 设置作业和班级之间的关联
      stuclass_ids = params[:homework][:stuclass_ids]
      @homework.stuclass_ids = stuclass_ids

      # 给班级的同学发通知
      @homework.stuclasses.includes(:students).each do |stuclass|
        stuclass.students.each do |student|
          # 向当前班级的同学发出通知
          Notification.create(user_id: student.id, title: "您有新的作业需要完成", content: "<a href=#{homework_url(@homework)}>#{@homework.title}</a>", unread: true)
          # 通过ActionCable发送notice
          send_notice student
        end
      end

      flash[:success] = '布置作业成功'
      redirect_to homeworks_url
    else
      render 'new'
    end
  end

  def show
    @homework = Homework.find(params[:id])
  end

  def destroy
    homework = Homework.find(params[:id])
    file_delete homework.homeworkfile
    homework.destroy
    flash[:success] = '作业删除成功'
    redirect_to homeworks_url
  end

  def edit
    @homework = Homework.find params[:id]
  end

  def update
    @homework = Homework.find params[:id]
    if @homework.update_attributes homework_params
      # 建立作业和班级的关系
      stuclass_ids = params[:homework][:stuclass_ids]
      @homework.stuclass_ids = stuclass_ids

      flash[:success] = '作业资料修改成功'
      redirect_to @homework
    else
      render 'edit'
    end
  end

  private
  def homework_params
    params.require(:homework).permit(:title, :description, :homeworkfile)
  end
end
