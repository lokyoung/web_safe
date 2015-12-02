class Question < ActiveRecord::Base
  # 问题属于用户，多对一关系
  belongs_to :user, dependent: :destroy
  # 一个问题下面会有很多个答案，相应问题删除了，答案也被删除
  has_many :answers, dependent: :destroy

  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
end
