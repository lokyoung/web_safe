class Notification < ActiveRecord::Base
  belongs_to :user
  # 加上这条作用域才能获取未读通知的数量
  scope :unread, -> { where(unread: true) }
end
