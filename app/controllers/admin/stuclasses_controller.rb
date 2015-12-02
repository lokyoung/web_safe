class Admin::StuclassesController < Admin::AdminController
  def index
    @stuclasses = Stuclass.page params[:page]
  end

  def show
    @stuclass = Stuclass.find(params[:id])
  end

  def edit
    @stuclass = Stuclass.find(params[:id])
  end

  def destroy
    Stuclass.find(params[:id]).destroy
    flash[:success] = '班级删除成功'
    redirect_to admin_stuclasses_url
  end

  def update
    @stuclass = Stuclass.find(params[:id])
    if @stuclass.update_attributes(stuclass_params)
      flash[:success] = '班级信息修改成功'
      redirect_to admin_stuclasses_url
    else
      render 'edit'
    end
  end

  def remove_student
    @stuclass = Stuclass.find(params[:id])
    student = Student.find(params[:student_id])
    student.update_attributes(sclass: nil, stuclass_id: nil)
    flash[:success] = '移除学生成功'
    redirect_to admin_stuclass_url(@stuclass)
  end

  private

  def stuclass_params
    params.require(:stuclass).permit(:scname)
  end
end
