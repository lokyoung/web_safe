class Admin::UsersController < Admin::AdminController
  def index
    @users = User.page params[:page]
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
      if params[:user][:type] == "Teacher"
        @user.stuclass_id = nil
        @user.sid = nil
        @user.save
      end
      flash[:success] = "资料修改成功"
      redirect_to admin_users_url
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = '用户删除成功'
    redirect_to admin_users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :type, :sid, :stuclass_id)
  end
end
