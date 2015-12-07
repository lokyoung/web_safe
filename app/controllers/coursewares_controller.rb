class CoursewaresController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_admin_user, only: [:new, :create, :update, :destroy]

  def index
    @coursewares = Courseware.page params[:page]
  end

  def new
    @courseware = Courseware.new
  end

  def create
    @courseware = current_user.coursewares.new(couresware_params)
    if @courseware.save
      flash[:success] = '上传课件成功'
      current_user.followers.each do |user|
        Notification.create(user_id: user.id, title: "你关注的用户<a href=#{user_url(current_user)}>#{current_user.name}</a>发布新课件", content: "<a href=#{courseware_url(@courseware)}>#{@courseware.title}</a>", unread: true)
        ActionCable.server.broadcast "user:#{user.id}", { body: user.notifications.unread.count.to_s }
      end
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
    redirect_to coursewares_url
  end

  private
  def couresware_params
    params.require(:courseware).permit(:title, :description, :coursefile)
  end

  def video_type
    ["mp4", "avi"]
  end
end
