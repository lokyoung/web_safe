class Question < ApplicationRecord
  # 问题属于用户，多对一关系
  belongs_to :user
  # 一个问题下面会有很多个答案，相应问题删除了，答案也被删除
  has_many :answers, dependent: :destroy

  validates_presence_of :user_id, :title, :content
end
