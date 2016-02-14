class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    ActionCable.server.broadcast "user:#{notification.user.id}", { body: notification.user.notifications.unread.count.to_s }
  end
end
