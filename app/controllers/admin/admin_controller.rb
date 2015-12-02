class Admin::AdminController < ApplicationController
  before_action :admin_user
  layout "admin/application"

  private
  
  def admin_user
    unless current_user.type == "AdminUser"
      flash[:warning] = '您的权限不够，无法访问此页面'
      redirect_to root_url
    end
  end
end
