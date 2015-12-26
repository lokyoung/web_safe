class ExperimentsController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_admin_user, only: [:new, :create, :edit, :update, :destroy]
  before_action only: [:edit, :update, :destroy] do
    @experiment = Experiment.find params[:id]
    correct_user @experiment.user
  end

  def index
    @experiments = Experiment.page params[:page]
  end

  def new
    @experiment = Experiment.new
  end

  def create
    @experiment = current_user.experiments.new(experiment_params)
    if @experiment.save
      # 设置作业和班级之间的关联
      stuclass_ids = params[:experiment][:stuclass_ids]
      @experiment.stuclass_ids = stuclass_ids

      # 给班级的同学发通知
      @experiment.stuclasses.includes(:students).each do |stuclass|
        stuclass.students.each do |student|
          # 向当前班级的同学发出通知
          Notification.create(user_id: student.id, title: "您有新的实验", content: "<a href=#{experiment_url(@experiment)}>#{@experiment.title}</a>", unread: true)
          # 通过ActionCable发送notice
          send_notice student
        end
      end

      flash[:success] = '新增实验成功'
      redirect_to experiments_url
    else
      render 'new'
    end
  end

  def show
    @experiment = Experiment.find(params[:id])
  end

  def destroy
    experiment = Experiment.find(params[:id])
    file_delete experiment.experimentfile
    experiment.destroy
    flash[:success] = '实验删除成功'
    redirect_to experiments_url
  end

  def edit
    @experiment = Experiment.find(params[:id])
  end

  def update
    @experiment = Experiment.find params[:id]
    if @experiment.update_attributes experiment_params
      # 建立实验和班级的关系
      stuclass_ids = params[:experiment][:stuclass_ids]
      @experiment.stuclass_ids = stuclass_ids

      flash[:success] = '作业资料修改成功'
      redirect_to @experiment
    else
      render 'edit'
    end
  end

  private

  def experiment_params
    params.require(:experiment).permit(:title, :description, :experimentfile)
  end

end
