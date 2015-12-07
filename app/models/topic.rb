class Topic < ActiveRecord::Base
  belongs_to :user
  # 一个话题可以有多个评论
  has_many :comments, dependent: :destroy

  validates_presence_of :title, :content
end
