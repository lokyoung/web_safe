module SessionsHelper
  def log_in(user)
    # 这里的session是一个内置的方法，和session控制器没有关系。会进行加密。
    session[:user_id] = user.id
  end

  # 返回当前登录的用户
  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      if user && user.authenticated(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 判断用户是否登录，已登录返回true，未登录返回false
  def logged_in?
    !current_user.nil?
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 安全退出
  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  # 存储请求的url
  def store_location
    session[:forward_url] = request.url if request.get?
  end

  # 重定向到之前存储的url，或者默认地址
  def redirect_back_or(default)
    redirect_to(session[:forward_url] || default)
    session.delete(:forward_url)
  end

  def teacher?
    current_user.type == "Teacher"
  end

  def isteacher?(user)
    user.type == "Teacher"
  end

  def student?
    current_user.type == "Student"
  end

end
