class CoursewaresController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_admin_user, only: [:new, :create, :edit, :update, :destroy]
  before_action only: [:edit, :update, :destroy] do
    @courseware = Courseware.find params[:id]
    correct_user @courseware.user
  end

  def index
    @coursewares = Courseware.page params[:page]
  end

  def new
    @courseware = Courseware.new
  end

  def create
    @courseware = current_user.coursewares.new(courseware_params)
    if @courseware.save
      flash[:success] = '上传课件成功'
      if video_type.include? @courseware.coursefile.file.extension
        @courseware.isvideo = true
        @courseware.save
      end
      #create_followers_notification @courseware
      redirect_to coursewares_url
    else
      render 'new'
    end
  end

  def show
    @courseware = Courseware.find(params[:id])
    if video_type.include? @courseware.coursefile.file.extension
      render 'show_video'
    end
  end

  def edit
    @courseware = Courseware.find params[:id]
  end

  def update
    @courseware = Courseware.find params[:id]
    if @courseware.update_attributes courseware_params
      flash[:success] = '课件资料修改成功'
      redirect_to coursewares_url
    else
      render 'edit'
    end
  end


  def destroy
    courseware = Courseware.find(params[:id])
    file_delete courseware.coursefile
    courseware.destroy
    flash[:success] = '课件删除成功'
    redirect_to coursewares_url
  end

  private
  def courseware_params
    params.require(:courseware).permit(:title, :description, :coursefile)
  end

  def video_type
    ["mp4", "avi"]
  end
end
