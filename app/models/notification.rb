class Notification < ApplicationRecord
  belongs_to :user
  # 加上这条作用域才能获取未读通知的数量
  scope :unread, -> { where(unread: true) }

  validates_presence_of :title, :content
  after_create_commit { NotificationBroadcastJob.perform_later self }

  def send_notification
    NotificationBroadcastJob.perform_later self
  end
end
