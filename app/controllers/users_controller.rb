class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :follwers]
  before_action only: [:edit, :update] do
    @user = User.find(params[:id])
    correct_user @user
  end
  before_action :teacher_admin_user, only: :destroy

  #normal_item :new, :show, :index, :edit

  def index
    @users = User.page params[:page]
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save && verify_rucaptcha?(@user)
      # 注册后直接登录
      log_in @user
      flash[:success] = "注册成功，欢迎使用！"
      # redirect_to user_url(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    #if params[:user][:stuclass_id].present?
      # stuclass = Stuclass.where(scname: params[:user][:sclass])
      # stuclass << @user
      #@user.stuclass_id = Stuclass.find_by(scname: params[:user][:stuclass_id]).id
    #end

    if @user.update_attributes(user_params)
      # success
      flash[:success] = "资料修改成功"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    falsh[:success] = '用户已删除'
    redirect_to users_url
  end

  def stu_home
    @stuhomeworks = current_user.stuhomeworks
  end

  #def following
    #@title = "关注"
    #@user = User.find(params[:id])
    #@users = @user.following.page params[:page]
    #render 'show_follow'
  #end

  #def followers
    #@title = "关注者"
    #@user = User.find(params[:id])
    #@users = @user.followers.page params[:page]
    #render 'show_follow'
  #end

  def get_stuhomeworks
    @student = User.find params[:id]
    @stuhomeworks = @student.stuhomeworks.page params[:page]
    @homeworks = @student.stuclass.homeworks.page params[:page]
  end

  def get_my_topic
    @user = User.find params[:id]
    @topic = @user.topics.page params[:page]
    render 'show_my_topic'
  end

  private
  def user_params
    # 需要传入的params哈希参数包含:user元素，只允许传入name, email, passoword, password_confirmation属性
    # 如果没有指定:user会抛出异常
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :sid, :stuclass_id)
  end

  # 确保用户已经登录
  # def logged_in_user
  #   unless logged_in?
  #     store_location
  #     flash[:danger] = "请先登录"
  #     redirect_to login_url
  #   end
  # end

  # 确保是正确的用户
  #def correct_user
  #@user = User.find(params[:id])
  #redirect_to(root_url) unless current_user?(@user)
  #end

  # 确保当前用户是教师
  # def teacher_user
  #   redirect_to(root_ur) unless current_user.teacher?
  # end
end
