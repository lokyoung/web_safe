class Notification < ActiveRecord::Base
  belongs_to :user
  # 加上这条作用域才能获取未读通知的数量
  scope :unread, -> { where(unread: true) }

  validates_presence_of :title, :content
  after_commit :send_notification, on: :create

  def send_notification
    NotificationBroadcastJob.perform_later self
  end
end
