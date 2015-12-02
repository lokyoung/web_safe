class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.order("created_at DESC").page params[:page]
    # @notifications.unread.each do |notification|
    #   notification.update_attributes(unread: false)
    # end
  end

  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy
    flash[:success] = '通知删除成功'
    redirect_to notifications_url
  end

  def clear
  end
end
