class StuclassesController < ApplicationController
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
