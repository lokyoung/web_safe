class Admin::StuhomeworksController < Admin::AdminController
  def index
    @homework = Homework.find params[:homework_id]
    @stuhomeworks = @homework.stuhomeworks.page params[:page]
  end

  def edit
    @stuhomework = Stuhomework.find params[:id]
  end

  def update
    @stuhomework = Stuhomework.find params[:id]
    #binding.pry
    if @stuhomework.update_attributes stuhomework_params
      flash[:success] = '学生作业资料修改成功'
      redirect_to admin_homework_stuhomeworks_url @stuhomework.homework
    else
      render 'edit'
    end
  end

  def destroy
    stuhomework = Stuhomework.find(params[:id])
    file_delete stuhomework.stuhomeworkfile
    stuhomework.destroy
    flash[:success] = '作业删除成功'
    redirect_to admin_homework_stuhomeworks_url stuhomework.homework
  end

  private

  def stuhomework_params
    params.require(:stuhomework).permit(:stuhomeworkfile, :mark, :remark, :ischecked)
  end

end
