class Admin::HomeworksController < Admin::AdminController
  def index
    @homeworks = Homework.page params[:page]
  end

  def edit
    @homework = Homework.find params[:id]
  end

  def update
    @homework = Homework.find params[:id]
    if @homework.update_attributes homework_params
      stuclass_ids = params[:homework][:stuclass_ids]
      @homework.stuclass_ids = stuclass_ids

      flash[:success] = '作业资料修改成功'
      redirect_to admin_homeworks_url
    else
      render 'edit'
    end
  end

  def destroy
    homework = Homework.find(params[:id])
    file_delete homework.homeworkfile
    homework.destroy
    flash[:success] = '作业删除成功'
    redirect_to admin_homeworks_url
  end

  private

  def homework_params
    params.require(:homework).permit(:title, :description, :homeworkfile)
  end

end
