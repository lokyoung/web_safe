class StuclassesController < ApplicationController
  before_action :teacher_admin_user

  def index
    @stuclasses = Stuclass.page params[:page]
  end

  def new
    @stuclass = Stuclass.new
  end

  def create
    @stuclass = Stuclass.new(stuclass_params)
    if @stuclass.save
      flash[:success] = '添加班级成功'
      redirect_to stuclasses_url
    else
      render 'new'
    end
  end

  def show
    @stuclass = Stuclass.find(params[:id])
  end

  def edit
    @stuclass = Stuclass.find(params[:id])
  end

  def update
    @stuclass = Stuclass.find(params[:id])
    if @stuclass.update_attributes(stuclass_params)
      flash[:success] = '班级信息修改成功'
      redirect_to @stuclass
    else
      render 'edit'
    end
  end

  def destroy
    Stuclass.find(params[:id]).destroy
    flash[:success] = '班级删除成功'
    redirect_to stuclasses_url
  end

  private
    def stuclass_params
      params.require(:stuclass).permit(:scname)
    end
end
