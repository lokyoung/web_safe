class NoticeJob < ApplicationJob

  def perform(notification_id)
    # ActionCable.server.broadcast "user:#{current_user.id}:notifications", { body: data }
    
  end

end
