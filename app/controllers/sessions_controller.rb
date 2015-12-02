class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # success
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # redirect_to user_url(user)
      redirect_to root_url
    else
      # fail
      # flash[:danger] = '用户名或密码错误'
      # flash.now的内容会在下次请求中消失
      flash.now[:danger] = '用户名或密码错误'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
