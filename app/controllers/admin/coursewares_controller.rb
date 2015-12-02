class Admin::CoursewaresController < Admin::AdminController
  def index
    @coursewares = Courseware.page params[:page]
  end

  def edit
    @courseware = Courseware.find params[:id]
  end

  def update
    @courseware = Courseware.find params[:id]
    if @courseware.update_attributes courseware_params
      flash[:success] = '课件资料修改成功'
      redirect_to admin_coursewares_url
    else
      render 'edit'
    end
  end

  def destroy
    courseware = Courseware.find(params[:id])
    file_delete courseware.coursefile
    courseware.destroy
    flash[:success] = '课件删除成功'
    redirect_to admin_coursewares_url
  end

  private

  def courseware_params
    params.require(:courseware).permit(:title, :description, :coursefile)
  end
end
