class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  helper_method :unread_notify_count

  def unread_notify_count
    return 0 if current_user.blank?
    @unread_notify_count ||= current_user.notifications.unread.count
  end

  # 删除文件
  #def file_delete name
    #if File.exist? name
      #File.delete name
    #end
  #end

  def file_delete name
    file = name.to_s
    if File.exist? file
      File.delete file
    end
  end


  private

  def teacher_user
    redirect_to(root_url) unless teacher?
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "请先登录"
      redirect_to login_url
    end
  end
end
